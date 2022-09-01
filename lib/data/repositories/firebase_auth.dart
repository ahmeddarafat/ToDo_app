import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_todo_app/data/repositories/user_repository.dart';

class FirebaseAuthRepo implements UserRepository {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseStore = FirebaseFirestore.instance;

  @override
  Future<void> login({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException {
      throw 'email address or password is not correct';
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> register(
      {required String fullname,
      required String email,
      required String password}) async {
    try {
      await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((cred) {
        cred.user!.updateDisplayName(fullname);
        _firebaseStore.collection('users').doc(cred.user!.uid).set({
          'email': cred.user!.email,
        });
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw 'The account already exists for that email.';
      } else {
        throw 'Please check your email address.';
      }
    } catch (e) {
      throw Exception('oops,Something wrong happend!');
    }
  }

  @override
  logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signInAnonymously() async {
    try {
      await _firebaseAuth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.toString());
    }
  }

  /// social authentication
  Future<void> googleSignIn() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // Once signed in, return the UserCredential
      await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }

  /// there is an error need to debug
  /// error: lgoin result is failed , so accessToken is null
  /// so, praint  check null operator used on null value
  Future<void> facebookSignIn() async {
    try {
      final LoginResult facebookLoginResult =
          await FacebookAuth.instance.login();

      // final Map<String, dynamic> facebookLoginAuth =
      //     await FacebookAuth.instance.getUserData();

      final LoginResult result = await FacebookAuth.instance.login();
      // you are logged
      final AccessToken accessToken = result.accessToken!;
      print("the status " + result.status.toString());
      print("the message " + result.message.toString());

      final OAuthCredential facebookCredential =
          FacebookAuthProvider.credential(
              facebookLoginResult.accessToken!.token);

      await FirebaseAuth.instance.signInWithCredential(facebookCredential);
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }
}
