import 'dart:convert';
import 'package:ndef/ndef.dart' as ndef;

import 'package:flutter/material.dart';
import 'package:the_spot/config/custom_extensions.dart';
import 'package:the_spot/config/theme_data.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/dashboard_drip.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class ScanCapsule extends StatelessWidget {
  const ScanCapsule({super.key});

  void enableNFC(BuildContext context) async {
    try {
      var availability = await FlutterNfcKit.nfcAvailability;
      if (availability != NFCAvailability.available) {
        // oh-no
      }

// timeout only works on Android, while the latter two messages are only for iOS
      var tag = await FlutterNfcKit.poll(
          timeout: Duration(seconds: 10),
          iosMultipleTagMessage: "Multiple tags found!",
          iosAlertMessage: "Scan your tag");

      print(jsonEncode(tag));

      // read NDEF records if available
      if (tag.ndefAvailable != null) {
        print("NDEF available");
        if (tag.ndefAvailable!) {
          for (var record
              in await FlutterNfcKit.readNDEFRecords(cached: false)) {
            print(record.toString());
          }

          for (var record
              in await FlutterNfcKit.readNDEFRawRecords(cached: false)) {
            print(jsonEncode(record).toString());
          }
        }

        /// raw NDEF records (data in hex string)
        /// `{identifier: "", payload: "00010203", type: "0001", typeNameFormat: "nfcWellKnown"}`
        for (var record
            in await FlutterNfcKit.readNDEFRawRecords(cached: false)) {
          print(jsonEncode(record).toString());
        }
      }

      print("finish up");
      await FlutterNfcKit.finish();
    } on Exception catch (e) {
      print(e);
    }
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
                  child: GestureDetector(
                      onTap: () => enableNFC(context),
                      child: const Image(
                          image: AssetImage('assets/img/logo.png'))),
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
                    child: const Image(
                            image: AssetImage('assets/img/spot_scan.png'))
                        .withPadding(20),
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
