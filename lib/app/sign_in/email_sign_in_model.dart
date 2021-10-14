import 'package:trywidgests/app/sign_in/validators.dart';

enum EmailSignInFormType {signIn, register}


class EmailSignInModel with EmailAndPasswordValidators{
  EmailSignInModel({
    this.email = '',
      this.password ='',
      this.formType = EmailSignInFormType.signIn,
      this.isLoading = false,
      this.submited = false});
    final String email;
    final String password;
    final EmailSignInFormType formType;
    final bool isLoading;
    final bool submited;

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
  EmailSignInModel copyWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submited,
}){
return EmailSignInModel(
  email: email ?? this.email,
  password: password ?? this.password,
  formType: formType ?? this.formType,
  isLoading: isLoading ?? this.isLoading,
  submited: submited ?? this.submited,
);
}
}