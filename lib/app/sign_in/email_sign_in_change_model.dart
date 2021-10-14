import 'package:flutter/foundation.dart';
import 'package:trywidgests/app/sign_in/email_sign_in_model.dart';
import 'package:trywidgests/app/sign_in/validators.dart';
import 'package:trywidgests/services/auth.dart';




class EmailSignInChangeModel with EmailAndPasswordValidators,ChangeNotifier{
  EmailSignInChangeModel({
    required this.auth,
    this.email = '',
      this.password ='',
      this.formType = EmailSignInFormType.signIn,
      this.isLoading = false,
      this.submited = false});
  final AuthBase auth;
     String email;
     String password;
     EmailSignInFormType formType;
     bool isLoading;
     bool submited;

  Future<void> submit() async{
    updateWith(submited: true,isLoading: true);
    try {
      if (formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(email, password);
      } else {
        await auth.createUserWithEmailAndPassword(email,password);
      }
    } catch(e)
    {
      updateWith(isLoading: false);
      rethrow;
    }
  }

    String get primaryButtonText{
     return formType == EmailSignInFormType.signIn ?
      'Sign in' : 'Create an account';
    }
    String? get passwordErrorText{
      bool showErrorText =submited && !passwordValiodator.isValid(password);
      return showErrorText ? invalidPasswordErrorText : null;
    }
  String? get emailErrorText{
    bool showErrorText =submited && !emailValiodator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

   String get secondaryButtonText{
     return formType == EmailSignInFormType.signIn ?
     'Need an account? Register' : 'Have an account? Sign in';
   }
   bool get canSubmit{
     return emailValiodator.isValid(email) &&
         passwordValiodator.isValid(password) && !isLoading;
   }
  void toggleFormType(){
    final formType = this.formType== EmailSignInFormType.signIn ? EmailSignInFormType.register :
    EmailSignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      formType: formType,
      isLoading: false,
      submited: false,
    );
  }
  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);
 void updateWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submited,
}){

  this.email= email ?? this.email;
  this.password= password ?? this.password;
  this.formType= formType ?? this.formType;
  this.isLoading= isLoading ?? this.isLoading;
  this.submited= submited ?? this.submited;
  notifyListeners();
}
}