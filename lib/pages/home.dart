import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../components/sheet.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    ValueNotifier valueNotifier = ValueNotifier(false);

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
              ValueListenableBuilder(
                valueListenable: valueNotifier,
                builder: (context, value, _) {
                  return value
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 15,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0x262D2D2D),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    style: TextStyle(
                                      fontFamily: "JetBrainsMono",
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => showModalBottomSheet(
                                    context: context,
                                    builder: (ctx) => Sheet(),
                                  ),
                                  mouseCursor: SystemMouseCursors.click,
                                  borderRadius: BorderRadius.horizontal(
                                    right: Radius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(13),
                                    child: SvgPicture.asset(
                                      "assets/icons/arrow_single_right.svg",
                                      width: 15,
                                      colorFilter: const ColorFilter.mode(
                                        Color(0xFF2D2D2D),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            valueNotifier.value = !value;
                          },
                          mouseCursor: SystemMouseCursors.click,
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                              "assets/icons/arrow_square_right.svg",
                              width: 42,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF2D2D2D),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        );
                },
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
                    BlendMode.srcIn,
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
