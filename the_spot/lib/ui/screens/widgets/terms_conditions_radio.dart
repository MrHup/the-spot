import 'package:flutter/material.dart';
import 'package:the_spot/config/theme_data.dart';

class TermsConditionsRadio extends StatefulWidget {
  const TermsConditionsRadio({super.key});

  @override
  State<TermsConditionsRadio> createState() => _TermsConditionsRadioState();
}

class _TermsConditionsRadioState extends State<TermsConditionsRadio> {
  bool agree = false; // default val of agree radio button

  void _doSomething() {
    // Do something
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: agree,
          fillColor: MaterialStateProperty.all(AppThemes.textSwatch),
          onChanged: (value) {
            setState(() {
              agree = value ?? false;
            });
          },
        ),
        const Text(
          'I agree with the Terms and Conditions',
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }
}
