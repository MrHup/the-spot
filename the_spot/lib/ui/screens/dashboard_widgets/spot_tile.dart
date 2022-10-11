import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:the_spot/config/theme_data.dart';
import 'package:the_spot/config/custom_extensions.dart';
import 'package:the_spot/data/models/spot.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/capsules/edit_spot_capsule.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/capsules/focus_capsule.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/capsules/scan_capsule.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/icon_button.dart';

class SpotTile extends StatelessWidget {
  SpotTile(this.spot, {this.owned = false, super.key});
  Spot spot;
  final bool owned;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppThemes.lightPanelColor,
          border: Border.all(color: AppThemes.panelColor),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.star, color: Colors.white),
          Column(
            children: [
              Text(spot.name, style: AppThemes.text_description_white),
              Text(spot.current_owner, style: AppThemes.text_balance_currency),
            ],
          ),
          Row(
            children: [
              owned
                  ? IconButtonW(
                      onPressed: () {
                        print("Edit");
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: EditSpotCapsule(spot),
                          withNavBar: true,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: AppThemes.accentColor,
                      ))
                  : Container(),
              IconButtonW(
                  onPressed: () {
                    print("View");
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: FocusCapsule(spot),
                      withNavBar: true,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                  },
                  icon: const Icon(
                    Icons.remove_red_eye,
                    color: AppThemes.accentColor,
                  )),
            ],
          )
        ],
      ),
    ).withPadding(4);
  }
}
