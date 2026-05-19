import 'package:equatable/equatable.dart';

enum StoryAudience { public, friends, closeFriends, private }

extension StoryAudienceX on StoryAudience {
  String get label {
    switch (this) {
      case StoryAudience.public:
        return 'PUBLIC STORY';
      case StoryAudience.friends:
        return 'VISIBLE TO FRIENDS';
      case StoryAudience.closeFriends:
        return 'VISIBLE TO CLOSE FRIENDS';
      case StoryAudience.private:
        return 'PRIVATE STORY';
    }
  }

  String get description {
    switch (this) {
      case StoryAudience.public:
        return 'Anyone can view';
      case StoryAudience.friends:
        return 'Only friends can view';
      case StoryAudience.closeFriends:
        return 'Selected close friends only';
      case StoryAudience.private:
        return 'Only you can view';
    }
  }

  static StoryAudience fromString(String value) {
    return StoryAudience.values.firstWhere(
      (audience) => audience.name == value,
      orElse: () => StoryAudience.friends,
    );
  }
}

class Story extends Equatable {
  const Story({
    required this.id,
    required this.mediaUrl,
    required this.audience,
    required this.createdAt,
    required this.username,
    required this.avatarUrl,
  });

  final String id;
  final String mediaUrl;
  final StoryAudience audience;
  final DateTime createdAt;
  final String username;
  final String avatarUrl;

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      mediaUrl: json['mediaUrl'] as String? ?? '',
      audience: StoryAudienceX.fromString(json['audience'] as String? ?? ''),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      username: json['username'] as String? ?? 'snapuser',
      avatarUrl: json['avatarUrl'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [id, mediaUrl, audience, createdAt, username, avatarUrl];
}
