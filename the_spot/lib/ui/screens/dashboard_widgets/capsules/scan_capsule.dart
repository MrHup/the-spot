import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:the_spot/config/custom_extensions.dart';
import 'package:the_spot/config/theme_data.dart';
import 'package:the_spot/data/models/static_user.dart';
import 'package:the_spot/data/repository/auth_web3.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/dashboard_drip.dart';

class ScanCapsule extends StatefulWidget {
  ScanCapsule({super.key});

  @override
  State<ScanCapsule> createState() => _ScanCapsuleState();
}

class _ScanCapsuleState extends State<ScanCapsule> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Barcode? result;

  @override
  void reassemble() {
    print("REASSEMBLE");
    super.reassemble();
    if (Platform.isAndroid) {
      GlobalVals.controller!.pauseCamera();
    } else if (Platform.isIOS) {
      GlobalVals.controller!.resumeCamera();
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  int getCorrectId(String string) {
    try {
      String result = string.substring(0, string.indexOf('-the-spot'));
      if (isNumeric(result)) {
        return int.parse(result);
      }
    } catch (e) {
      return -1;
    }
    return -1;
  }

  void _onQRViewCreated(QRViewController controller) {
    GlobalVals.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        if (result != null) {
          if (result!.code != null) {
            int id = getCorrectId(result!.code!);
            if (id != -1) {
              GlobalVals.controller!.pauseCamera();
              print("id $id");
              attemptBuySpot(
                  context, GlobalVals.currentUser.privateKey, BigInt.from(id));
            }
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("On build");
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
            Container().withExpanded(1),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Tap a spot to buy it",
                          style: AppThemes.text_balance_currency)
                      .withPaddingSides(20)
                      .centered(),
                  Container(
                    decoration: BoxDecoration(
                        color: AppThemes.panelColor,
                        border: Border.all(color: AppThemes.panelColor),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25))),
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                    ),
                  ).withPadding(16).withExpanded(1)
                ],
              ),
            ).withExpanded(8),
            Container().withExpanded(1),
          ],
        )
      ]),
    );
  }
}
