import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trywidgests/app/home/job_entries/job_entries_page.dart';
import 'package:trywidgests/app/home/jobs/edit_job_page.dart';
import 'package:trywidgests/app/home/jobs/empty_content.dart';
import 'package:trywidgests/app/home/jobs/job_list_tile.dart';
import 'package:trywidgests/app/home/jobs/list_items_builder.dart';
import 'package:trywidgests/app/home/models/job.dart';
import 'package:trywidgests/common_widgets/show_alert_dialog.dart';
import 'package:trywidgests/common_widgets/show_exception_alert_dialog.dart';
import 'package:trywidgests/services/auth.dart';
import 'package:trywidgests/services/database.dart';

class JobsPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(context,
        defalutActionText: 'Logout',
        content: 'Are you sure that you want to logout?',
        title: 'Logout',
        cancleActiontext: 'Cancel');
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  Future<void> _delete(BuildContext context, Job job) async {
    try{
        final database = Provider.of<Database>(context,listen: false);
       await database.deleteJob(job);
    }on FirebaseException catch(e){
       showExceptionAlertDialog(
         context,
         title: 'Operation failed',
         exception: e,);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        actions: [
         IconButton(
           icon : Icon(Icons.add,color: Colors.white,),
           onPressed:  () => EditJobPage.show(context,database :Provider.of<Database>(context,listen: false)),
         ),

        ],
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context,listen: false);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context,snapshot) {
          return ListItemsBuilder<Job>(
          snapshot: snapshot,
          itemBuilder: (context, job) => Dismissible(
            key: Key('job-${job.id}'),
            background: Container(color: Colors.red,),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context,job),
            child: JobListTile(
              job: job,
              onTap: () => JobEntriesPage.show(context, job),
            ),
          ),
        );

        //print(snapshot.data);
     /*   if (snapshot.hasData) {
          final jobs = snapshot.data;
          if (jobs!.isNotEmpty) {
            final children = jobs
                .map((job) => JobListTile(
                      job: job,
                      onTap: () => EditJobPage.show(context, job: job),
                    ))
                .toList();
            return ListView(
              children: children,
            );
          }
          return EmptyContent();
        }
        if (snapshot.hasError) {
          return Center(child: Text('Some error occurred'));
        }
        return Center(child: CircularProgressIndicator());*/
      },
    );
  }


}
