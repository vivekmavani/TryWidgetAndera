import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trywidgests/app/sign_in/sign_in_button.dart';
import 'package:trywidgests/app/sign_in/social_sign_in_button.dart';
import 'package:trywidgests/common_widgets/custom_raised_button.dart';

class SignInPage extends StatelessWidget {
  //const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TIme Tracker'),
        elevation: 2.0,
      ),
      body: _bodyContent(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _bodyContent() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Sign In',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 48.0,
          ),
          SocialSignInButton(
            assetName: 'images/google-logo.png',
            text: 'Sign in with Google',
            textcolor: Colors.black87,
            color: Colors.white,
            onpressed: () {},
          ),
          SizedBox(
            height: 8.0,
          ),
          SocialSignInButton(
            assetName: 'images/facebook-logo.png',
            text: 'Sign in with Facebook',
            textcolor: Colors.white,
            color: Color(0xFF334D92),
            onpressed: () {},
          ),
          SizedBox(
            height: 8.0,
          ),
          SignInButton(
            text: 'Sign in with email',
            textcolor: Colors.white,
            color: Colors.teal[700],
            onpressed: () {},
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            'or',
            style: TextStyle(color: Colors.black87, fontSize: 14.0),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 8.0,
          ),
          SignInButton(
            text: 'Sign in with anonymous',
            textcolor: Colors.black,
            color: Colors.lime[300],
            onpressed: () {},
          ),
        ],
      ),
    );
  }
}
