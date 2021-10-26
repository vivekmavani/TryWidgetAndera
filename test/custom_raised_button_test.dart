import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trywidgests/common_widgets/custom_raised_button.dart';

void main(){
  testWidgets('',(WidgetTester tester) async{
    await tester.pumpWidget(MaterialApp(home:CustomRaisedButton(color: Colors.white, child: Text(''),)));
  });

  
}