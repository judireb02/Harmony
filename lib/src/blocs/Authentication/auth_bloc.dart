import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/firebase_authentication_repository.dart';

class AuthState {
  final bool isLoading;
  final String? errorMessage;

  AuthState({this.isLoading = false, this.errorMessage});

  AuthState copyWith({bool? isLoading, String? errorMessage}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class AuthCubit extends Cubit<AuthState> {
  final AuthenticationRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthState());

  Future<void> signInWithEmail(String email, String password) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await _authRepository.signInWithEmailAndPassword(email, password);
      // Handle navigation to home screen (via context, router, or events)
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Sign in failed. Please check credentials.'));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await _authRepository.signInWithGoogle();
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Google Sign In failed. Please try again.'));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> signInWithFacebook() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await _authRepository.signInWithFacebook();
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Facebook Sign In failed. Please try again.'));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> signInWithTwitter() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await _authRepository.signInWithTwitter();
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Twitter Sign In failed. Please try again.'));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
