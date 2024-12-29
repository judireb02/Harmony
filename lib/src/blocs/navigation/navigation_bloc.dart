import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationState.splash) {
    on<NavigationEvent>((event, emit) {
      switch (event) {
        case NavigationEvent.login:
          emit(NavigationState.login);
          break;
        case NavigationEvent.splash:
          emit(NavigationState.splash);
          break;
        case NavigationEvent.signup:
          emit(NavigationState.signup);
          break;
        case NavigationEvent.home:
          emit(NavigationState.home);
          break;
        case NavigationEvent.profile:
          emit(NavigationState.profile);
          break;
        case NavigationEvent.chat:
          emit(NavigationState.chat);
          break;
        case NavigationEvent.camera:
          emit(NavigationState.camera);
          break;
        case NavigationEvent.settings:
          emit(NavigationState.settings);
          break;
      }
    });
  }
}
