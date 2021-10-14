import 'package:flutter/cupertino.dart';
import 'package:trywidgests/common_widgets/custom_raised_button.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    required String text,
    required Color color,
    required Color textcolor,
     VoidCallback? onpressed,
  }) : super(
          child: Text(
            text,
            style: TextStyle(
              color: textcolor,
              fontSize: 15.0,
            ),
          ),
          color: color,
          onPressed: onpressed,
        );
}
