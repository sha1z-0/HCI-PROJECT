import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hciiii/core/network/api_client.dart';
import 'package:hciiii/features/stories/data/story_remote_data_source.dart';
import 'package:hciiii/features/stories/domain/story.dart';
import 'package:image_picker/image_picker.dart';

class StoryRepository {
  StoryRepository(this._remoteDataSource);

  final StoryRemoteDataSource _remoteDataSource;

  Future<List<Story>> getStories() {
    return _remoteDataSource.fetchStories();
  }

  Future<Story> uploadStory(XFile file, StoryAudience audience) {
    return _remoteDataSource.uploadStory(file, audience);
  }
}

final storyRepositoryProvider = Provider<StoryRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return StoryRepository(StoryRemoteDataSource(apiClient));
});
