import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_spot/config/theme_data.dart';
import 'package:the_spot/config/custom_extensions.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/capsules/account_capsule.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/capsules/home_capsule.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/capsules/scan_capsule.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/capsules/spots_capsule.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/capsules/transfer_capsule.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/dashboard_drip.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
  }

  final String info =
      "Look for that secret key you had stored and enter it here!";
  TextEditingController _masterKeyController = TextEditingController();

  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      HomeCapsule(),
      MySpotsCapsule(),
      ScanCapsule(),
      TransferCapsule(),
      AccountCapsule(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        title: ("Home"),
        activeColorPrimary: AppThemes.accentColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.rectangle_grid_3x2),
        title: ("My Spots"),
        activeColorPrimary: AppThemes.accentColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.qrcode_viewfinder),
        title: ("Scan"),
        activeColorPrimary: AppThemes.accentColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.money_dollar_circle),
        title: ("Transfer"),
        activeColorPrimary: AppThemes.accentColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.logout_outlined),
        title: ("Account"),
        activeColorPrimary: AppThemes.accentColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        backgroundColor: AppThemes.panelColor,
        decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(10.0),
            colorBehindNavBar: AppThemes.darkPanelColor),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        navBarStyle: NavBarStyle.style1,
      ),
    );
  }
}
