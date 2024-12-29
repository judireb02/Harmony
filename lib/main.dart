import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harmony/app.dart';

import 'firebase_options.dart';
import 'src/blocs/authentication/auth_bloc.dart';
import 'src/repositories/authentication/firebase_authentication_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(AuthenticationRepository()),
        ),
      ],
      child: const App(),
    ),
  );
}
