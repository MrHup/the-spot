import 'package:flutter/material.dart';
import 'package:the_spot/config/theme_data.dart';
import 'package:the_spot/config/custom_extensions.dart';
import 'package:the_spot/ui/screens/dashboard_widgets/dashboard_drip.dart';

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
                    child:
                        const Image(image: AssetImage('assets/img/logo.png')),
                  ).withPadding(8),
                ],
              ),
              Container(color: Colors.red, child: Text("ish")).withExpanded(1),
              Container(color: Colors.green, child: Text("ish"))
                  .withExpanded(1),
              Container(color: Colors.blue, child: Text("ish")).withExpanded(3),
              Container(color: Colors.yellow, child: Text("ish"))
                  .withExpanded(1),
            ],
          )
        ]));
  }
}
