

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trywidgests/app/sign_in/email_sign_in_change_model.dart';
import 'package:trywidgests/common_widgets/form_submit_button.dart';
import 'package:trywidgests/common_widgets/show_exception_alert_dialog.dart';
import 'package:trywidgests/services/auth.dart';



class EmailSignInFormChangeNotifier extends StatefulWidget {
  EmailSignInFormChangeNotifier({required this.model});
  final EmailSignInChangeModel model;

  static Widget create(BuildContext context){
    final auth = Provider.of<AuthBase>(context,listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth:auth),
     child: Consumer<EmailSignInChangeModel>(
       builder: (_,model,__) => EmailSignInFormChangeNotifier(model:model),
     ),
    );
  }
  @override
  _EmailSignInFormChangeNotifierState createState() => _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState extends State<EmailSignInFormChangeNotifier> {

  final TextEditingController _emailControllor = TextEditingController();
  final TextEditingController _passwordControllor = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  EmailSignInChangeModel get model => widget.model;

  @override
  void dispose(){
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailControllor.dispose();
    _passwordControllor.dispose();
    super.dispose();
  }
  void _submit() async{

    try {
     await model.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch(e)
    {
      showExceptionAlertDialog(context, exception: e, title: 'Sign in failed');
    }
  }
  void _toggleFormType() {
    model.toggleFormType();
    _emailControllor.clear();
    _passwordControllor.clear();
  }

  void _emailEditigComplete(){
    final newFocus = model.emailValiodator.isValid(model.email)
        ?  _passwordFocusNode : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buidChildren(){
    return [
      _buildEmailTextField(),
      SizedBox(height: 8.0,),
      _buildPasswordTextField(),
      SizedBox(height: 8.0,),
      FormSubmitButton(
        text: model.primaryButtonText,
        onPressed: model.canSubmit ? _submit : null,
      ),
      SizedBox(height: 8.0,),
      TextButton(onPressed: !model.isLoading ? _toggleFormType : null, child: Text(model.secondaryButtonText),),
    ];
  }

  TextField _buildEmailTextField() {
    return   TextField(
      controller: _emailControllor,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'abc@gmail.com',
        enabled: model.isLoading == false,
        errorText: model.emailErrorText,
      ),
      autocorrect: false,
      focusNode: _emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditigComplete,
      onChanged:  model.updateEmail,
    );
  }

  TextField _buildPasswordTextField() {
    return  TextField(
      controller: _passwordControllor,
      decoration: InputDecoration(
        labelText: 'Password',
        enabled:model.isLoading == false,
        errorText: model.passwordErrorText,
      ),
      obscureText: true,
      focusNode: _passwordFocusNode,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: model.updatePassword,
    );
  }
  @override
  Widget build(BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: _buidChildren(),
          ),
        );
      }
  }
