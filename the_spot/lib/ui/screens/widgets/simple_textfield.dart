import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SimpleTextfield extends StatelessWidget {
  SimpleTextfield(this.controller,
      {this.hint = "", this.password = false, super.key});
  TextEditingController controller;
  String hint;
  bool password;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        obscureText: password,
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          hintStyle:
              Theme.of(context).textTheme.caption!.apply(fontFamily: 'Poppins'),
          hintText: hint,
        ),
      ),
    );
  }
}
