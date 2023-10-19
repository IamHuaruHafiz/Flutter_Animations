import 'package:flutter/material.dart';

class AnimationsChapterFive extends StatefulWidget {
  const AnimationsChapterFive({super.key});

  @override
  State<AnimationsChapterFive> createState() => _AnimationsChapterFiveState();
}

const defaultWidth = 100.0;

class _AnimationsChapterFiveState extends State<AnimationsChapterFive> {
  var _isZoomedIn = false;
  var _buttonText = "Zoom In";
  var _width = defaultWidth;
  var _curve = Curves.bounceOut;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Implicit Animations"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                //the duration that best catches the eye of the user on mobile without the user being bored is between 300 to 500 milliseconds
                duration: const Duration(
                  milliseconds: 370,
                ),
                curve: _curve,
                width: _width,
                child: Image.asset(
                  "assets/images/wallpaper.jpg",
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _isZoomedIn = !_isZoomedIn;
                _buttonText = _isZoomedIn ? "Zoom out" : "Zoom In";
                _width = _isZoomedIn
                    ? MediaQuery.of(context).size.width
                    : defaultWidth;
                _curve = _isZoomedIn ? Curves.bounceInOut : Curves.bounceOut;
              });
            },
            child: Text(
              _buttonText,
            ),
          ),
        ],
      ),
    );
  }
}
