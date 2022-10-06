import 'package:http/http.dart' as http;
import 'dart:convert';

final random_words_api = "https://random-word-api.herokuapp.com/word?number=12";

// generate a list of 12 random words
Future<List<String>> generateWords() async {
  // final response = await http.get(Uri.parse(random_words_api));
  // if (response.statusCode == 200) {
  //   final List<String> words = jsonDecode(response.body);
  //   print("Words: $words");
  //   print(words[1]);
  //   return words;
  // } else {
  //   print("An error has occured");
  //   return [];
  // }
  return Future<List<String>>.delayed(
    const Duration(seconds: 2),
    () => [
      "dog",
      "cat",
      "bird",
      "fish",
      "horse",
      "cow",
      "pig",
      "sheep",
      "goat",
      "chicken",
      "duck",
      "rabbit"
    ],
  );
}
