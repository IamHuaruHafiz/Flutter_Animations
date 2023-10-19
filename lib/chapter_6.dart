import 'dart:math' as math;

import 'package:flutter/material.dart';

class AnimationsChapterSix extends StatefulWidget {
  const AnimationsChapterSix({super.key});

  @override
  State<AnimationsChapterSix> createState() => _AnimationsChapterSixState();
}

class CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );
    path.addOval(rect);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

Color getRandomColor() => Color(
      0xFF000000 +
          math.Random().nextInt(
            0x00FFFFFF,
          ),
    );

class _AnimationsChapterSixState extends State<AnimationsChapterSix> {
  @override
  Widget build(BuildContext context) {
    var color = getRandomColor();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tween Animation Builder"),
        centerTitle: true,
      ),
      body: Center(
        child: ClipPath(
          clipper: CircleClipper(),
          child: TweenAnimationBuilder(
            duration: const Duration(
              seconds: 1,
            ),
            tween: ColorTween(
              begin: getRandomColor(),
              end: color,
            ),
            onEnd: () {
              setState(() {
                color = getRandomColor();
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              color: Colors.red.withOpacity(0.6),
            ),
            builder: (context, Color? color, child) {
              return ColorFiltered(
                colorFilter: ColorFilter.mode(color!, BlendMode.srcATop),
                child: child,
              );
            },
          ),
        ),
      ),
    );
  }
}
