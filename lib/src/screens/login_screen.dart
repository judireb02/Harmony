import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:harmony/src/screens/home_screen.dart';
import 'package:harmony/src/widgets/app_logo.dart';
import '../blocs/authentication/auth_bloc.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';
import '../widgets/auth_input_field.dart';
import '../widgets/social_auth_button.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlocListener<AuthCubit, AuthState>(
          listener: (context,state) {
            if (state.isLoading) {
              // Show loading indicator
            } else if (state.errorMessage != null) {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            } else if (state.errorMessage == null && !state.isLoading) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            }
          },
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                AppIcon(
                  width: 54.w,
                  height: 54.h,
                ),
                const Spacer(),
                Text(
                  "Sign in your account",
                  style: Theme.of(context).primaryTextTheme.titleLarge,
                ),
                SizedBox(
                  height: 38.84.h,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AuthInputField(
                        label: 'Email',
                        hintText: 'Enter your Email',
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      AuthInputField(
                        label: 'Password',
                        hintText: 'Enter your password',
                        isObscure: true,
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 37.h,
                ),
                FilledButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      context.read<AuthCubit>().signInWithEmail(
                            _emailController.text,
                            _passwordController.text,
                          );
                    }
                  },
                  style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      fixedSize: Size(288.w, 42.h),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.r)))),
                  child: Text("SIGN IN", style: AppStyles.buttonText),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 26.h, bottom: 30.h),
                  child: Text(
                    "or sign in with",
                    style: AppStyles.subHeading
                        .merge(TextStyle(color: AppColors.fieldInputColor)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 51.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AuthSocialButton(
                        imagePath: "assets/images/google.png",
                        onTap: () async {
                          context.read<AuthCubit>().signInWithGoogle();
                        },
                      ),
                      AuthSocialButton(
                        imagePath: "assets/images/facebook.png",
                        onTap: () async {
                          context.read<AuthCubit>().signInWithFacebook();
                        },
                      ),
                      AuthSocialButton(
                        imagePath: "assets/images/twitter.png",
                        onTap: () async {
                          context.read<AuthCubit>().signInWithTwitter();
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 43.h),
                  child: Text.rich(
                    TextSpan(
                      text: 'Don’t have an account? ',
                      style: AppStyles.subHeading
                          .merge(TextStyle(color: AppColors.fieldInputColor)),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'SIGN UP',
                          style: AppStyles.subHeading.merge(
                              TextStyle(color: Theme.of(context).primaryColor)),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupScreen()),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer()
              ],
            ),
          ),
        ));
  }
}
