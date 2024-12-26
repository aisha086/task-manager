import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../widgets/toast.dart';
import '../databases/user_service.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign Up with email and password
  Future<UserCredential?> signUpWithEmailAndPassword(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _auth.currentUser!.updateDisplayName(name);
      String? token = await FirebaseMessaging.instance.getToken();

      // After user is created, store user details in Firestore
      await UserService().storeUserDetails(userCredential.user!, name, email,token??'');

      // Sign out user after registration (if you don't want to auto-login)
      await _auth.signOut();

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast("The email is already in use.");
      } else if (e.code == 'invalid-email') {
        showToast("The email address is invalid");
      } else {
        showToast("An error occurred: ${e.code}");
      }
    }
    return null; // Return null if there's an error
  }


  // Sign In with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(credential.user);
      String? token = await FirebaseMessaging.instance.getToken();
      FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .update({'fcmToken': token});


      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        showToast("Invalid email");
      } else if (e.code == 'user-disabled') {
        showToast("The user is disabled");
      } else if (e.code == 'user-not-found') {
        showToast("User not found");
      } else if (e.code == 'wrong-password') {
        showToast("Wrong Password");
      } else {
        showToast("An error occurred: ${e.code}");
      }
    }
    return null;
  }


  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      showToast("Password reset link sent!, Check you email!");
      return true;
    } on FirebaseAuthException catch (e) {
      showToast(e.message.toString());
    }
    return false;
  }

  signInWithGoogle() async {
    try{
      //begin sign in process
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      //obtaining auth details from request
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      //create new credential
      final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken, idToken: gAuth.idToken);

      await _auth.signInWithCredential(credential);
      // if(_auth.currentUser != null) {
      //   await _auth.currentUser!.linkWithCredential(credential);
      print(_auth.currentUser!.uid);
      print(_auth.currentUser!.email);
      // }
      return;
    }
    catch(e){
      print("An error occurred $e");
      showToast("An error occurred $e");
    }
  }

  void signOut() async{
    try{
      await _auth.signOut();
      if( await GoogleSignIn().isSignedIn()){
        await GoogleSignIn().signOut();
      }

      showToast("Logged out successfully");
    }
    on FirebaseAuthException catch (e){
      showToast(e.message.toString());
    }
  }
}