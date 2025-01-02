import "package:flutter/material.dart";

import "department.dart";

//
class QuizPage extends StatefulWidget {
  const QuizPage({super.key, required this.title});

  final String title;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor:
            Theme.of(context).cardColor, //colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: TextField(
          style: TextStyle(color: Colors.blue[900]),
          decoration: const InputDecoration(
            hintText: 'Search Your Departmet Here',
          ),
          onChanged: (department) {
            print(department);
          },
        ),

        // title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: 10,
        padding: EdgeInsets.all(8),
        itemBuilder: (context, index) {
          return Departments();
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
