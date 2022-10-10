import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:the_spot/config/theme_data.dart';
import 'package:the_spot/config/custom_extensions.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/capsules/focus_capsule.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/capsules/scan_capsule.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/icon_button.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile(
      {this.to = "",
      this.from = "",
      this.amount = "",
      this.date = "",
      this.type = "",
      super.key});
  final String to;
  final String from;
  final String amount;
  final String date;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: AppThemes.lightPanelColor,
          border: Border.all(color: AppThemes.panelColor),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Sent", style: AppThemes.text_balance_currency_accent),
              Text("50TSPOT", style: AppThemes.text_balance_currency),
            ],
          ),
          Column(
            children: [
              Text("to: $to", style: AppThemes.text_balance_currency),
              Text("from: $from", style: AppThemes.text_balance_currency),
            ],
          ),
          Column(
            children: [
              Text("05/08/199", style: AppThemes.text_balance_currency),
            ],
          ),
        ],
      ),
    ).withPadding(4);
  }
}
