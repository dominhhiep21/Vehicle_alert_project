import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void signUp(String email, String pass, String name, String phone,
      Function onSuccess, Function(String) onRegisterError) {
    _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: pass)
        .then((UserCredential userCredential) {
      _createUser(userCredential.user!.uid, name, phone, onSuccess, onRegisterError);
    }).catchError((err) {
      print("Error: " + err.toString());
      _onSignUpErr(err.code, onRegisterError);
    });
  }

  void signIn(String email, String pass, Function onSuccess,
      Function(String) onSignInError) {
    _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((UserCredential userCredential) {
      onSuccess();
    }).catchError((err) {
      print("Error: " + err.toString());
      onSignInError("Sign-In failed, please try again");
    });
  }

  void _createUser(String userId, String name, String phone, Function onSuccess,
      Function(String) onRegisterError) {
    Map<String, String> user = {
      "name": name,
      "phone": phone,
    };

    var ref = FirebaseFirestore.instance.collection("users");
    ref.doc(userId).set(user).then((_) {
      print("User created successfully");
      onSuccess();
    }).catchError((err) {
      print("Error: " + err.toString());
      onRegisterError("Sign-Up failed, please try again");
    }).whenComplete(() {
      print("Operation completed");
    });
  }

  void _onSignUpErr(String code, Function(String) onRegisterError) {
    print(code);
    switch (code) {
      case "invalid-email":
      case "invalid-credential":
        onRegisterError("Invalid email");
        break;
      case "email-already-in-use":
        onRegisterError("Email is already in use");
        break;
      case "weak-password":
        onRegisterError("The password is not strong enough");
        break;
      default:
        onRegisterError("Sign-Up failed, please try again");
        break;
    }
  }

  Future<void> signOut() async {
    print("Signing out");
    return _firebaseAuth.signOut();
  }
}
