import 'dart:io';

import 'package:flutter/material.dart';
import 'package:the_spot/config/custom_extensions.dart';
import 'package:the_spot/config/theme_data.dart';
import 'package:the_spot/data/models/static_user.dart';
import 'package:the_spot/data/repository/auth_web3.dart';
import 'package:the_spot/data/repository/firebase_helper.dart';
import 'package:the_spot/data/repository/popups.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/border_button.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/dashboard_drip.dart';
import 'package:the_spot/ui/screens/widgets/simple_icon_button.dart';
import 'package:the_spot/ui/screens/widgets/simple_textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class BuySpotCapsule extends StatefulWidget {
  BuySpotCapsule({this.returnNeeded = false, super.key});

  final bool returnNeeded;

  @override
  State<BuySpotCapsule> createState() => _BuySpotCapsuleState();
}

class _BuySpotCapsuleState extends State<BuySpotCapsule> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controllerPrice = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  var _image = Image.asset('assets/img/placeholder.png');
  String _imagePath = '';

  void getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    final url = await uploadFile(File(image!.path));
    print("<<<<LINK>>>> $url");
    setState(() {
      _image = Image.file(File(image.path));
    });
    _imagePath = url;
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(children: [
        const DashboardDrip(),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                    maxHeight: 50,
                  ),
                  child: const Image(image: AssetImage('assets/img/logo.png')),
                ).withPadding(8),
              ],
            ),
            ListView(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: AppThemes.panelColor,
                      border: Border.all(color: AppThemes.panelColor),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(25))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: _image.withPadding(8),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SimpleTextfield(_controller, hint: "SPOT Name"),
                      SimpleTextfield(_controllerPrice, hint: "Base Price"),
                      Column(
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 59),
                            child: BorderButton(
                                text: 'Buy Spot',
                                icon: const Icon(Icons.credit_card,
                                    color: AppThemes.accentColor),
                                onPressed: () {
                                  print("Create a new spot");
                                  if (_controller.text.isEmpty ||
                                      _controllerPrice.text.isEmpty ||
                                      _imagePath.isEmpty) {
                                    showSimpleToast(
                                        "Please fill all the fields");
                                  } else {
                                    if (isNumeric(_controllerPrice.text)) {
                                      attemptCreateNewSpot(
                                          context,
                                          _controller.text,
                                          _imagePath,
                                          GlobalVals.currentUser.privateKey,
                                          BigInt.from(int.parse(
                                              _controllerPrice.text)));
                                    } else {
                                      showSimpleToast(
                                          "Please enter a valid price");
                                    }
                                  }
                                }),
                          ),
                          ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 59),
                              child: SimpleIconButton(
                                text: 'Return to dashboard',
                                icon: const Icon(Icons.exit_to_app,
                                    color: Colors.white),
                                onPressed: () {
                                  print("Just go back to dashboard");
                                  Navigator.of(context).pop();
                                },
                              )).withPaddingSides(8),
                        ],
                      ),
                    ],
                  ),
                ).withPadding(16)
              ],
            ).withExpanded(8),
            Container().withExpanded(1)
          ],
        )
      ]),
    );
  }
}
