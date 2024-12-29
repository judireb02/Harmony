import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/Authentication/auth_bloc.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state.errorMessage == null && !state.isLoading) {
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (context) => LoginScreen()),
              (val) {
            return true;
          });
        }
      },
      child: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              context.read<AuthCubit>().signOut();
            },
            child: Text("Logout"),
          ),
        ),
      ),
    );
  }
}
