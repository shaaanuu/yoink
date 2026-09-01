import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScreenDependence extends StatelessWidget {
  const ScreenDependence({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Install\ndependencies",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 45, color: Color(0xFF3171C6)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 22, 0, 42),
              child: Text(
                "it's a one-time process\n(hopefully...)",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
            ),
            InkWell(
              onTap: () {},
              mouseCursor: SystemMouseCursors.click,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RotatedBox(
                  quarterTurns: 1,
                  child: SvgPicture.asset(
                    "assets/icons/arrow_square_right.svg",
                    width: 42,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF2D2D2D),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
