import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:the_spot/config/custom_extensions.dart';
import 'package:the_spot/config/theme_data.dart';
import 'package:the_spot/data/models/static_user.dart';
import 'package:the_spot/data/repository/auth_web3.dart';
import 'package:the_spot/data/repository/popups.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/border_button.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/capsules/transfer_capsule.dart';
import 'package:the_spot/ui/screens/login_screen.dart';
import 'package:the_spot/ui/screens/widgets/sign_up_button.dart';
import 'package:the_spot/ui/screens/widgets/simple_icon_button.dart';
import 'package:the_spot/ui/screens/widgets/simple_textfield.dart';

import '../dashboard_drip.dart';

class TransferCapsule extends StatelessWidget {
  TransferCapsule({this.returnNeeded = false, super.key});

  final bool returnNeeded;

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _receiverController = TextEditingController();
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
                const Text("Transfer TSPOT (Testnet)",
                        style: AppThemes.text_balance_currency)
                    .withPaddingSides(20),
                Container(
                  decoration: BoxDecoration(
                      color: AppThemes.panelColor,
                      border: Border.all(color: AppThemes.panelColor),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(25))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(
                        image: AssetImage('assets/img/concept_send_1.png'),
                      ),
                      SimpleTextfield(_receiverController,
                          hint: "Receiver's address"),
                      SimpleTextfield(_controller, hint: "TSPOT Amount"),
                      Column(
                        children: [
                          ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 59),
                              child: BorderButton(
                                text: 'Send',
                                icon: const Icon(Icons.send,
                                    color: AppThemes.accentColor),
                                onPressed: () {
                                  print("Just a transfer");
                                  if (_receiverController.text.isNotEmpty &&
                                      _controller.text.isNotEmpty &&
                                      isNumeric(_controller.text)) {
                                  } else {
                                    showSimpleToast(
                                        "Please fill all the fields");
                                    transferMoney(
                                        GlobalVals.currentUser.privateKey,
                                        _receiverController.text,
                                        BigInt.from(int.parse(
                                            _receiverController.text)));
                                  }
                                },
                              )),
                          returnNeeded
                              ? ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxHeight: 59),
                                  child: SimpleIconButton(
                                    text: 'Return to dashboard',
                                    icon: const Icon(Icons.exit_to_app,
                                        color: Colors.white),
                                    onPressed: () {
                                      print("Just go back to dashboard");
                                      Navigator.of(context).pop();
                                    },
                                  )).withPaddingSides(8)
                              : Container(),
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
