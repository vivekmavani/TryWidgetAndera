


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trywidgests/common_widgets/show_alert_dialog.dart';

Future<void> showExceptionAlertDialog  (
BuildContext context,{
required String title,
 required Exception exception,
}
)=>showAlertDialog(context,defalutActionText: 'OK', content: exception.toString(), title: title
);

/*
String? _message(Exception exception){
  if(exception is FirebaseException){
    return exception.message;
  }
  return exception.toString();
}*/
