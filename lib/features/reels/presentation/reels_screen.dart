import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:hciiii/app/route_observer.dart';
import 'package:hciiii/core/constants/app_colors.dart';
import 'package:hciiii/core/widgets/empty_state.dart';
import 'package:hciiii/core/widgets/loading_view.dart';
import 'package:hciiii/core/utils/video_controller_factory.dart';
import 'package:hciiii/features/reels/domain/reel.dart';
import 'package:hciiii/features/reels/presentation/reels_controller.dart';
import 'package:hciiii/features/shared/providers/navigation_index_provider.dart';

class ReelsScreen extends ConsumerStatefulWidget {
  const ReelsScreen({super.key});

  @override
  ConsumerState<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends ConsumerState<ReelsScreen>
    with WidgetsBindingObserver, RouteAware {
  static const int _reelsTabIndex = 3;
  final Map<int, VideoPlayerController> _controllers = {};
  final Map<int, Future<VideoPlayerController>> _controllerFutures = {};
  final PageController _pageController = PageController();
  int _activeIndex = 0;
  int? _lastReelCount;
  List<Reel> _currentReels = const <Reel>[];
  bool _isRouteActive = true;
  bool _routeSubscribed = false;
  ProviderSubscription<int>? _navIndexSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _navIndexSubscription = ref.listenManual<int>(
      navigationIndexProvider,
      (previous, next) {
        if (next == _reelsTabIndex) {
          _resumeIfVisible();
        } else {
          _pauseAll();
        }
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (!_routeSubscribed && route is PageRoute) {
      routeObserver.subscribe(this, route);
      _routeSubscribed = true;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _resumeIfVisible();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _pauseAll();
        break;
    }
  }

  @override
  void didPush() {
    _isRouteActive = true;
    _resumeIfVisible();
  }

  @override
  void didPopNext() {
    _isRouteActive = true;
    _resumeIfVisible();
  }

  @override
  void didPushNext() {
    _isRouteActive = false;
    _pauseAll();
  }

  @override
  void didPop() {
    _isRouteActive = false;
    _pauseAll();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_routeSubscribed) {
      routeObserver.unsubscribe(this);
    }
    _navIndexSubscription?.close();
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  Future<VideoPlayerController> _getController(Reel reel, int index) async {
    final existingController = _controllers[index];
    if (existingController != null) {
      return existingController;
    }
    final existingFuture = _controllerFutures[index];
    if (existingFuture != null) {
      return existingFuture;
    }
    final future = createVideoController(reel.videoUrl).then((controller) {
      _controllers[index] = controller;
      return controller;
    });
    _controllerFutures[index] = future;
    return future;
  }

  void _prefetchAround(List<Reel> reels, int index) {
    for (final offset in [-1, 1]) {
      final targetIndex = index + offset;
      if (targetIndex >= 0 && targetIndex < reels.length) {
        _getController(reels[targetIndex], targetIndex);
      }
    }
  }

  void _trimControllers(int index) {
    final keep = <int>{index - 1, index, index + 1};
    for (final key in _controllers.keys.toList()) {
      if (!keep.contains(key)) {
        _controllers[key]?.dispose();
        _controllers.remove(key);
        _controllerFutures.remove(key);
      }
    }
  }

  Future<void> _setActiveIndex(List<Reel> reels, int index) async {
    _activeIndex = index;
    _prefetchAround(reels, index);
    _trimControllers(index);

    final controller = await _getController(reels[index], index);
    if (!mounted || _activeIndex != index) {
      return;
    }
    if (!_isReelsVisible()) {
      return;
    }
    if (!controller.value.isPlaying) {
      controller.play();
    }
    for (final entry in _controllers.entries) {
      if (entry.key != index && entry.value.value.isPlaying) {
        entry.value.pause();
      }
    }
  }

  void _scheduleInitialSetup(List<Reel> reels) {
    _currentReels = reels;
    if (_lastReelCount == reels.length) {
      return;
    }
    _lastReelCount = reels.length;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || reels.isEmpty) {
        return;
      }
      final targetIndex = _activeIndex.clamp(0, reels.length - 1);
      if (_isReelsVisible()) {
        _setActiveIndex(reels, targetIndex);
      } else {
        _prefetchAround(reels, targetIndex);
      }
    });
  }

  bool _isReelsVisible() {
    return _isRouteActive &&
        ref.read(navigationIndexProvider) == _reelsTabIndex;
  }

  void _pauseAll() {
    for (final controller in _controllers.values) {
      if (controller.value.isPlaying) {
        controller.pause();
      }
    }
  }

  Future<void> _resumeIfVisible() async {
    if (!_isReelsVisible() || _currentReels.isEmpty) {
      return;
    }
    final targetIndex = _activeIndex.clamp(0, _currentReels.length - 1);
    await _setActiveIndex(_currentReels, targetIndex);
  }

  @override
  Widget build(BuildContext context) {
    final reels = ref.watch(reelsControllerProvider);

    return Scaffold(
      body: reels.when(
        data: (items) {
          if (items.isEmpty) {
            return const EmptyState(
              title: 'No reels yet',
              subtitle: 'Add reels to your backend to see them here.',
            );
          }
          _currentReels = items;
          _scheduleInitialSetup(items);
          return PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            allowImplicitScrolling: true,
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            onPageChanged: (index) => _setActiveIndex(items, index),
            itemBuilder: (context, index) {
              final reel = items[index];
              return FutureBuilder<VideoPlayerController>(
                future: _getController(reel, index),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const LoadingView(label: 'Loading reel...');
                  }
                  final controller = snapshot.data!;
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      const ColoredBox(color: Colors.black),
                      Center(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: SizedBox(
                            width: controller.value.size.width,
                            height: controller.value.size.height,
                            child: VideoPlayer(controller),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.4),
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Spotlight',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(color: Colors.white),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Captioned reels',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: Colors.white70),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.search, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 80,
                        child: Semantics(
                          label: 'Reel captions: ${reel.caption}',
                          child: _CaptionOverlay(reel: reel),
                        ),
                      ),
                      Positioned(
                        right: 12,
                        bottom: 120,
                        child: _ReelActions(username: reel.username),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        error: (error, _) => EmptyState(
          title: 'Unable to load reels',
          subtitle: error.toString(),
        ),
        loading: () => const LoadingView(label: 'Loading reels...'),
      ),
    );
  }
}

class _CaptionOverlay extends StatelessWidget {
  const _CaptionOverlay({required this.reel});

  final Reel reel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            reel.caption,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '@${reel.username}',
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _ReelActions extends StatelessWidget {
  const _ReelActions({required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ActionButton(icon: Icons.favorite_border, label: '12.4k'),
        const SizedBox(height: 18),
        _ActionButton(icon: Icons.chat_bubble_outline, label: '324'),
        const SizedBox(height: 18),
        _ActionButton(icon: Icons.send, label: 'Share'),
        const SizedBox(height: 18),
        CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.snapYellow,
          child: Text(
            username.substring(0, 1).toUpperCase(),
            style: const TextStyle(
              color: AppColors.snapBlack,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}
