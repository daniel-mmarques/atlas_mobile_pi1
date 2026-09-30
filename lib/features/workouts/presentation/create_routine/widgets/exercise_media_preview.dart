import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ExerciseMediaPreview extends StatelessWidget {
  const ExerciseMediaPreview({
    super.key,
    required this.videoUrl,
    required this.imageUrl,
    this.loading = false,
  });

  final String videoUrl;
  final String imageUrl;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (videoUrl.isNotEmpty) {
      return _ExerciseVideoPlayer(url: videoUrl);
    }
    if (imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: AppRadii.button,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _Placeholder(loading: loading),
          ),
        ),
      );
    }
    return _Placeholder(loading: loading);
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.loading});

  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.component(context),
        borderRadius: AppRadii.button,
      ),
      child: loading
          ? const CircularProgressIndicator()
          : const Icon(Icons.fitness_center, size: 40),
    );
  }
}

class _ExerciseVideoPlayer extends StatefulWidget {
  const _ExerciseVideoPlayer({required this.url});

  final String url;

  @override
  State<_ExerciseVideoPlayer> createState() => _ExerciseVideoPlayerState();
}

class _ExerciseVideoPlayerState extends State<_ExerciseVideoPlayer> {
  late final VideoPlayerController _controller;
  bool _ready = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..setLooping(true)
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() => _ready = true);
        _controller.play();
      }).catchError((_) {
        if (!mounted) return;
        setState(() => _failed = true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) return const _Placeholder(loading: false);
    if (!_ready) return const _Placeholder(loading: true);
    return ClipRRect(
      borderRadius: AppRadii.button,
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio == 0
            ? 16 / 9
            : _controller.value.aspectRatio,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            VideoPlayer(_controller),
            IconButton(
              onPressed: () {
                setState(() {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                });
              },
              icon: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
