import 'dart:math' show pi;

import 'package:flutter/material.dart';

class AnimationChapterOne extends StatefulWidget {
  const AnimationChapterOne({super.key});

  @override
  State<AnimationChapterOne> createState() => _AnimationChapterOneState();
}

class _AnimationChapterOneState extends State<AnimationChapterOne>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween(begin: 0.0, end: 2 * pi).animate(_controller);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..rotateY(_animation.value),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: const Center(
                child: Text("Open",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
          );
        },
      ),
    ));
  }
}
