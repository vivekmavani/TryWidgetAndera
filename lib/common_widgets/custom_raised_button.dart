import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  // const CustomRaisedButton({Key? key}) : super(key: key);

  CustomRaisedButton({
    this.child,
    this.color,
    this.borderRadius : 4.0,
    this.height : 50.0,
    this.onPressed,
  });

  final Widget child;
  final Color color;
  final double borderRadius;
  final double height;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RaisedButton(
        child: child,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.all(
            Radius.circular(borderRadius),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
