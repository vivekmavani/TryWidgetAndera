

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trywidgests/app/sign_in/email_sign_in_bloc.dart';
import 'package:trywidgests/app/sign_in/email_sign_in_model.dart';
import 'package:trywidgests/common_widgets/form_submit_button.dart';
import 'package:trywidgests/common_widgets/show_exception_alert_dialog.dart';
import 'package:trywidgests/services/auth.dart';



class EmailSignInFormBlocBased extends StatefulWidget {
  EmailSignInFormBlocBased({required this.bloc});
  final EmailSignInBloc bloc;

  static Widget create(BuildContext context){
    final auth = Provider.of<AuthBase>(context,listen: false);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth:auth),
     child: Consumer<EmailSignInBloc>(
       builder: (_,bloc,__) => EmailSignInFormBlocBased(bloc:bloc),
     ),
      dispose:(_,bloc)=> bloc.dispose(),
    );
  }
  @override
  _EmailSignInFormBlocBasedState createState() => _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {

  final TextEditingController _emailControllor = TextEditingController();
  final TextEditingController _passwordControllor = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();


  @override
  void dispose(){
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailControllor.dispose();
    _passwordControllor.dispose();
    super.dispose();
  }
  void _submit() async{

    try {
     await widget.bloc.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch(e)
    {
      showExceptionAlertDialog(context, exception: e, title: 'Sign in failed');
    }
  }
  void _toggleFormType() {
    widget.bloc.toggleFormType();
    _emailControllor.clear();
    _passwordControllor.clear();
  }

  void _emailEditigComplete(EmailSignInModel model){
    final newFocus = model.emailValiodator.isValid(model.email)
        ?  _passwordFocusNode : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buidChildren(EmailSignInModel model){
    return [
      _buildEmailTextField(model),
      SizedBox(height: 8.0,),
      _buildPasswordTextField(model),
      SizedBox(height: 8.0,),
      FormSubmitButton(
        text: model.primaryButtonText,
        onPressed: model.canSubmit ? _submit : null,
      ),
      SizedBox(height: 8.0,),
      TextButton(onPressed: !model.isLoading ? _toggleFormType : null, child: Text(model.secondaryButtonText),),
    ];
  }

  TextField _buildEmailTextField(EmailSignInModel model) {
    return   TextField(
      controller: _emailControllor,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'abc@gmail.com',
        enabled: model.isLoading == false,
        errorText: model.emailErrorText,
      ),
      autocorrect: false,
      focusNode: _emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: ()=>_emailEditigComplete(model),
      onChanged:  widget.bloc.updateEmail,
    );
  }

  TextField _buildPasswordTextField(EmailSignInModel model) {
    return  TextField(
      controller: _passwordControllor,
      decoration: InputDecoration(
        labelText: 'Password',
        enabled:model.isLoading == false,
        errorText: model.passwordErrorText,
      ),
      obscureText: true,
      focusNode: _passwordFocusNode,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: widget.bloc.updatePassword,
    );
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
      stream: widget.bloc.modelStream,
      initialData: EmailSignInModel(),
      builder: (context, snapshot) {
        final EmailSignInModel? model = snapshot.data;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: _buidChildren(model!),
          ),
        );
      }
    );
  }


}
