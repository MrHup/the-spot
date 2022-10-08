import 'dart:io';

import 'package:flutter/material.dart';
import 'package:the_spot/config/custom_extensions.dart';
import 'package:the_spot/config/theme_data.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/border_button.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/dashboard_drip.dart';
import 'package:the_spot/ui/screens/widgets/simple_icon_button.dart';
import 'package:the_spot/ui/screens/widgets/simple_textfield.dart';
import 'package:image_picker/image_picker.dart';

class BuySpotCapsule extends StatefulWidget {
  BuySpotCapsule({this.returnNeeded = false, super.key});

  final bool returnNeeded;

  @override
  State<BuySpotCapsule> createState() => _BuySpotCapsuleState();
}

class _BuySpotCapsuleState extends State<BuySpotCapsule> {
  final TextEditingController _controller = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  var _image = Image.asset('assets/img/placeholder.png');

  void getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    print("Got image");
    setState(() {
      _image = Image.file(File(image!.path));
    });
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
                      _image,
                      SimpleTextfield(_controller, hint: "SPOT name"),
                      Column(
                        children: [
                          ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 59),
                              child: BorderButton(
                                text: 'Add amount',
                                icon: const Icon(Icons.add,
                                    color: AppThemes.accentColor),
                                onPressed: () {
                                  print("Just a top-up");
                                  getImage();
                                },
                              )),
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
