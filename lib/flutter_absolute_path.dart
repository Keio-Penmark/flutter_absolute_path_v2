import 'dart:async';

import 'package:flutter/services.dart';

/// This class provides utility methods to get absolute paths from URIs or asset IDs.
class FlutterAbsolutePath {
  static const MethodChannel _channel =
      const MethodChannel('flutter_absolute_path');

  /// Returns the absolute file path for the given URI or asset ID.
  ///
  /// The return value can be used directly with the flutter [File] class.
  static Future<String> getAbsolutePath(String uri) async {
    try {
      final String path =
          await _channel.invokeMethod('getAbsolutePath', {'uri': uri});
      return path;
    } on PlatformException catch (e) {
      throw 'Failed to get absolute path: $e';
    }
  }
}
