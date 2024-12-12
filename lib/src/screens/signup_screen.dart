import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:harmony/src/theme/app_colors.dart';
import 'package:harmony/src/theme/app_styles.dart';
import 'package:harmony/src/widgets/app_logo.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/auth_input_field.dart';
import '../widgets/social_auth_button.dart';
import '../widgets/terms_and_policy_text.dart';
import 'login_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
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
                      MaterialPageRoute(builder: (context) => LoginScreen()),
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
          AuthInputField(
              label: 'Name',
              hintText: 'Enter your name',
              controller: nameController),
          AuthInputField(
              label: 'Email',
              hintText: 'Enter your Email',
              controller: emailController),
          AuthInputField(
              label: 'Password',
              hintText: 'Enter your password',
              isObscure: true,
              controller: passwordController),
          AuthInputField(
              label: 'Confirm password',
              hintText: 'Re-enter Password',
              isObscure: true,
              controller: confirmPasswordController),
          SizedBox(height: 7.h),
          Padding(
            padding: EdgeInsets.only(left: 35.w),
            child: const TermsAndPolicyText(),
          ),
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              fixedSize: Size(288.w, 42.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.r))),
            ),
            child: Text("SIGN UP", style: AppStyles.buttonText),
          ),
          const Spacer(),
          Text(
            "or sign up with",
            style: AppStyles.subHeading
                .merge(const TextStyle(color: AppColors.fieldInputColor)),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 51.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AuthSocialButton(
                    imagePath: "assets/images/google.png", onTap: () async {}),
                AuthSocialButton(
                    imagePath: "assets/images/facebook.png",
                    onTap: () async {}),
                AuthSocialButton(
                    imagePath: "assets/images/twitter.png", onTap: () async {}),
              ],
            ),
          ),
          const Spacer(),
          Text.rich(
            TextSpan(
              text: 'Have an account? ',
              style: AppStyles.subHeading
                  .merge(const TextStyle(color: AppColors.fieldInputColor)),
              children: <TextSpan>[
                TextSpan(
                  text: 'SIGN IN',
                  style: AppStyles.subHeading
                      .merge(TextStyle(color: Theme.of(context).primaryColor)),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                ),
              ],
            ),
          ),
          const Spacer(
            flex: 3,
          ),
        ],
      ),
    );
  }
}
