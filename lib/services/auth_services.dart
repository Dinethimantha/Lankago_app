import 'package:google_sign_in/google_sign_in.dart';
import 'package:lanka_go/exceptions/auth_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //create user with email & password
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    //implementation for creating user
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      print('Error creating user: ${error.code}');
      throw Exception(mapFirebaseAuthExceptionCode(error.code));
    } catch (error) {
      print('Error creating user: $error');
    }
  }

  //signin with email&password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    //implementation for signing in user
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      print('Error signing in user: ${error.code}');
      throw Exception(mapFirebaseAuthExceptionCode(error.code));
    } catch (error) {
      print('Error signing in user: $error');
    }
  }

  //sign in with google
  Future<void> signInWithGoogle() async {
    //  Force Google to ask for account every time
    await _googleSignIn.signOut();
    try {
      // Google sign-in logic
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google UserCredential
      await _auth.signInWithCredential(credential);
    } catch (error) {
      print('Error signing in with Google: $error');
    }
  }

  //send password reset email
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print("Password reset email sent to $email");
    } on FirebaseAuthException catch (error) {
      print(
        'Error sending password reset email: ${mapFirebaseAuthExceptionCode(error.code)}',
      );
      throw Exception(mapFirebaseAuthExceptionCode(error.code));
    } catch (error) {
      print('Error sending password reset email: $error');
    }
  }

  // log out

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('Signed out');
    } on FirebaseAuthException catch (e) {
      print('Error signing out: ${mapFirebaseAuthExceptionCode(e.code)}');
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}


// Get current UID
final uid = FirebaseAuth.instance.currentUser!.uid;
