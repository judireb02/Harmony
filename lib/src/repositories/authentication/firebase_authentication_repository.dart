import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:twitter_login/entity/auth_result.dart';
import 'package:twitter_login/twitter_login.dart';

enum AuthProvider { google, facebook, twitter }

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;
  final TwitterLogin _twitterLogin;

  AuthenticationRepository({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    FacebookAuth? facebookAuth,
    TwitterLogin? twitterLogin,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ??
            GoogleSignIn(
                signInOption: SignInOption.standard,
                scopes: <String>[
                  'email',
                  'https://www.googleapis.com/auth/userinfo.profile',
                ],
                clientId:
                    "782380864868-ace299mq0i1he8m6unv2jadsj0d103mq.apps.googleusercontent.com"),
        _facebookAuth = facebookAuth ?? FacebookAuth.instance,
        _twitterLogin = twitterLogin ??
            TwitterLogin(
              apiKey: 'YOUR_TWITTER_API_KEY',
              apiSecretKey: 'YOUR_TWITTER_API_SECRET',
              redirectURI: 'YOUR_REDIRECT_URI',
            );

  // Get current authenticated user
  User? get currentUser => _firebaseAuth.currentUser;

  // Stream of authentication state changes
  Stream<User?> get user => _firebaseAuth.authStateChanges();

  // Google Sign-In
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      print('Google Sign-In Error: $e');
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'account-exists-with-different-credential':
            throw Exception(
                'The account already exists with a different credential.');
          case 'invalid-credential':
            throw Exception('The credential is invalid or expired.');
          case 'operation-not-allowed':
            throw Exception(
                'Operation not allowed. Enable Google sign-in in the Firebase console.');
          case 'user-disabled':
            throw Exception('This user has been disabled.');
          case 'user-not-found':
            throw Exception('User not found.');
          default:
            throw Exception('An unknown error occurred.');
        }
      } else {
        throw Exception('An unknown error occurred.');
      }
    }
  }

  // Facebook Sign-In
  Future<UserCredential?> signInWithFacebook() async {
    try {
      final LoginResult result = await _facebookAuth.login();
      if (result.status != LoginStatus.success) return null;

      final OAuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken!.token);

      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      print('Facebook Sign-In Error: $e');
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'account-exists-with-different-credential':
            throw Exception(
                'The account already exists with a different credential.');
          case 'invalid-credential':
            throw Exception('The credential is invalid or expired.');
          case 'operation-not-allowed':
            throw Exception(
                'Operation not allowed. Enable Facebook sign-in in the Firebase console.');
          case 'user-disabled':
            throw Exception('This user has been disabled.');
          case 'user-not-found':
            throw Exception('User not found.');
          default:
            throw Exception('An unknown error occurred.');
        }
      } else {
        throw Exception('An unknown error occurred.');
      }
    }
  }

  // Twitter Sign-In
  Future<UserCredential?> signInWithTwitter() async {
    try {
      final AuthResult result = await _twitterLogin.login();
      if (result.status != TwitterLoginStatus.loggedIn) return null;

      final OAuthCredential credential = TwitterAuthProvider.credential(
        accessToken: result.authToken!,
        secret: result.authTokenSecret!,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      print('Twitter Sign-In Error: $e');
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'account-exists-with-different-credential':
            throw Exception(
                'The account already exists with a different credential.');
          case 'invalid-credential':
            throw Exception('The credential is invalid or expired.');
          case 'operation-not-allowed':
            throw Exception(
                'Operation not allowed. Enable Twitter sign-in in the Firebase console.');
          case 'user-disabled':
            throw Exception('This user has been disabled.');
          case 'user-not-found':
            throw Exception('User not found.');
          default:
            throw Exception('An unknown error occurred.');
        }
      } else {
        throw Exception('An unknown error occurred.');
      }
    }
  }

  // Sign in with specific provider
  Future<UserCredential?> signIn(AuthProvider provider) async {
    switch (provider) {
      case AuthProvider.google:
        return await signInWithGoogle();
      case AuthProvider.facebook:
        return await signInWithFacebook();
      case AuthProvider.twitter:
        return await signInWithTwitter();
    }
  }

  // Sign In with Email and Password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Email/Password Sign-In Error: $e');
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-email':
            throw Exception('The email address is badly formatted.');
          case 'user-disabled':
            throw Exception('This user has been disabled.');
          case 'user-not-found':
            throw Exception('User not found.');
          case 'invalid-password':
            throw Exception('Incorrect password.');
          case 'invalid-credential':
            throw Exception('Incorrect credentials');
          default:
            throw Exception(e.message);
        }
      } else {
        throw Exception('An unknown error occurred.');
      }
    }
  }

  // Sign Up with Email and Password
  Future<UserCredential?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Email/Password Sign-Up Error: $e');
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            throw Exception(
                'The email address is already in use by another account.');
          case 'invalid-email':
            throw Exception('The email address is badly formatted.');
          case 'operation-not-allowed':
            throw Exception(
                'Operation not allowed. Enable Email/Password sign-in in the Firebase console.');
          case 'weak-password':
            throw Exception('The password is too weak.');
          default:
            throw Exception('An unknown error occurred.');
        }
      } else {
        throw Exception('An unknown error occurred.');
      }
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _facebookAuth.logOut();
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Sign Out Error: $e');
      throw Exception('An unknown error occurred during sign out.');
    }
  }
}
