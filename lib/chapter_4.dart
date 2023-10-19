import 'package:flutter/material.dart';

class AnimationsChapterFour extends StatefulWidget {
  const AnimationsChapterFour({super.key});

  @override
  State<AnimationsChapterFour> createState() => _AnimationsChapterFourState();
}

@immutable
class Person {
  final String name;
  final String emoji;
  final int age;

  const Person({
    required this.name,
    required this.emoji,
    required this.age,
  });
}

const people = [
  Person(name: "Jerry", emoji: "🥸", age: 20),
  Person(name: "John", emoji: "🤠", age: 22),
  Person(name: "Rawlings", emoji: "👮", age: 26),
];

class _AnimationsChapterFourState extends State<AnimationsChapterFour> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("People"),
      ),
      body: ListView.builder(
          itemCount: people.length,
          itemBuilder: (context, index) {
            final person = people[index];
            return ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (centext) => DetailsPage(person: person),
                  ),
                );
              },
              leading: Hero(
                tag: person.name,
                child: Text(
                  person.emoji,
                  style: const TextStyle(fontSize: 45),
                ),
              ),
              title: Text(person.name),
              subtitle: Text("${person.age} years old"),
              trailing: const Icon(Icons.arrow_forward_ios),
            );
          }),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final Person person;
  const DetailsPage({
    super.key,
    required this.person,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: person.name,
          flightShuttleBuilder: (
            flightContext,
            animation,
            flightDirection,
            fromHeroContext,
            toHeroContext,
          ) {
            switch (flightDirection) {
              case HeroFlightDirection.push:
                return Material(
                  color: Colors.transparent,
                  child: ScaleTransition(
                      scale: animation.drive(
                        Tween<double>(
                          begin: 0.0,
                          end: 1.0,
                        ).chain(
                          CurveTween(
                            curve: Curves.fastOutSlowIn,
                          ),
                        ),
                      ),
                      child: toHeroContext.widget),
                );
              case HeroFlightDirection.pop:
                return Material(
                  color: Colors.transparent,
                  child: fromHeroContext.widget,
                );
            }
          },
          child: Text(
            person.emoji,
            style: const TextStyle(
              fontSize: 30,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              person.name,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "${person.age} years old",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
