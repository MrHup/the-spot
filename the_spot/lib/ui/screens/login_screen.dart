import 'package:flutter/material.dart';
import 'package:the_spot/config/theme_data.dart';
import 'package:the_spot/config/custom_extensions.dart';
import 'package:the_spot/ui/screens/widgets/accent_button.dart';
import 'package:the_spot/ui/screens/widgets/custom_drip.dart';
import 'package:the_spot/ui/screens/widgets/logo.dart';
import 'package:the_spot/ui/screens/widgets/shape_white.dart';
import 'package:the_spot/ui/screens/widgets/sign_up_button.dart';
import 'package:the_spot/ui/screens/widgets/simple_textfield.dart';
import 'package:the_spot/ui/screens/widgets/text_button_widget.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  final String info =
      "Look for that secret key you had stored and enter it here!";
  TextEditingController _masterKeyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            const CustomDrip(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    // color: Colors.red,
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.8,
                            maxHeight: 50,
                          ),
                          child: const Image(
                              image: AssetImage('assets/img/logo.png')),
                        ).withPadding(8),
                      ],
                    ),
                    Column(
                      children: [
                        Text(info,
                                textAlign: TextAlign.center,
                                style: AppThemes.text_description_white)
                            .withPaddingSides(8),
                        SimpleTextfield(_masterKeyController)
                            .withPaddingSides(8),
                        AccentButton(
                          text: "Login",
                          onPressed: () => Navigator.pushNamedAndRemoveUntil(
                              context, '/dashboard', (route) => false),
                        ),
                        TextButtonWidget(
                          "Are you new here?",
                          accentText: "Register",
                          colorFirst: Colors.white,
                          onPressed: () => Navigator.pushNamedAndRemoveUntil(
                              context, '/register', (route) => false),
                        ),
                      ],
                    ),
                  ],
                )).withExpanded(1),
                Container(
                        // color: Colors.red,
                        child: const Image(
                            image: AssetImage('assets/img/concept_6.png')))
                    .withExpanded(1),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
