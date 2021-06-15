import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_memory/models/user_model.dart';
import 'package:flutter_memory/ui/auth/AuthExceptionHandler.dart';

enum Status {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  Registering
}
enum AuthResultStatus {
  successful,
  emailAlreadyExists,
  wrongPassword,
  invalidEmail,
  userNotFound,
  userDisabled,
  operationNotAllowed,
  tooManyRequests,
  undefined,
}
AuthResultStatus _authResultStatus;
/*
The UI will depends on the Status to decide which screen/action to be done.

- Uninitialized - Checking user is logged or not, the Splash Screen will be shown
- Authenticated - User is authenticated successfully, Home Page will be shown
- Authenticating - Sign In button just been pressed, progress bar will be shown
- Unauthenticated - User is not authenticated, login page will be shown
- Registering - User just pressed registering, progress bar will be shown

Take note, this is just an idea. You can remove or further add more different
status for your UI or widgets to listen.
 */

class AuthProvider extends ChangeNotifier {
  //Firebase Auth object
  auth.FirebaseAuth _auth;

  //Default status
  Status _status = Status.Uninitialized;

  Status get status => _status;
  AuthResultStatus get resultStatus => _authResultStatus;
  Stream<UserModel> get user => _auth.authStateChanges().map(_userFromFirebase);


  AuthProvider() {
    //initialise object
    _auth = auth.FirebaseAuth.instance;

    //listener for authentication changes such as user sign in and sign out
    _auth.authStateChanges().listen(onAuthStateChanged);
  }

  //Create user object based on the given FirebaseUser
  UserModel _userFromFirebase(auth.User user) {
    if (user == null) {

      return null;
    }

    return UserModel(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        phoneNumber: user.phoneNumber,
        photoURL: user.photoURL);
  }

  //Method to detect live auth changes such as user sign in and sign out
  Future<void> onAuthStateChanged(auth.User firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _userFromFirebase(firebaseUser);
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  //Method for new user registration using email and password
  // Future<UserModel> registerWithEmailAndPassword(
  //     String email, String password) async {
  //   try {
  //     _status = Status.Registering;
  //     notifyListeners();
  //     final AuthResult result = await _auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //
  //     return _userFromFirebase(result.user);
  //   } catch (e) {
  //     print("Error on the new user registration = " +e.toString());
  //     _authResultStatus = AuthExceptionHandler.handleException(e);
  //     _status = Status.Unauthenticated;
  //     notifyListeners();
  //     return null;
  //   }
  // }
  Future<UserModel> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      _status = Status.Registering;
      notifyListeners();
      final auth.UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      return _userFromFirebase(result.user);
    } catch (e) {
      print("Error on the new user registration = " +e.toString());
      _authResultStatus = AuthExceptionHandler.handleException(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      return null;
    }
  }
  //Method to handle user sign in using email and password
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print("Error on the sign in = " +e.toString());
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  //Method to handle password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  //Method to handle user signing out
  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }
}
