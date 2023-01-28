import 'dart:math' as math;

import 'package:flutter/material.dart';

class Loader extends StatefulWidget {
  const Loader({super.key});

  @override
  State<StatefulWidget> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 5),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Image(
          image: AssetImage("assets/images/washing_machine.jpg"),
          alignment: Alignment.center,
        ),
        AnimatedBuilder(
          animation: _controller,
          child: const Icon(
            Icons.self_improvement,
            size: 200,
          ),
          builder: (BuildContext context, Widget? child) {
            return Transform.rotate(
              angle: _controller.value * 2.0 * math.pi,
              child: child,
            );
          },
        )
      ],
    );
  }
}
