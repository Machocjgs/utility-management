import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {

  Future<String> signIn(String email, String password);

  Future<String> signUp(String phone, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> signOut();

  Future<String> signInMobile(String verificationID, String smsCode, String mobile, String email, String password);

  Future<String> verifyMobile(String mobile, void Function(String, [int]) onCodeSent);

}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> verifyMobile(String mobile, void Function(String, [int]) onCodeSent) async {
    String verifID;
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: mobile,
      timeout: Duration(seconds: 0),
      verificationCompleted: null,
      verificationFailed: (AuthException authException) => print("ERROR: ${authException.message}"),
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: null
    );
    return verifID;
  }

  Future<String> signInMobile(String verificationID, String smsCode, String mobile, String email, String password) async {
    AuthResult result;
    FirebaseUser user;
    AuthCredential _auth = 
      PhoneAuthProvider.getCredential(verificationId: verificationID, smsCode: smsCode);
    try {
      await _firebaseAuth.signInWithCredential(_auth);
      result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password); 
    } catch (error) {
      if (error.toString().contains('[ App validation failed. Is app running on a physical device? ]')) {
        result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      }
    }

    if(result != null && result.user != null) {
      user = result.user;
      return user.uid;
    } else {
      return null;
    }
  }
  
  Future<String> signIn(String email, String password) async{
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password
    );
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }
  
  Future<String> signUp(String phone, String password){

  }

  Future<void> signOut(){
    return _firebaseAuth.signOut();
  }
  


}

