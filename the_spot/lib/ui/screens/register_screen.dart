import 'package:flutter/material.dart';
import 'package:the_spot/ui/screens/widgets/registration_header.dart';
import 'package:the_spot/ui/screens/widgets/sign_up_button.dart';

// import 'package:hive/hive.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 55),
            RegistrationHeader("Hello there!"),
            const SizedBox(height: 25),
            const SizedBox(
              width: 125,
              height: 125,
              child: Image(image: AssetImage('assets/img/logo.png')),
            ),
            const SizedBox(height: 55),
            const SignUpButton(
              text: "Sign Up",
              onPressed: null,
            ),
          ]),
    );
  }
}
