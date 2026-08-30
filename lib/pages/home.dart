import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  "Anything\nto yoink?",
                  style: TextStyle(fontSize: 45, color: Color(0xFF3171C6)),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {},
                mouseCursor: SystemMouseCursors.click,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    "assets/icons/arrow_square_right.svg",
                    width: 42,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF2D2D2D),
                      BlendMode.dstIn,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // FAB has weird shadows and styles which is hard to disable...
          Positioned(
            bottom: 30,
            right: 30,
            child: InkWell(
              onTap: () {},
              mouseCursor: SystemMouseCursors.click,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  "assets/icons/folder_empty.svg",
                  width: 34,
                  colorFilter: const ColorFilter.mode(
                    Color(0x402D2D2D),
                    BlendMode.dstIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
