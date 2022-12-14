import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:the_spot/config/custom_extensions.dart';
import 'package:the_spot/config/theme_data.dart';
import 'package:the_spot/data/models/spot.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/dashboard_drip.dart';

class FocusCapsule extends StatelessWidget {
  FocusCapsule(this.spot, {super.key});
  final Spot spot;

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
            Container().withExpanded(1),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            spot.current_price.toString(),
                            style: AppThemes.text_spot_accent,
                          ),
                          const Text(
                            "TSPOT",
                            style: AppThemes.text_balance_currency,
                          ),
                        ],
                      ),
                      Text(spot.name, style: AppThemes.text_spot_white)
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: AppThemes.panelColor,
                        border: Border.all(color: AppThemes.panelColor),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(0))),
                    child: ListView(
                      padding: const EdgeInsets.all(8),
                      children: [
                        Image.network(spot.image_uri),
                      ],
                    ).withPadding(4),
                  ).withPadding(16).withExpanded(1)
                ],
              ),
            ).withExpanded(32),
            Center(
              child: QrImage(
                backgroundColor: Colors.white,
                data: "${spot.index}-the-spot",
                version: QrVersions.auto,
              ),
            ).withPadding(8).withExpanded(6),
            Container().withExpanded(2),
          ],
        )
      ]),
    );
  }
}
