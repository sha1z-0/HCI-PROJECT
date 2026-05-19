import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hciiii/core/constants/app_colors.dart';
import 'package:hciiii/core/widgets/audience_badge.dart';
import 'package:hciiii/core/widgets/empty_state.dart';
import 'package:hciiii/core/widgets/loading_view.dart';
import 'package:hciiii/features/accessibility/presentation/accessibility_controller.dart';
import 'package:hciiii/features/stories/domain/story.dart';
import 'package:hciiii/features/stories/presentation/stories_controller.dart';
import 'package:hciiii/features/stories/presentation/story_viewer_screen.dart';

class StoriesScreen extends ConsumerWidget {
  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stories = ref.watch(storiesControllerProvider);
    final settings = ref.watch(accessibilitySettingsProvider);

    return Scaffold(
      body: stories.when(
        data: (items) {
          if (items.isEmpty) {
            return const EmptyState(
              title: 'No stories yet',
              subtitle: 'Capture a story from the camera tab.',
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const _StoriesHeader(),
              const SizedBox(height: 16),
              SizedBox(
                height: 140,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final story = items[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StoryViewerScreen(
                            story: story,
                            isHighContrast: settings.highContrast,
                          ),
                        ),
                      ),
                      child: _StoryBubble(story: story),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Stories',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 12),
              ...items.map(
                (story) => _StoryCard(
                  story: story,
                  isHighContrast: settings.highContrast,
                ),
              ),
            ],
          );
        },
        error: (error, _) => EmptyState(
          title: 'Unable to load stories',
          subtitle: error.toString(),
        ),
        loading: () => const LoadingView(label: 'Loading stories...'),
      ),
    );
  }
}

class _StoriesHeader extends StatelessWidget {
  const _StoriesHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 20,
          child: Icon(Icons.person),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Story',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Text(
                'Tap to manage your audience',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Add'),
        ),
      ],
    );
  }
}

class _StoryBubble extends StatelessWidget {
  const _StoryBubble({required this.story});

  final Story story;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.snapYellow, width: 2),
          ),
          child: CircleAvatar(
            radius: 34,
            backgroundImage: story.avatarUrl.isEmpty
                ? null
                : CachedNetworkImageProvider(story.avatarUrl),
            child: story.avatarUrl.isEmpty
                ? Text(story.username.substring(0, 1).toUpperCase())
                : null,
          ),
        ),
        const SizedBox(height: 8),
        Text(story.username, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({required this.story, required this.isHighContrast});

  final Story story;
  final bool isHighContrast;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => StoryViewerScreen(
            story: story,
            isHighContrast: isHighContrast,
          ),
        ),
      ),
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: story.mediaUrl,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 16,
              top: 16,
              child: AudienceBadge(
                label: story.audience.label,
                isHighContrast: isHighContrast,
              ),
            ),
            Positioned(
              left: 16,
              bottom: 16,
              child: Text(
                story.username,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
