import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hciiii/core/network/api_client.dart';
import 'package:hciiii/features/stories/domain/story.dart';
import 'package:image_picker/image_picker.dart';

class StoryRemoteDataSource {
  StoryRemoteDataSource(this._client);

  final ApiClient _client;

  String _safeFileName(XFile file) {
    if (kIsWeb) {
      return 'story_${DateTime.now().millisecondsSinceEpoch}.jpg';
    }
    final name = file.name;
    if (name.trim().isEmpty) {
      return 'story_${DateTime.now().millisecondsSinceEpoch}.jpg';
    }
    return name;
  }

  Future<List<Story>> fetchStories() async {
    final response = await _client.dio.get('/stories');
    final data = response.data as List<dynamic>? ?? [];
    return data
        .map((item) => Story.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Story> uploadStory(XFile file, StoryAudience audience) async {
    final MultipartFile mediaFile;
    final fileName = _safeFileName(file);
    if (kIsWeb) {
      final bytes = await file.readAsBytes();
      mediaFile = MultipartFile.fromBytes(bytes, filename: fileName);
    } else {
      mediaFile = await MultipartFile.fromFile(file.path, filename: fileName);
    }

    final formData = FormData.fromMap({
      'audience': audience.name,
      'media': mediaFile,
    });

    final response = await _client.dio.post('/stories', data: formData);
    return Story.fromJson(response.data as Map<String, dynamic>);
  }
}
