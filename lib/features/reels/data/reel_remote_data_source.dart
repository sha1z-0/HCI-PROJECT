import 'package:hciiii/core/network/api_client.dart';
import 'package:hciiii/features/reels/domain/reel.dart';

class ReelRemoteDataSource {
  ReelRemoteDataSource(this._client);

  final ApiClient _client;

  Future<List<Reel>> fetchReels() async {
    final response = await _client.dio.get('/reels');
    final data = response.data as List<dynamic>? ?? [];
    return data
        .map((item) => Reel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
