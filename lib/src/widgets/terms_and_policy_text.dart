import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:harmony/src/theme/app_styles.dart';

class TermsAndPolicyText extends StatelessWidget {
  const TermsAndPolicyText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          fillColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return Theme.of(context).primaryColor; 
              }
              return Colors.transparent; 
            },
          ),
          checkColor: Colors.white, 
          side: BorderSide(
            color:
                Theme.of(context).primaryColor, 
          ),
          value: false,
          onChanged: (bool? value) {
           
          },
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: 'I understood the ',
              style:
                 Theme.of(context).primaryTextTheme.displaySmall,
              children: <TextSpan>[
                TextSpan(
                  text: 'terms & policy',
                  style: AppStyles.tertiaryText
                      .merge(TextStyle(color: Theme.of(context).primaryColor)),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
                TextSpan(
                  text: '.',
                  style: AppStyles.tertiaryText
                      .merge(const TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
