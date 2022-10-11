import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:the_spot/config/theme_data.dart';
import 'package:the_spot/config/custom_extensions.dart';
import 'package:the_spot/data/models/transactionw3.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/capsules/focus_capsule.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/capsules/scan_capsule.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/icon_button.dart';

class TransactionTile extends StatelessWidget {
  TransactionTile(this.tile, {super.key}) {
    to = tile.sender;
    from = tile.receiver;
    date = tile.date;
    type = tile.type;
    amount = tile.amount.toString();
  }
  String to = "";
  String from = "";
  String amount = "";
  String date = "";
  String type = "";
  final TransactionW3 tile;

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
              Text("$type", style: AppThemes.text_balance_currency_accent),
              Text("$amount TSPOT", style: AppThemes.text_balance_currency),
            ],
          ),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Text("to: $to", style: AppThemes.text_balance_currency),
          //     Text("from: $from", style: AppThemes.text_balance_currency),
          //   ],
          // ),
          Column(
            children: [
              Text(date, style: AppThemes.text_balance_currency),
              type != "exchange"
                  ? Text("to: $from", style: AppThemes.text_balance_currency)
                  : Container(),
            ],
          ),
        ],
      ),
    ).withPadding(4);
  }
}
