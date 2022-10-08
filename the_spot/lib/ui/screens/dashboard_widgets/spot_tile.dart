import 'package:flutter/material.dart';
import 'package:the_spot/config/theme_data.dart';
import 'package:the_spot/config/custom_extensions.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/icon_button.dart';

class SpotTile extends StatelessWidget {
  const SpotTile({super.key});

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
            children: const [
              Text("MySpot #1", style: AppThemes.text_description_white),
              Text("Created by me", style: AppThemes.text_balance_currency),
            ],
          ),
          Row(
            children: [
              IconButtonW(
                  onPressed: () {
                    print("Edit");
                  },
                  icon: const Icon(
                    Icons.grid_view,
                    color: AppThemes.accentColor,
                  )),
              IconButtonW(
                  onPressed: () {
                    print("Delete");
                  },
                  icon: const Icon(
                    Icons.share,
                    color: AppThemes.accentColor,
                  )),
            ],
          )
        ],
      ),
    ).withPadding(4);
  }
}
