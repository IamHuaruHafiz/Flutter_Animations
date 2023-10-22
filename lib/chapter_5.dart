import 'package:animations/chapter_4.dart';
import 'package:animations/chapter_6.dart';
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black12,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AnimationsChapterSix(),
            ),
          );
        },
        child: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
          title: const Text("Implicit Animations"),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AnimationsChapterFour(),
                ),
              );
            },
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
          )),
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
