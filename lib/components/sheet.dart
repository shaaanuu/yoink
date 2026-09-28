import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Sheet extends StatelessWidget {
  const Sheet({super.key, required this.formats});

  final List<dynamic> formats;

  @override
  Widget build(BuildContext context) {
    final isVideoSelected = ValueNotifier<bool>(true);
    final selectedFormat = ValueNotifier<String?>(null);

    Color defClr = Color(0xFF2D2D2D);
    Color selectedClr = Color(0xFF3171C6);

    final videoFormats = formats.where((f) {
      final vcodec = (f['vcodec'] as String?) ?? '';
      return vcodec != 'none' && vcodec.isNotEmpty;
    }).toList();

    final audioFormats = formats.where((f) {
      final acodec = (f['acodec'] as String?) ?? '';
      final vcodec = (f['vcodec'] as String?) ?? '';
      return acodec != 'none' &&
          acodec.isNotEmpty &&
          (vcodec == 'none' || vcodec.isEmpty);
    }).toList();

    return ValueListenableBuilder<bool>(
      valueListenable: isVideoSelected,
      builder: (context, isVideo, _) {
        final filtered = isVideo ? videoFormats : audioFormats;

        return ValueListenableBuilder<String?>(
          valueListenable: selectedFormat,
          builder: (context, selected, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("What format to yoink?", style: TextStyle(fontSize: 28)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () => isVideoSelected.value = true,
                        child: SvgPicture.asset(
                          "assets/icons/video_camera.svg",
                          height: 35,
                          colorFilter: ColorFilter.mode(
                            isVideo ? selectedClr : defClr,
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
                            !isVideo ? selectedClr : defClr,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final f = filtered[i] as Map<String, dynamic>;
                      final formatId = f['format_id'] as String;
                      final isSelected = selected == formatId;

                      return ListTile(
                        title: Text(
                          f['resolution'] ?? f['format_note'] ?? f['format_id'],
                          style: TextStyle(
                            fontSize: 18,
                            color: isSelected ? selectedClr : defClr,
                          ),
                        ),
                        subtitle: Text(
                          '${f['ext']} • ${f['vcodec'] ?? ''} ${f['acodec'] ?? ''}'
                              .trim(),
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected ? selectedClr : defClr,
                          ),
                        ),
                        trailing: Text(
                          _formatFileSize(f['filesize']),
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected ? selectedClr : defClr,
                          ),
                        ),
                        onTap: () {
                          selectedFormat.value = isSelected ? null : formatId;
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: InkWell(
                    onTap: selected != null
                        ? () => Navigator.pop(context, selected)
                        : null,
                    mouseCursor: SystemMouseCursors.click,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: selected != null
                            ? selectedClr
                            : Color(0x262D2D2D),
                      ),
                      child: Center(
                        child: Text(
                          "Yoink!",
                          style: TextStyle(
                            fontSize: 20,
                            color: selected != null ? Colors.white : defClr,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _formatFileSize(dynamic bytes) {
    if (bytes == null) return '';
    final b = bytes is int ? bytes : int.tryParse(bytes.toString()) ?? 0;
    if (b < 1024) return '${b}B';
    if (b < 1024 * 1024) return '${(b / 1024).toStringAsFixed(1)}KB';
    if (b < 1024 * 1024 * 1024) {
      return '${(b / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
    return '${(b / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }
}
