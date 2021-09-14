import 'package:flutter/cupertino.dart';
import 'package:trywidgests/common_widgets/custom_raised_button.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    @required String text,
    Color color,
    Color textcolor,
    VoidCallback onpressed,
  }) : assert(text != null),
       super(
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
