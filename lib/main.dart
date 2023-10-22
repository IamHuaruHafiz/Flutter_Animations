import 'package:animations/chapter_1.dart';
import 'package:animations/chapter_3.dart';
import 'package:animations/chapter_4.dart';
import 'package:animations/chapter_5.dart';
import 'package:animations/chapter_6.dart';
import 'package:animations/chapter_7.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

//implicit animations deals with displaying animations without the use of animation controllers
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black12,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AnimationChapterOne(),
            ),
          );
        },
        child: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 3,
        centerTitle: true,
        title: const Text("Home"),
      ),
      body: const Center(
        child: AnimatedPrompt(
            title: "Thank you for your order!",
            subTitle: "Your order will be delivered in 2 days. Enjoy!",
            child: Icon(
              Icons.check,
            )),
      ),
    );
  }
}

class AnimatedPrompt extends StatefulWidget {
  const AnimatedPrompt(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.child});
  final String title;
  final String subTitle;
  final Widget child;

  @override
  State<AnimatedPrompt> createState() => _AnimatedPromptState();
}

class _AnimatedPromptState extends State<AnimatedPrompt>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _containerScaleAnimation;
  late Animation<Offset> _yAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(
          seconds: 1,
        ));
    _yAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(
        0,
        -0.23,
      ),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _iconScaleAnimation = Tween<double>(begin: 7, end: 6).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _containerScaleAnimation = Tween<double>(
      begin: 2.0,
      end: 0.4,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.bounceOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //this is to help the animation rebuild after a hot restart

    _controller
      ..reset()
      ..forward()
      ..repeat();
    return ClipRRect(
      //cliprrect is used to prevent it's children from outflowing it
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3)),
            ]),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 100,
            minHeight: 100,
            maxHeight: MediaQuery.of(context).size.height * 0.80,
            maxWidth: MediaQuery.of(context).size.width * 0.80,
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 160,
                    ),
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.subTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600]),
                    )
                  ],
                ),
              ),
              Positioned.fill(
                  child: SlideTransition(
                position: _yAnimation,
                child: ScaleTransition(
                  scale: _containerScaleAnimation,
                  child: Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.green),
                    child: ScaleTransition(
                      scale: _iconScaleAnimation,
                      child: widget.child,
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
