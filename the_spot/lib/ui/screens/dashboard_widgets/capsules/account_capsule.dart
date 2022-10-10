import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:the_spot/config/custom_extensions.dart';
import 'package:the_spot/config/theme_data.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/dashboard_drip.dart';
import 'package:the_spot/ui/screens/login_screen.dart';
import 'package:the_spot/ui/screens/widgets/accent_button.dart';

class AccountCapsule extends StatelessWidget {
  const AccountCapsule({super.key});

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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Account operations",
                          style: AppThemes.text_balance_currency)
                      .withPaddingSides(20),
                  AccentButton(
                    text: "Log out",
                    icon: Icon(Icons.logout),
                    onPressed: () => PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: LoginScreen(),
                      withNavBar: false, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    ),
                  ).withPadding(16),
                ],
              ),
            ).withExpanded(5),
            Container(
              child: const Image(
                image: AssetImage('assets/img/concept_7.png'),
              ),
            ).withExpanded(4),
          ],
        )
      ]),
    );
  }
}
