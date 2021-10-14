import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trywidgests/app/sign_in/email_sign_in_model.dart';
import 'package:trywidgests/app/sign_in/validators.dart';
import 'package:trywidgests/common_widgets/form_submit_button.dart';
import 'package:trywidgests/common_widgets/show_alert_dialog.dart';
import 'package:trywidgests/common_widgets/show_exception_alert_dialog.dart';
import 'package:trywidgests/services/auth.dart';



class EmailSignInFormStateful extends StatefulWidget with EmailAndPasswordValidators{

  @override
  _EmailSignInFormStatefulState createState() => _EmailSignInFormStatefulState();
}

class _EmailSignInFormStatefulState extends State<EmailSignInFormStateful> {

  final TextEditingController _emailControllor = TextEditingController();
  final TextEditingController _passwordControllor = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  EmailSignInFormType _formType = EmailSignInFormType.signIn;
  bool _submitted = false;
  bool _isLoading = false;
  String get _email  => _emailControllor.text;
  String get _password  => _passwordControllor.text;

  @override
  void dispose(){
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailControllor.dispose();
    _passwordControllor.dispose();
    super.dispose();
  }
  void _submit() async{
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context,listen: false);
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } on FirebaseAuthException catch(e)
    {
      showExceptionAlertDialog(context, exception: e, title: 'Sign in failed');
    }
    finally{
      setState(() {
        _isLoading = false;
      });
      _isLoading = false;
    }
  }
  void _toggleFormType() {
    setState(() {
      _submitted = false;
      _formType = _formType == EmailSignInFormType.signIn ? EmailSignInFormType.register :
      EmailSignInFormType.signIn;
    });
    _emailControllor.clear();
    _passwordControllor.clear();
  }

  void _emailEditigComplete(){
    final newFocus = widget.emailValiodator.isValid(_email)
        ?  _passwordFocusNode : _emailFocusNode;
  FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buidChildren(){
    final primaryText = _formType == EmailSignInFormType.signIn ?
        'Sign in' : 'Create an account';
    final secondaryText = _formType == EmailSignInFormType.signIn ?
    'Need an account? Register' : 'Have an account? Sign in';

    bool submitEnabled = widget.emailValiodator.isValid(_email) &&
        widget.passwordValiodator.isValid(_password) && !_isLoading;

    return [
      _buildEmailTextField(),
      SizedBox(height: 8.0,),
      _buildPasswordTextField(),
      SizedBox(height: 8.0,),
      FormSubmitButton(
        text: primaryText,
        onPressed: submitEnabled ? _submit : null,
      ),
      SizedBox(height: 8.0,),
      TextButton(onPressed: !_isLoading ? _toggleFormType : null, child: Text(secondaryText),),
    ];
  }

  TextField _buildEmailTextField() {
    bool showErrorText = _submitted && !widget.emailValiodator.isValid(_email);
  return   TextField(
      controller: _emailControllor,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'abc@gmail.com',
        enabled: _isLoading == false,
        errorText: showErrorText ? widget.invalidEmailErrorText : null,
      ),
      autocorrect: false,
      focusNode: _emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditigComplete,
      onChanged: (email) => _updateState(),
    );
  }

  TextField _buildPasswordTextField() {
    bool showErrorText = _submitted && !widget.passwordValiodator.isValid(_password);
   return  TextField(
      controller: _passwordControllor,
      decoration: InputDecoration(
        labelText: 'Password',
        enabled: _isLoading == false,
        errorText: showErrorText ? widget.invalidPasswordErrorText : null,
      ),
      obscureText: true,
      focusNode: _passwordFocusNode,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: (password) => _updateState(),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buidChildren(),
      ),
    );
  }

 void  _updateState() {
    setState(() {
    });
  }
}
