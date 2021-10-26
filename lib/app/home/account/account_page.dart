import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trywidgests/common_widgets/avtar.dart';
import 'package:trywidgests/common_widgets/show_alert_dialog.dart';
import 'package:trywidgests/services/auth.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        actions: [
          TextButton(
            onPressed: () => _confirmSignOut(context),
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: _buildUserInfo(auth.currentUser),
        ),
      ),
    );
  }

 Widget  _buildUserInfo(User? user) {
    return Column(
      children: [
        Avatar(photoUrl: user!.photoURL, radius: 50,),
        SizedBox(height: 8,),
        if(user.displayName != null)
            Text(
              user.displayName!,
              style: TextStyle(color:Colors.white),
            ),
        SizedBox(height: 8,),
      ],
    );
 }
}
