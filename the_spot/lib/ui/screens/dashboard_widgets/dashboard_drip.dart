import 'package:flutter/material.dart';

class DashboardDrip extends StatelessWidget {
  const DashboardDrip({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        color: Colors.white,
      ),
      clipper: CustomClipPath(),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius = 0.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
        size.width, size.height + 50, size.width * 3 / 2, size.height - 100);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
