import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScreenDownloads extends StatelessWidget {
  const ScreenDownloads({super.key});

  @override
  Widget build(BuildContext context) {
    final files = ValueNotifier<List<FileSystemEntity>>([]);

    Future<void> loadFiles() async {
      final dir = Directory('/storage/emulated/0/Download/yoink');
      if (await dir.exists()) {
        final list = dir.listSync().whereType<File>().toList();
        list.sort(
          (a, b) => b.statSync().modified.compareTo(a.statSync().modified),
        );
        files.value = list;
      } else {
        files.value = [];
      }
    }

    loadFiles();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Downloads"),
        backgroundColor: const Color(0xFFF4F3F1),
        foregroundColor: const Color(0xFF2D2D2D),
        elevation: 0,
      ),
      body: ValueListenableBuilder<List<FileSystemEntity>>(
        valueListenable: files,
        builder: (context, fileList, _) {
          if (fileList.isEmpty) {
            return const Center(
              child: Text(
                "No yoinks yet",
                style: TextStyle(fontSize: 24, color: Color(0xFF2D2D2D)),
              ),
            );
          }
          return ListView.builder(
            itemCount: fileList.length,
            itemBuilder: (context, i) {
              final file = fileList[i] as File;
              final fileName = file.path.split('/').last;
              final ext = fileName.split('.').last.toLowerCase();
              final size = file.statSync().size;
              final modified = file.statSync().modified;

              return ListTile(
                leading: _getIcon(ext),
                title: Text(
                  fileName,
                  style: const TextStyle(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${_formatFileSize(size)} • ${_formatDate(modified)}',
                  style: const TextStyle(fontSize: 14),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _getIcon(String ext) {
    const videoExts = {'mp4', 'webm', 'mkv', 'mov', 'avi', 'flv', 'wmv'};
    const audioExts = {'mp3', 'm4a', 'opus', 'wav', 'flac', 'ogg', 'aac'};

    if (videoExts.contains(ext)) {
      return SvgPicture.asset(
        "assets/icons/video_camera.svg",
        width: 30,
        colorFilter: const ColorFilter.mode(Color(0xFF2D2D2D), BlendMode.srcIn),
      );
    }
    if (audioExts.contains(ext)) {
      return SvgPicture.asset(
        "assets/icons/music.svg",
        width: 30,
        colorFilter: const ColorFilter.mode(Color(0xFF2D2D2D), BlendMode.srcIn),
      );
    }
    return const SizedBox(width: 30);
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
