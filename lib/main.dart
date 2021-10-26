import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trywidgests/app/home/home_page.dart';
import 'package:trywidgests/app/landingpage.dart';
import 'package:trywidgests/services/auth.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) =>Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Time Tracker',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
       home: LandingPage(),
       // home: HomePageFirestore(),
      ),
    );
  }
}

