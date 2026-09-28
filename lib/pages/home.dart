import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../components/sheet.dart';
import '../services/ytdlp_service.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    final inputExpanded = ValueNotifier<bool>(false);
    final isLoading = ValueNotifier<bool>(false);
    final isDownloading = ValueNotifier<bool>(false);
    final urlController = TextEditingController();

    Future<void> extract() async {
      if (urlController.text.isEmpty) return;
      isLoading.value = true;
      inputExpanded.value = false;
      final messenger = ScaffoldMessenger.of(context);
      try {
        final yt = YtdlpService();
        final result = await yt.fetchVideo(urlController.text);
        isLoading.value = false;

        if (!context.mounted) return;

        if (result['ok'] == true) {
          final formats = result['data']['formats'] as List<dynamic>;
          final formatId = await showModalBottomSheet<String>(
            context: context,
            isScrollControlled: true,
            builder: (ctx) => DraggableScrollableSheet(
              expand: false,
              snap: true,
              snapSizes: [0.5, 1.0],
              initialChildSize: 0.5,
              builder: (context, scrollController) =>
                  Sheet(formats: formats, scrollController: scrollController),
            ),
          );

          if (formatId != null && context.mounted) {
            isDownloading.value = true;
            final dlResult = await yt.downloadVideo(
              urlController.text,
              formatId,
            );
            isDownloading.value = false;

            if (!context.mounted) return;

            if (dlResult['ok'] == true) {
              messenger.showSnackBar(
                const SnackBar(content: Text('Download complete')),
              );
            } else {
              messenger.showSnackBar(
                SnackBar(content: Text(dlResult['error'] ?? 'Download failed')),
              );
            }
          }
        } else {
          messenger.showSnackBar(
            SnackBar(content: Text(result['error'] ?? 'Extraction failed')),
          );
        }
      } catch (e) {
        isLoading.value = false;
        messenger.showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }

    return Scaffold(
      body: Column(
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
          ValueListenableBuilder<bool>(
            valueListenable: isLoading,
            builder: (context, loading, _) {
              if (loading) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  child: CircularProgressIndicator(),
                );
              }
              return ValueListenableBuilder<bool>(
                valueListenable: isDownloading,
                builder: (context, downloading, _) {
                  if (downloading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 15,
                      ),
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 8),
                          Text("Downloading..."),
                        ],
                      ),
                    );
                  }
                  return ValueListenableBuilder<bool>(
                    valueListenable: inputExpanded,
                    builder: (context, expanded, _) {
                      if (expanded) {
                        return Padding(
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
                                    controller: urlController,
                                    style: TextStyle(
                                      fontFamily: "JetBrainsMono",
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: extract,
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
                        );
                      }
                      return InkWell(
                        onTap: () => inputExpanded.value = true,
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
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
