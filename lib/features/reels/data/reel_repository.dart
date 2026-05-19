import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hciiii/core/network/api_client.dart';
import 'package:hciiii/features/reels/data/reel_remote_data_source.dart';
import 'package:hciiii/features/reels/domain/reel.dart';

class ReelRepository {
  ReelRepository(this._remoteDataSource);

  final ReelRemoteDataSource _remoteDataSource;

  Future<List<Reel>> getReels() {
    return _remoteDataSource.fetchReels();
  }
}

final reelRepositoryProvider = Provider<ReelRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ReelRepository(ReelRemoteDataSource(apiClient));
});
