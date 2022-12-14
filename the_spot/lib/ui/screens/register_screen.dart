import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:the_spot/data/repository/auth_web3.dart';
import 'package:the_spot/ui/screens/widgets/logo.dart';
import 'package:the_spot/ui/screens/widgets/shape_white.dart';
import 'package:the_spot/ui/screens/widgets/sign_up_button.dart';
import 'package:the_spot/ui/screens/widgets/text_button_widget.dart';

// import 'package:hive/hive.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void initState() {
    super.initState();
    checkMasterKey();
  }

  void checkMasterKey() async {
    var persistentStorage = await Hive.openBox('userData');
    String? maybeString = persistentStorage.get('privateKey');
    final privateKey = maybeString ?? "";
    print("Privatekey is $privateKey");

    if (privateKey != "") {
      attemptLogin(context, privateKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            ShapeWhite(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 125),
                    Logo(),
                    const SizedBox(height: 55),
                    SignUpButton(
                      text: "Join us",
                      onPressed: () =>
                          Navigator.pushNamed(context, '/key_generate'),
                    ),
                    TextButtonWidget(
                      "Already have an account?",
                      accentText: "Sign in",
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (route) => false),
                    ),
                  ],
                ),
                Image(image: AssetImage('assets/img/concept_5.png')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
