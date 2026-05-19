import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hciiii/features/reels/data/reel_repository.dart';
import 'package:hciiii/features/reels/domain/reel.dart';

class ReelsController extends AsyncNotifier<List<Reel>> {
  @override
  Future<List<Reel>> build() async {
    final repo = ref.watch(reelRepositoryProvider);
    return repo.getReels();
  }
}

final reelsControllerProvider =
    AsyncNotifierProvider<ReelsController, List<Reel>>(
  ReelsController.new,
);
