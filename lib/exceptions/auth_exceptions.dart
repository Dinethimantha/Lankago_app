String mapFirebaseAuthExceptionCode(String errorCode) {
  switch (errorCode) {
    // signInWithEmailAndPassword
    case 'wrong-password':
      return 'The password is invalid or the account does not have a password set.';
    case 'invalid-email':
      return 'The email address is not valid.';
    case 'user-disabled':
      return 'The user corresponding to the given email has been disabled.';
    case 'user-not-found':
      return 'No user corresponding to the given email was found.';
      case 'invalid-credential':
  return 'Invalid login credentials.';
case 'internal-error':
  return 'Firebase internal error. Try again later.';


    // createUserWithEmailAndPassword
    case 'email-already-in-use':
      return 'An account already exists with the given email address.';
    case 'operation-not-allowed':
      return 'Email/password accounts are not enabled. Enable them in the Firebase Console.';
    case 'weak-password':
      return 'The password provided is not strong enough.';

    

    // signInWithEmailLink
    case 'expired-action-code':
      return 'The OTP in the email link has expired.';

    default:
      return errorCode;
  }
}
