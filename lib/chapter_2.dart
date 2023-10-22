import 'package:animations/chapter_1.dart';
import 'package:animations/chapter_3.dart';
import 'package:flutter/material.dart';
import 'dart:math' show pi;

enum CircleSide {
  left,
  right,
}

extension ToPath on CircleSide {
  Path toPath(Size size) {
    final path = Path();

    late Offset offset;
    late bool clockwise;

    switch (this) {
      case CircleSide.left:
        //where the pencil starts from
        path.moveTo(size.width, 0);
        //where the pencil moves to
        offset = Offset(size.width, size.height);
        //checks to see the direction to which the pen should move
        clockwise = false;
        break;
      case CircleSide.right:
        offset = Offset(0, size.height);
        clockwise = true;
        break;
    }
    //tells flutter the center point to draw the arc
    path.arcToPoint(
      offset,
      radius: Radius.elliptical(size.width / 2, size.height / 2),
      clockwise: clockwise,
    );
    //tells the pencil to close the path that has been drawn
    path.close();
    return path;
  }
}

//we place the path inside a custumclipper because it is not a widget
class HalfCircleClipper extends CustomClipper<Path> {
  final CircleSide side;

  const HalfCircleClipper({
    required this.side,
  });
  @override
  Path getClip(Size size) => side.toPath(size);
  //ask to redraw the path
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class AnimationChapterTwo extends StatefulWidget {
  const AnimationChapterTwo({super.key});

  @override
  State<AnimationChapterTwo> createState() => _AnimationChapterTwoState();
}

class _AnimationChapterTwoState extends State<AnimationChapterTwo>
    with TickerProviderStateMixin {
  late AnimationController _counterClockwiseRotationController;
  late Animation _counterClockwiseRotationAnimation;
  late AnimationController _flipController;
  late Animation _flipAnimation;

  @override
  void initState() {
    super.initState();
    _counterClockwiseRotationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 1,
      ),
    );
    _counterClockwiseRotationAnimation =
        Tween<double>(begin: 0, end: -(pi / 2)).animate(
      CurvedAnimation(
        parent: _counterClockwiseRotationController,
        curve: Curves.bounceOut,
      ),
    );
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 1,
      ),
    );

    _flipAnimation = Tween<double>(
      begin: 0,
      end: pi,
    ).animate(
      CurvedAnimation(
        parent: _flipController,
        curve: Curves.bounceOut,
      ),
    );

    //this method listens to the first animation and decides when to start
    _counterClockwiseRotationController.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          _flipAnimation = Tween<double>(
            begin: _flipAnimation.value,
            end: _flipAnimation.value + pi,
          ).animate(
            CurvedAnimation(
              parent: _flipController,
              curve: Curves.bounceOut,
            ),
          );
          _flipController
            ..reset()
            ..forward();
        }
      },
    );
    _flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _counterClockwiseRotationAnimation = Tween<double>(
          begin: _counterClockwiseRotationAnimation.value,
          end: _counterClockwiseRotationAnimation.value + -(pi / 2),
        ).animate(
          CurvedAnimation(
            parent: _counterClockwiseRotationController,
            curve: Curves.bounceOut,
          ),
        );
        _counterClockwiseRotationController
          ..reset()
          ..forward();
      }
    });
  }

  @override
  void dispose() {
    _counterClockwiseRotationController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(
        const Duration(
          seconds: 1,
        ), () {
      _counterClockwiseRotationController
        ..reset()
        ..forward();
    });
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black12,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AnimationsChapterThree(),
              ),
            );
          },
          child: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
            leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AnimationChapterOne(),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        )),
        body: Center(
          child: SafeArea(
              child: AnimatedBuilder(
            animation: _counterClockwiseRotationController,
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateZ(_counterClockwiseRotationAnimation.value),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  AnimatedBuilder(
                    animation: _flipController,
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.centerRight,
                        transform: Matrix4.identity()
                          ..rotateY(
                            _flipAnimation.value,
                          ),
                        child: ClipPath(
                          clipper:
                              const HalfCircleClipper(side: CircleSide.left),
                          child: Container(
                            height: 150,
                            width: 150,
                            color: Colors.blue,
                          ),
                        ),
                      );
                    },
                  ),
                  AnimatedBuilder(
                    animation: _flipController,
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.centerLeft,
                        transform: Matrix4.identity()
                          ..rotateY(
                            _flipAnimation.value,
                          ),
                        child: ClipPath(
                          clipper:
                              const HalfCircleClipper(side: CircleSide.right),
                          child: Container(
                            height: 150,
                            width: 150,
                            color: Colors.yellow,
                          ),
                        ),
                      );
                    },
                  )
                ]),
              );
            },
          )),
        ));
  }
}
