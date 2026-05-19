import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class VideoCacheService {
  const VideoCacheService();

  Future<File> getFile(String url) async {
    final fileInfo = await DefaultCacheManager().getFileFromCache(url);
    if (fileInfo != null && fileInfo.file.existsSync()) {
      return fileInfo.file;
    }
    final fetched = await DefaultCacheManager().getSingleFile(url);
    return fetched;
  }
}
