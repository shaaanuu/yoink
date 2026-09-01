import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Sheet extends StatelessWidget {
  const Sheet({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    ValueNotifier isVideoSelected = ValueNotifier(true);

    Color defClr = Color(0xFF2D2D2D);
    Color selectedClr = Color(0xFF3171C6);

    return ValueListenableBuilder(
      valueListenable: isVideoSelected,
      builder: (context, value, _) {
        return Column(
          children: [
            Text("What format to yoink?", style: TextStyle(fontSize: 24)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 42),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () => isVideoSelected.value = true,
                    child: SvgPicture.asset(
                      "assets/icons/video_camera.svg",
                      height: 35,
                      colorFilter: ColorFilter.mode(
                        value ? selectedClr : defClr,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => isVideoSelected.value = false,
                    child: SvgPicture.asset(
                      "assets/icons/music.svg",
                      height: 44,
                      colorFilter: ColorFilter.mode(
                        !value ? selectedClr : defClr,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
