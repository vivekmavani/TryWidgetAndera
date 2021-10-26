import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trywidgests/app/home/home_page.dart';
import 'package:trywidgests/app/sign_in/sign_in_page.dart';
import 'package:trywidgests/services/auth.dart';
import 'package:trywidgests/services/database.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return SignInPage.create(context);
          } else {
            return Provider<Database>(
              create: (_) => FirestoreDatabase(uid: user.uid),
              //child: JobsPage(),
              child: HomePage(),
            //  child: HomePageFirestore(),
            );
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
