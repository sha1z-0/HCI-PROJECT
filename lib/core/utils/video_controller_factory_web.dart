import 'package:video_player/video_player.dart';

Future<VideoPlayerController> createVideoController(String url) async {
  final controller = VideoPlayerController.networkUrl(Uri.parse(url));
  await controller.initialize();
  controller.setLooping(true);
  return controller;
}
