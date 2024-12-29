import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harmony/src/theme/app_colors.dart';
import 'package:harmony/src/theme/app_styles.dart';
import 'package:harmony/src/widgets/app_logo.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../blocs/authentication/auth_bloc.dart';
import '../widgets/auth_input_field.dart';
import '../widgets/social_auth_button.dart';
import '../widgets/terms_and_policy_text.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Email validation regex
  final _emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  // Name validation (allows letters, spaces, and hyphens)
  final _nameRegex = RegExp(r'^[a-zA-Z\s-]+$');

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (!_nameRegex.hasMatch(value)) {
      return 'Please enter a valid name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!_emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'(?=.*?[A-Z])').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'(?=.*?[a-z])').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'(?=.*?[0-9])').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    if (!RegExp(r'(?=.*?[!@#$%^&*(),.?":{}|<>])').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      // Perform signup using AuthCubit
      context.read<AuthCubit>().signUpWithEmail(
          emailController.text.trim(), passwordController.text.trim());
    }
  }

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
              context, MaterialPageRoute(builder: (context) => HomeScreen()),
              (val) {
            return true;
          });
        }

        // Handle successful signup (you might want to navigate to home or verification screen)
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 36.w, right: 50.w, top: 46.h, bottom: 28.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            size: 21.sp,
                          ),
                        ),
                        AppIcon(width: 25.w, height: 25.h),
                      ],
                    ),
                  ),
                  Text(
                    "Create your account",
                    style: Theme.of(context).primaryTextTheme.titleLarge,
                  ),
                  SizedBox(height: 18.h),

                  // Name Input
                  AuthInputField(
                    label: 'Name',
                    hintText: 'Enter your name',
                    controller: nameController,
                    validator: _validateName,
                  ),

                  // Email Input
                  AuthInputField(
                    label: 'Email',
                    hintText: 'Enter your Email',
                    controller: emailController,
                    validator: _validateEmail,
                  ),

                  // Password Input
                  AuthInputField(
                    label: 'Password',
                    hintText: 'Enter your password',
                    controller: passwordController,
                    isObscure: !_isPasswordVisible,
                    validator: _validatePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColor,
                        size: 20.sp,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),

                  // Confirm Password Input
                  AuthInputField(
                    label: 'Confirm password',
                    hintText: 'Re-enter Password',
                    controller: confirmPasswordController,
                    isObscure: !_isConfirmPasswordVisible,
                    validator: _validateConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColor,
                        size: 20.sp,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),

                  SizedBox(height: 7.h),

                  Padding(
                    padding: EdgeInsets.only(left: 35.w),
                    child: const TermsAndPolicyText(),
                  ),

                  // Signup Button
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return FilledButton(
                        onPressed: state.isLoading ? null : _handleSignUp,
                        style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          fixedSize: Size(288.w, 42.h),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.r))),
                        ),
                        child: state.isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text("SIGN UP", style: AppStyles.buttonText),
                      );
                    },
                  ),

                  const Spacer(),

                  Text(
                    "or sign up with",
                    style: AppStyles.subHeading.merge(
                        const TextStyle(color: AppColors.fieldInputColor)),
                  ),

                  const Spacer(),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 51.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AuthSocialButton(
                          imagePath: "assets/images/google.png",
                          onTap: () =>
                              context.read<AuthCubit>().signInWithGoogle(),
                        ),
                        AuthSocialButton(
                          imagePath: "assets/images/facebook.png",
                          onTap: () =>
                              context.read<AuthCubit>().signInWithFacebook(),
                        ),
                        AuthSocialButton(
                          imagePath: "assets/images/twitter.png",
                          onTap: () =>
                              context.read<AuthCubit>().signInWithTwitter(),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  Text.rich(
                    TextSpan(
                      text: 'Have an account? ',
                      style: AppStyles.subHeading.merge(
                          const TextStyle(color: AppColors.fieldInputColor)),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'SIGN IN',
                          style: AppStyles.subHeading.merge(
                              TextStyle(color: Theme.of(context).primaryColor)),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                              );
                            },
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
