import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final _auth = FirebaseAuth.instance;

   Future<UserCredential>signUp(String email, String pass) async {
    final authResult = await _auth.createUserWithEmailAndPassword(
        email: email, password: pass);
    return authResult;
  }

  // AuthResult Class is Renamed to User Credential :)

  Future<UserCredential> signIn(String email, String pass) async {
    final authResult = await _auth.signInWithEmailAndPassword(email: email, password: pass);
    return authResult;
  }


  Future<void>signOut()async{

     await _auth.signOut();
  }
}
