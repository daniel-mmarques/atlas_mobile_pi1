import 'package:atlas_mobile_pi1/core/navigation/app_routes.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class TransitionPage extends StatefulWidget {
  const TransitionPage({super.key, required this.workout});

  final Workout workout;

  @override
  State<TransitionPage> createState() => _TransitionPageState();
}

class _TransitionPageState extends State<TransitionPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) _goToSession();
    });
  }

  void _goToSession() {
    if (_navigated || !mounted) return;
    _navigated = true;
    context.pushReplacement(
      AppRoutes.workoutSession(widget.workout.id),
      extra: widget.workout,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Lottie.asset(
          'assets/animations/transition.json',
          controller: _controller,
          repeat: false,
          onLoaded: (composition) {
            _controller.duration = composition.duration ~/ 2;
            _controller.forward();
          },
        ),
      ),
    );
  }
}
