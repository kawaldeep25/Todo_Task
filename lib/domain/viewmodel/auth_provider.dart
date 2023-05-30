import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_list/core/constants/app_consts.dart';
import 'package:todo_list/core/enums/status.dart';
import 'package:todo_list/core/utils/show_snackbar.dart';
import 'package:todo_list/domain/models/user_model.dart';

/*
The UI will depends on the [Status] object to decide which screen/action to be done.

- Uninitialized - Checking user is logged or not, the Splash Screen will be shown
- Authenticated - User is authenticated successfully, Home Page will be shown
- Authenticating - Sign In button just been pressed, progress bar will be shown
- Unauthenticated - User is not authenticated, login page will be shown
- Registering - User just pressed registering, progress bar will be shown

 */

class AuthProvider extends ChangeNotifier {
  //Firebase Auth object
  late FirebaseAuth _auth;
  late GoogleSignIn _googleSignIn;

  //Default status
  Status _status = Status.Uninitialized;

  Status get status => _status;

  Stream<UserModel> get user => _auth.authStateChanges().map(_userFromFirebase);

  AuthProvider() {
    //initialise object
    _auth = FirebaseAuth.instance;
    _googleSignIn = GoogleSignIn(clientId: AppConsts.googleSignInKey);

    //listener for authentication changes such as user sign in and sign out
    _auth.authStateChanges().listen(onAuthStateChanged);
  }

  //Create user object based on the given User
  UserModel _userFromFirebase(User? user) {
    if (user == null) {
      return UserModel(displayName: 'Null', uid: 'null');
    }

    return UserModel(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        phoneNumber: user.phoneNumber,
        photoUrl: user.photoURL);
  }

  //Method to detect live auth changes such as user sign in and sign out
  //Authenticated is only set here
  Future<void> onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _userFromFirebase(firebaseUser);
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  //Method for new user registration using email and password
  Future<UserModel> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      _status = Status.Registering;
      notifyListeners();
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      return _userFromFirebase(result.user);
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return UserModel(displayName: 'Null', uid: 'null');
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
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  //Method to handle Google SignIn
  Future<bool> signInWithGoogle(BuildContext context) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        googleProvider.addScope(AppConsts.readOnly);

        await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
          // Create a new credential
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth?.accessToken,
            idToken: googleAuth?.idToken,
          );
          UserCredential userCredential =
              await _auth.signInWithCredential(credential);
        }
      }
    } on FirebaseAuthException catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      showSnackBar(context, e.message!,
          color: Colors.red); // Displaying the error message
      return false;
    }
    return true;
  }

  //Method to handle user signing out
  Future signOut() async {
    try {
      await _auth.signOut();
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
      _status = Status.Unauthenticated;
      notifyListeners();
      return Future.delayed(Duration.zero);
    } catch (e) {
      print(e.toString()); // Displaying the error message
    }
  }
}
