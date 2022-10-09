import 'package:flutter/material.dart';
import 'package:the_spot/config/theme_data.dart';
import 'package:the_spot/data/repository/auth_web3.dart';
import 'package:the_spot/data/repository/generate_key.dart';
import 'package:the_spot/data/repository/popups.dart';
import 'package:the_spot/data/repository/smart_contract_test.dart';
import 'package:the_spot/ui/screens/widgets/accent_button.dart';
import 'package:the_spot/ui/screens/widgets/custom_drip.dart';
import 'package:the_spot/ui/screens/widgets/sign_up_button.dart';
import 'package:the_spot/ui/screens/widgets/word_grid.dart';
import 'package:the_spot/config/custom_extensions.dart';
import 'package:flutter/services.dart';

class KeyScreen extends StatefulWidget {
  KeyScreen({Key? key}) : super(key: key);

  @override
  State<KeyScreen> createState() => _KeyScreenState();
}

class _KeyScreenState extends State<KeyScreen> {
  @override
  void initState() {
    super.initState();
    _wordsFuture = generateWords();
  }

  final info =
      "First, let's set you up! Save these words somewhere safe, and don't share them with anyone!";
  Future<List<String>>? _wordsFuture;
  String _wordPhrase = "";
  String _newPrivateKey = "";

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
                Column(
                  children: [
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 20),
                    Text(info,
                        textAlign: TextAlign.center,
                        style: AppThemes.text_description_white),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                        maxHeight: MediaQuery.of(context).size.height * 0.2,
                        minHeight: MediaQuery.of(context).size.height * 0.2,
                      ),
                      child: FutureBuilder<List<String>>(
                          future: _wordsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              _wordPhrase = getWords(snapshot.data!);
                              _newPrivateKey = getB64(_wordPhrase);
                              print("Snapshot has data");
                              return WordGrid(
                                snapshot.data!,
                              );
                            }
                            print("Snapshot does not have data");
                            return const CircularProgressIndicator(
                              color: AppThemes.accentColor,
                            ).centered();
                          }),
                    ),
                    const SizedBox(height: 20),
                    AccentButton(
                      text: "Copy Secret",
                      icon: const Icon(Icons.copy),
                      onPressed: () async {
                        print("Copy Secret");
                        showSimpleToast("Copied to clipboard");
                        await Clipboard.setData(
                            ClipboardData(text: _wordPhrase));
                      },
                    ),
                    SignUpButton(
                      text: "Continue",
                      onPressed: () async {
                        final privateKey = _newPrivateKey;
                        final publicKey = getRandomString(12);

                        if (privateKey.isNotEmpty && publicKey.isNotEmpty) {
                          print("Private Key: $privateKey");
                          print("Public Key: $publicKey");
                          attemptRegister(context, privateKey, publicKey);
                        } else {
                          print("Error: Private Key or Public Key is empty");
                          showSimpleToast("Private Key has not yet loaded");
                        }
                      },
                    ),
                  ],
                ),
                const Image(image: AssetImage('assets/img/concept_3.png')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
