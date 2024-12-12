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
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _facebookAuth = facebookAuth ?? FacebookAuth.instance,
        _twitterLogin = twitterLogin ?? TwitterLogin(
          apiKey: 'YOUR_TWITTER_API_KEY',
          apiSecretKey: 'YOUR_TWITTER_API_SECRET',
          redirectURI: 'YOUR_TWITTER_REDIRECT_URI',
        );

  // Get current authenticated user
  User? get currentUser => _firebaseAuth.currentUser;

  // Stream of authentication state changes
  Stream<User?> get user => _firebaseAuth.authStateChanges();

  // Google Sign In
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } catch (error) {
      print('Google Sign-In Error: $error');
      rethrow;
    }
  }

  // Facebook Sign In
  Future<UserCredential?> signInWithFacebook() async {
    try {
      final LoginResult result = await _facebookAuth.login();
      if (result.status != LoginStatus.success) return null;

      final OAuthCredential credential = 
        FacebookAuthProvider.credential(result.accessToken!.token);

      return await _firebaseAuth.signInWithCredential(credential);
    } catch (error) {
      print('Facebook Sign-In Error: $error');
      rethrow;
    }
  }

  // Twitter Sign In
  Future<UserCredential?> signInWithTwitter() async {
    try {
      final AuthResult result = await _twitterLogin.login();
      if (result.status != TwitterLoginStatus.loggedIn) return null;

      final OAuthCredential credential = 
        TwitterAuthProvider.credential(
          accessToken: result.authToken!,
          secret: result.authTokenSecret!,
        );

      return await _firebaseAuth.signInWithCredential(credential);
    } catch (error) {
      print('Twitter Sign-In Error: $error');
      rethrow;
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
    } catch (error) {
      print('Email/Password Sign-In Error: $error');
      rethrow;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _facebookAuth.logOut();
      await _firebaseAuth.signOut();
    } catch (error) {
      print('Sign Out Error: $error');
      rethrow;
    }
  }
}