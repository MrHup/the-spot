import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:the_spot/config/custom_extensions.dart';
import 'package:the_spot/config/theme_data.dart';
import 'package:the_spot/data/models/spot.dart';
import 'package:the_spot/data/models/static_user.dart';
import 'package:the_spot/data/repository/auth_web3.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/border_button.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/capsules/buy_spot_capsule.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/spot_tile.dart';

import '../dashboard_drip.dart';

class MySpotsCapsule extends StatefulWidget {
  const MySpotsCapsule({super.key});

  @override
  State<MySpotsCapsule> createState() => _MySpotsCapsuleState();
}

class _MySpotsCapsuleState extends State<MySpotsCapsule> {
  @override
  void initState() {
    super.initState();
    _spotsFuture = getAllSpotsCreatedByUser(GlobalVals.currentUser.privateKey);
    _spotsOwnedFuture =
        getAllSpotsOwnedByUser(GlobalVals.currentUser.privateKey);
  }

  Future<List<Spot>>? _spotsFuture;
  Future<List<Spot>>? _spotsOwnedFuture;
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
                  child: GestureDetector(
                      onTap: () {
                        getAllSpotsCreatedByUser(
                            GlobalVals.currentUser.privateKey);
                      },
                      child: const Image(
                          image: AssetImage('assets/img/logo.png'))),
                ).withPadding(8),
              ],
            ),
            Container().withExpanded(1),
            Container(
              // color: Colors.blue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  const Text("Created Spots",
                          style: AppThemes.text_balance_currency)
                      .withPaddingSides(20),
                  Container(
                    decoration: BoxDecoration(
                        color: AppThemes.panelColor,
                        border: Border.all(color: AppThemes.panelColor),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25))),
                    child: FutureBuilder<List<Spot>>(
                        future: _spotsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            print("Snapshot has data");
                            return ListView(
                              children: [
                                for (var spot in snapshot.data!) SpotTile(spot)
                              ],
                            );
                          }
                          print("Snapshot does not have data");
                          return const CircularProgressIndicator(
                            color: AppThemes.accentColor,
                          ).centered();
                        }),
                  ).withPadding(16).withExpanded(1)
                ],
              ),
            ).withExpanded(4),
            Container(
              // color: Colors.blue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  const Text("Owned Spots",
                          style: AppThemes.text_balance_currency)
                      .withPaddingSides(20),
                  Container(
                    decoration: BoxDecoration(
                        color: AppThemes.panelColor,
                        border: Border.all(color: AppThemes.panelColor),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25))),
                    child: FutureBuilder<List<Spot>>(
                        future: _spotsOwnedFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            print("Snapshot has data");
                            return ListView(
                              children: [
                                for (var spot in snapshot.data!)
                                  SpotTile(
                                    spot,
                                    owned: true,
                                  )
                              ],
                            );
                          }
                          print("Snapshot does not have data");
                          return const CircularProgressIndicator(
                            color: AppThemes.accentColor,
                          ).centered();
                        }),
                  ).withPadding(16).withExpanded(1)
                ],
              ),
            ).withExpanded(4),
            Container().withExpanded(1),
          ],
        )
      ]),
    );
  }
}
