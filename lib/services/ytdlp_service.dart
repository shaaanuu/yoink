import 'dart:convert';

import 'package:flutter/services.dart';

class YtdlpService {
  static const channel = MethodChannel('ytdlp');

  Future<Map<String, dynamic>> fetchVideo(String videoUrl) async {
    try {
      final result = await channel.invokeMethod('get_info', {'url': videoUrl});
      return jsonDecode(result);
    } on PlatformException catch (e) {
      return {'ok': false, 'error': e.message};
    } catch (e) {
      return {'ok': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> checkDeps() async {
    try {
      final result = await channel.invokeMethod('check_deps');
      return jsonDecode(result);
    } on PlatformException catch (e) {
      return {'ok': false, 'error': e.message};
    } catch (e) {
      return {'ok': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> downloadVideo(
    String url,
    String formatId,
  ) async {
    try {
      final result = await channel.invokeMethod('download', {
        'url': url,
        'format_id': formatId,
      });
      return jsonDecode(result);
    } on PlatformException catch (e) {
      return {'ok': false, 'error': e.message};
    } catch (e) {
      return {'ok': false, 'error': e.toString()};
    }
  }
}
