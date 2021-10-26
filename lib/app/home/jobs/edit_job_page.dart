import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trywidgests/app/home/models/job.dart';
import 'package:trywidgests/common_widgets/show_alert_dialog.dart';
import 'package:trywidgests/common_widgets/show_exception_alert_dialog.dart';
import 'package:trywidgests/services/database.dart';

class EditJobPage extends StatefulWidget {
  EditJobPage({Key? key, required this.database, this.job}) : super(key: key);
 final Job? job;
  final Database database;

  static Future<void> show(BuildContext context, {Database? database,Job? job}) async {
    //context pass here for accessing database in _submit method
//    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context,rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditJobPage(
          database: database!,
          job: job,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formkey = GlobalKey<FormState>();

  bool _isLoading = false;
   String? _name;
   int? _ratePerHour;

  @override
  void initState() {
    super.initState();
    if(widget.job != null)
      {
        _name = widget.job!.name;
        _ratePerHour = widget.job!.ratePerHour;
      }
  }

  bool _validateAndSaveForm() {
    final form = _formkey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allName = jobs.map((job) => job.name).toList();
        if(widget.job != null)
          {
            allName.remove(widget.job!.name);
          }
        if (allName.contains(_name)) {
          showAlertDialog(
            context,
            defalutActionText: 'OK',
            content: 'Please choose different Job name',
            title: 'Name already used',
          );
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Job(name: _name!, ratePerHour: _ratePerHour!, id: id);
          await widget.database.setJob(job);

          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(context,
            exception: e, title: 'Operation failed');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
        elevation: 2.0,
        actions: [
          TextButton(
              onPressed: _isLoading ? null : _submit,
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey.shade200,
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Job name'),
        validator: (value) =>
            value!.isNotEmpty ? null : 'Job name can\'t be empty',
        onSaved: (value) => _name = value!,
        textInputAction: TextInputAction.next,
        initialValue: _name,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Rate per hour'),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (value) =>
            value!.isNotEmpty ? null : 'Rate per hour can\'t be empty',
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _ratePerHour = int.parse(value!),
        textInputAction: TextInputAction.done,
        onEditingComplete: _submit,
        initialValue: _ratePerHour != null ? '$_ratePerHour': '',
      ),
    ];
  }
}
