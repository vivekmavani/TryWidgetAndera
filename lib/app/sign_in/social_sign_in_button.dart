import 'package:flutter/cupertino.dart';
import 'package:trywidgests/common_widgets/custom_raised_button.dart';

class SocialSignInButton extends CustomRaisedButton {
  SocialSignInButton({
    @required String assetName,
    @required String text,
    Color color,
    Color textcolor,
    VoidCallback onpressed,
  }) :  assert(assetName!= null,text != null), super(
    child:  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(assetName),
        Text(text,style: TextStyle(color: textcolor,fontSize: 15.0),),
        Opacity(
          opacity: 0.0,
          child: Image.asset(assetName),
        ),
      ],
    ),
    color: color,
    onPressed: onpressed,
  );
}
