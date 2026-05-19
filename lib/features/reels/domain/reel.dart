import 'package:equatable/equatable.dart';

class Reel extends Equatable {
  const Reel({
    required this.id,
    required this.videoUrl,
    required this.caption,
    required this.username,
  });

  final String id;
  final String videoUrl;
  final String caption;
  final String username;

  factory Reel.fromJson(Map<String, dynamic> json) {
    return Reel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      videoUrl: json['videoUrl'] as String? ?? '',
      caption: json['caption'] as String? ?? '',
      username: json['username'] as String? ?? 'snapuser',
    );
  }

  @override
  List<Object?> get props => [id, videoUrl, caption, username];
}
