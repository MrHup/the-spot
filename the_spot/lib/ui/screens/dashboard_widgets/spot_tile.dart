import 'package:flutter/material.dart';
import 'package:the_spot/config/theme_data.dart';

class SpotTile extends StatelessWidget {
  const SpotTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppThemes.lightPanelColor,
          border: Border.all(color: AppThemes.panelColor),
          borderRadius: const BorderRadius.all(Radius.circular(25))),
      child: Row(children: [
        const Icon(Icons.star, color: Colors.white),
        Column(
          children: const [
            Text("MySpot #1", style: AppThemes.text_balance),
            Text("Created by me", style: AppThemes.text_balance_currency),
          ],
        ),
        IconButton(
            onPressed: null,
            icon: Icon(
              Icons.grid_view,
              color: AppThemes.accentColor,
            )),
        IconButton(
            onPressed: null,
            icon: Icon(
              Icons.share,
              color: AppThemes.accentColor,
            ))
      ]),
    );
  }
}
