import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:the_spot/config/custom_extensions.dart';
import 'package:the_spot/config/theme_data.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/border_button.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/capsules/buy_spot_capsule.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/spot_tile.dart';

import '../dashboard_drip.dart';

class MySpotsCapsule extends StatelessWidget {
  const MySpotsCapsule({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: BuySpotCapsule(returnNeeded: true),
            withNavBar: true,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: AppThemes.accentColor,
      ),
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
              // color: Colors.blue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("My Spots", style: AppThemes.text_balance_currency)
                      .withPaddingSides(20),
                  Container(
                    decoration: BoxDecoration(
                        color: AppThemes.panelColor,
                        border: Border.all(color: AppThemes.panelColor),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25))),
                    child: ListView(
                      children: [
                        SpotTile(),
                        SpotTile(),
                        SpotTile(),
                        SpotTile(),
                        SpotTile(),
                        SpotTile(),
                        SpotTile(),
                        SpotTile(),
                        SpotTile()
                      ],
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
