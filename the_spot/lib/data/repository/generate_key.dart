import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

final random_words_api = "https://random-word-api.herokuapp.com/word?number=12";

Future<http.Response> fetchWords() {
  return http.get(Uri.parse(random_words_api));
}

// generate a list of 12 random words
Future<List<String>> generateWords() async {
  final response = await fetchWords();
  if (response.statusCode == 200) {
    final List<String> words =
        (jsonDecode(response.body) as List<dynamic>).cast<String>();
    return words;
  } else {
    print("An error has occured");
    return [];
  }
}

// get a list of 12 words and return a string of combined words
String getWords(List<String> words) {
  return words.join(" ");
}

// get a string and return a b64 encoded string
String getB64(String words) {
  return base64Encode(utf8.encode(words));
}

// generate a random string for a given length
const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();
String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
