import 'dart:convert';

import 'package:flutter/services.dart';

class YtdlpService {
  static const channel = MethodChannel('ytdlp');

  Future<Map<String, dynamic>> fetchVideo(String videoUrl) async {
    try {
      final result = await channel.invokeMethod('get_info', {
        'url': videoUrl,
      });
      return jsonDecode(result);
    } on PlatformException catch (e) {
      return {'ok': false, 'error': e.message};
    } catch (e) {
      return {'ok': false, 'error': e.toString()};
    }
  }
}