import 'dart:math' show pi;

import 'package:animations/chapter_2.dart';
import 'package:animations/chapter_4.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class AnimationsChapterThree extends StatefulWidget {
  const AnimationsChapterThree({super.key});

  @override
  State<AnimationsChapterThree> createState() => _AnimationsChapterThreeState();
}

const widthAndHeight = 100.0;

class _AnimationsChapterThreeState extends State<AnimationsChapterThree>
    with TickerProviderStateMixin {
  late AnimationController _xController;
  late AnimationController _yController;
  late AnimationController _zController;

  late Tween<double> _animation;

  @override
  void initState() {
    super.initState();
    _xController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 20,
      ),
    );
    _yController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 30,
      ),
    );
    _zController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 40,
      ),
    );

    _animation = Tween<double>(
      begin: 0,
      end: pi * 2,
    );
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    _zController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _xController
      ..reset()
      ..repeat();
    _yController
      ..reset()
      ..repeat();
    _zController
      ..reset()
      ..repeat();
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black12,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AnimationsChapterFour(),
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
                builder: (context) => const AnimationChapterTwo(),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        )),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: Listenable.merge(
                    [_xController, _yController, _zController]),
                builder: (context, child) {
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..rotateX(_animation.evaluate(_xController))
                      ..rotateY(_animation.evaluate(_yController))
                      ..rotateZ(_animation.evaluate(_zController)),
                    child: Stack(
                      children: [
                        //front side
                        Container(
                          width: widthAndHeight,
                          height: widthAndHeight,
                          color: Colors.red,
                        ),
                        //top side
                        Transform(
                          alignment: Alignment.topCenter,
                          transform: Matrix4.identity()..rotateX(-pi / 2.0),
                          child: Container(
                            width: widthAndHeight,
                            height: widthAndHeight,
                            color: Colors.purple,
                          ),
                        ),
                        //left side
                        Transform(
                          alignment: Alignment.centerLeft,
                          transform: Matrix4.identity()..rotateY(pi / 2.0),
                          child: Container(
                            width: widthAndHeight,
                            height: widthAndHeight,
                            color: Colors.yellow,
                          ),
                        ),
                        //right side
                        Transform(
                          alignment: Alignment.centerRight,
                          transform: Matrix4.identity()..rotateY(-pi / 2.0),
                          child: Container(
                            width: widthAndHeight,
                            height: widthAndHeight,
                            color: Colors.blue,
                          ),
                        ),

                        //back
                        Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..translate(Vector3(0, 0, -widthAndHeight)),
                          child: Container(
                            width: widthAndHeight,
                            height: widthAndHeight,
                            color: Colors.green,
                          ),
                        ),
                        //bottom side
                        Transform(
                          alignment: Alignment.bottomCenter,
                          transform: Matrix4.identity()..rotateX(pi / 2.0),
                          child: Container(
                            width: widthAndHeight,
                            height: widthAndHeight,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ));
  }
}
