import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hciiii/features/stories/data/story_repository.dart';
import 'package:hciiii/features/stories/domain/story.dart';

class StoriesController extends AsyncNotifier<List<Story>> {
  @override
  Future<List<Story>> build() async {
    final repo = ref.watch(storyRepositoryProvider);
    return repo.getStories();
  }
}

final storiesControllerProvider =
    AsyncNotifierProvider<StoriesController, List<Story>>(
  StoriesController.new,
);
