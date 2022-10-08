import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:the_spot/config/custom_extensions.dart';
import 'package:the_spot/config/theme_data.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/border_button.dart';

import '../dashboard_drip.dart';

class HomeCapsule extends StatelessWidget {
  const HomeCapsule({super.key});

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 42,
                      maxHeight: 42,
                    ),
                    child: const Image(
                        image: AssetImage('assets/img/plain_logo.png'))),
                const SizedBox(width: 5),
                const Text(
                  '2208.05',
                  style: AppThemes.text_balance,
                ),
                const Text(
                  ' TSPOT',
                  style: AppThemes.text_balance_currency,
                ),
              ],
            ).withPadding(8).withExpanded(1),
            Container(
                    decoration: BoxDecoration(
                        color: AppThemes.panelColor,
                        border: Border.all(color: AppThemes.panelColor),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BorderButton(
                          text: 'Exchange',
                          icon: const Icon(Icons.add,
                              color: AppThemes.accentColor),
                          onPressed: () {},
                        ).withExpanded(1),
                        BorderButton(
                          text: 'Transfer',
                          icon: const Icon(Icons.file_upload_outlined,
                              color: AppThemes.accentColor),
                          onPressed: () {},
                        ).withExpanded(1),
                      ],
                    ).withPaddingSides(6))
                .withPadding(16),
            Container(
              // color: Colors.blue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Transfer History",
                          style: AppThemes.text_balance_currency)
                      .withPaddingSides(20),
                  Container(
                    decoration: BoxDecoration(
                        color: AppThemes.panelColor,
                        border: Border.all(color: AppThemes.panelColor),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25))),
                    child: ListView(
                      children: [Text("123"), Text("123"), Text("123")],
                    ),
                  ).withPadding(16).withExpanded(1)
                ],
              ),
            ).withExpanded(8),
            Container().withExpanded(1)
          ],
        )
      ]),
    );
  }
}
