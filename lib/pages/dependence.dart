import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/ytdlp_service.dart';
import 'home.dart';

class ScreenDependence extends StatelessWidget {
  const ScreenDependence({super.key});

  @override
  Widget build(BuildContext context) {
    final checking = ValueNotifier<bool>(false);
    final error = ValueNotifier<String?>(null);

    Future<void> verifyAndProceed() async {
      checking.value = true;
      error.value = null;

      try {
        final yt = YtdlpService();
        final result = await yt.fetchVideo(
          "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
        );

        if (result['ok'] == true) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('deps_ready', true);
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ScreenHome()),
            );
          }
        } else {
          checking.value = false;
          error.value = result['error'] ?? 'Unknown error';
        }
      } catch (e) {
        checking.value = false;
        error.value = e.toString();
      }
    }

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
            ValueListenableBuilder<String?>(
              valueListenable: error,
              builder: (context, value, _) {
                if (value == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                );
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable: checking,
              builder: (context, value, _) {
                return InkWell(
                  onTap: value ? null : verifyAndProceed,
                  mouseCursor: SystemMouseCursors.click,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: value
                        ? const CircularProgressIndicator()
                        : RotatedBox(
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
