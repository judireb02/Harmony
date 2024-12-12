// blocs/navigation/navigation_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harmony/src/blocs/navigation/navigation_state.dart';

import 'navigation_event.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationState.profile) {
    on<NavigationEvent>((event, emit) {
      switch (event) {
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
