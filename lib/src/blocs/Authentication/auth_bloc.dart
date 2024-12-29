import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/authentication/firebase_authentication_repository.dart';

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
    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
    ));
    try {
      await _authRepository.signInWithEmailAndPassword(email, password);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> signUpWithEmail(String email, String password) async {
    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
    ));
    try {
      await _authRepository.signUpWithEmailAndPassword(email, password);
      emit(state.copyWith(
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
    ));
    try {
      await _authRepository.signInWithGoogle();
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> signInWithFacebook() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await _authRepository.signInWithFacebook();
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> signInWithTwitter() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await _authRepository.signInWithTwitter();
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> signOut() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await _authRepository.signOut();
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }
}
