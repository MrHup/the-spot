import 'dart:io';

import 'package:flutter/material.dart';
import 'package:the_spot/config/custom_extensions.dart';
import 'package:the_spot/config/theme_data.dart';
import 'package:the_spot/data/models/spot.dart';
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

class EditSpotCapsule extends StatefulWidget {
  EditSpotCapsule(this.spot, {this.returnNeeded = false, super.key});

  final bool returnNeeded;
  Spot spot;

  @override
  State<EditSpotCapsule> createState() => _EditSpotCapsuleState();
}

class _EditSpotCapsuleState extends State<EditSpotCapsule> {
  final ImagePicker _picker = ImagePicker();
  var _image = Image.asset('assets/img/placeholder.png');
  String _imagePath = '';

  void getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    _imagePath = image!.path;
    setState(() {
      _image = Image.file(File(image.path));
    });
  }

  void updateImage() async {
    final url = await uploadFile(File(_imagePath));
    print("<<<<LINK>>>> $url");
    attemptUpdateSpotImage(context, BigInt.from(widget.spot.index), url,
        GlobalVals.currentUser.privateKey);
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
                const SizedBox(
                  height: 20,
                ),
                const Text("Tap on the icon to upload a new image",
                        style: AppThemes.text_balance_currency)
                    .centered(),
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
                      Column(
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 59),
                            child: BorderButton(
                                text: 'Update Spot',
                                icon: const Icon(Icons.credit_card,
                                    color: AppThemes.accentColor),
                                onPressed: () {
                                  print(
                                      "Update spot with id ${widget.spot.index}");
                                  updateImage();
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
