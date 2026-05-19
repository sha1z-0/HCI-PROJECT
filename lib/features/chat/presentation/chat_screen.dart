import 'package:flutter/material.dart';
import 'package:hciiii/core/constants/app_colors.dart';
import 'package:hciiii/core/utils/formatters.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chats = _chatData;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            const _ChatHeader(),
            const SizedBox(height: 16),
            const _ChatSearch(),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: chats.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  return _ChatTile(chat: chat);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  const _ChatHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.snapSurfaceRaised,
            child: Icon(Icons.person, color: AppColors.snapWhite),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Chat',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
            tooltip: 'Search',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'New chat',
          ),
        ],
      ),
    );
  }
}

class _ChatSearch extends StatelessWidget {
  const _ChatSearch();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          hintText: 'Search chats',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.tune),
          ),
        ),
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  const _ChatTile({required this.chat});

  final _ChatPreview chat;

  @override
  Widget build(BuildContext context) {
    final statusColor = chat.unread ? AppColors.accentRed : AppColors.snapMuted;
    final statusIcon = chat.unread ? Icons.camera_alt : Icons.chat_bubble_outline;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.snapSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.snapBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundImage: NetworkImage(chat.avatarUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat.username,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(statusIcon, size: 16, color: statusColor),
                    const SizedBox(width: 6),
                    Text(
                      chat.subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.snapMuted,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatShortTime(chat.updatedAt),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.snapMuted,
                    ),
              ),
              const SizedBox(height: 8),
              if (chat.unread)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.snapYellow,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChatPreview {
  const _ChatPreview({
    required this.username,
    required this.subtitle,
    required this.avatarUrl,
    required this.updatedAt,
    this.unread = false,
  });

  final String username;
  final String subtitle;
  final String avatarUrl;
  final DateTime updatedAt;
  final bool unread;
}

final List<_ChatPreview> _chatData = [
  _ChatPreview(
    username: 'mira.flow',
    subtitle: 'Opened 2m ago',
    avatarUrl: 'https://i.pravatar.cc/150?img=32',
    updatedAt: DateTime.now().subtract(Duration(minutes: 2)),
    unread: true,
  ),
  _ChatPreview(
    username: 'jaylen',
    subtitle: 'New snap',
    avatarUrl: 'https://i.pravatar.cc/150?img=12',
    updatedAt: DateTime.now().subtract(Duration(minutes: 12)),
  ),
  _ChatPreview(
    username: 'sasha.k',
    subtitle: 'Delivered',
    avatarUrl: 'https://i.pravatar.cc/150?img=47',
    updatedAt: DateTime.now().subtract(Duration(hours: 1)),
  ),
  _ChatPreview(
    username: 'zion',
    subtitle: 'Opened 1h ago',
    avatarUrl: 'https://i.pravatar.cc/150?img=18',
    updatedAt: DateTime.now().subtract(Duration(hours: 2)),
  ),
  _ChatPreview(
    username: 'aria.m',
    subtitle: 'New snap',
    avatarUrl: 'https://i.pravatar.cc/150?img=58',
    updatedAt: DateTime.now().subtract(Duration(hours: 4)),
    unread: true,
  ),
];
