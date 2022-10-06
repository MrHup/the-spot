import 'package:flutter/material.dart';

class SmartBoldText extends StatelessWidget {
  const SmartBoldText(this.text, {super.key});
  final String text;

  // split text into substrings divided by *
  // extract text between two * *
  List<String> splitString(String text) {
    final List<String> splitText = text.split('*');

    return splitText;
  }

  List<TextSpan> divideWordsBold(List<String> segments) {
    List<TextSpan> textSpans = [];
    for (var i = 0; i < segments.length; i++) {
      if (i % 2 == 0) {
        textSpans.add(TextSpan(text: segments[i]));
      } else {
        textSpans.add(TextSpan(
            text: segments[i], style: TextStyle(fontWeight: FontWeight.bold)));
      }
    }
    return textSpans;
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14.0,
          color: Colors.black,
        ),
        children: divideWordsBold(splitString(text)),
      ),
    );
  }
}
