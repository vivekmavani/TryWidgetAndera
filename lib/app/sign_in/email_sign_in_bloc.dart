import 'dart:async';

import 'package:trywidgests/app/sign_in/email_sign_in_model.dart';
import 'package:trywidgests/services/auth.dart';

class EmailSignInBloc {
  EmailSignInBloc({required this.auth});
  final AuthBase auth;
  final StreamController<EmailSignInModel> _modelControler = StreamController<EmailSignInModel>();
  Stream<EmailSignInModel> get modelStream => _modelControler.stream;
  EmailSignInModel _model = EmailSignInModel();
  void dispose(){
    _modelControler.close();
  }
  Future<void> submit() async{
    updateWith(submited: true,isLoading: true);
    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        await auth.createUserWithEmailAndPassword(_model.email,_model.password);
      }
    } catch(e)
    {
      updateWith(isLoading: false);
      rethrow;
    }
  }
  void toggleFormType(){
    final formType = _model.formType== EmailSignInFormType.signIn ? EmailSignInFormType.register :
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
    //update model
 _model = _model.copyWith(
   email: email,
   password: password,
   formType: formType,
   isLoading: isLoading,
   submited: submited,
 );
 //add updated model to _modelcntroller
    _modelControler.add(_model);
  }


}