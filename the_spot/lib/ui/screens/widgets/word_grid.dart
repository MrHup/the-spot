import 'package:flutter/material.dart';
import 'package:the_spot/config/custom_extensions.dart';
import 'package:the_spot/config/theme_data.dart';

class WordGrid extends StatelessWidget {
  WordGrid(this.words, {super.key});
  List<String> words;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: (8 / 3),
        controller: ScrollController(keepScrollOffset: false),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: List.generate(words.length, (index) {
          return Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Center(
              child: Text(
                '${words[index]}',
                style: AppThemes.text_small_key,
              ),
            ),
          ).withPaddingSides(2).withPaddingTop(5);
        }));
  }
}
