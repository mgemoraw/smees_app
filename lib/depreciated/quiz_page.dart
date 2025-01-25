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

// quetion answer options
// // option A
// Container(
//   color: _chosenAnswer == 'A' ? _selectedColor : _bgColor,
//   child: ListTile(
//     onTap: () {
//       setState(() {
//         _selectedColor = selectedColor;
//         _chosenAnswer = "A";
//         _writeAnswer(_chosenAnswer!);
//         // disableOptions();
//       });
//     },
//     key: const Key('A'),
//     leading: const Text(
//       'A.',
//       style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
//     ),
//     title: Text(
//       widget.items[_qno]['options'][0]['content'],
//       style:
//           const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
//     ),
//     selectedTileColor: _selectedColor,
//     //textColor: Colors.blue,
//     enabled: !answerWasSelected,
//   ),
// ),

// //option B
// Container(
//   color: _chosenAnswer == 'B' ? _selectedColor : _bgColor,
//   child: ListTile(
//     onTap: () {
//       setState(() {
//         _selectedColor = selectedColor;
//         _chosenAnswer = 'B';
//         _writeAnswer(_chosenAnswer!);
//         // disableOptions();
//       });
//     },
//     key: const Key('B'),
//     leading: const Text(
//       'B.',
//       style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
//     ),
//     title: Text(
//       widget.items[_qno]['options'][1]['content'],
//       style:
//           const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
//     ),
//     enabled: !answerWasSelected,
//   ),
// ),

// //option C
// Container(
//   color: _chosenAnswer == 'C' ? _selectedColor : _bgColor,
//   child: ListTile(
//     onTap: () {
//       setState(() {
//         _selectedColor = selectedColor;
//         _chosenAnswer = 'C';
//         _writeAnswer(_chosenAnswer!);
//         // disableOptions();
//       });
//     },
//     key: const Key('C'),
//     leading: const Text(
//       'C.',
//       style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
//     ),
//     title: Text(
//       widget.items[_qno]['options'][2]['content'],
//       style:
//           const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
//     ),
//     enabled: !answerWasSelected,
//   ),
// ),

// //option D
// Container(
//   color: _chosenAnswer == 'D' ? _selectedColor : _bgColor,
//   child: ListTile(
//     // on tap answer will be submitted
//     onTap: () {
//       setState(() {
//         _chosenAnswer = 'D';
//         _writeAnswer(_chosenAnswer!);
//         _selectedColor = selectedColor;
//         disableOptions();

//         //print(_chosenAnswer);
//       });
//     },
//     key: const Key('D'),
//     leading: const Text(
//       'D.',
//       style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
//     ),
//     title: Text(
//       widget.items[_qno]['options'][3]['content'],
//       style:
//           const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
//     ),
//     selectedColor: Colors.amber,
//     enabled: !answerWasSelected,
//   ),
// ),

// // if option E exists
// (widget.items[_qno]['options'][4]['content'] != null)
//     ? Container(
//         color: _chosenAnswer == 'E' ? _selectedColor : _bgColor,
//         child: ListTile(
//           // on tap answer will be submitted
//           onTap: () {
//             setState(() {
//               _chosenAnswer = "E";
//               _writeAnswer(_chosenAnswer!);
//               _selectedColor = selectedColor;
//               // disableOptions();
//             });
//           },
//           key: const Key('E'),
//           leading: const Text(
//             'E.',
//             style:
//                 TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
//           ),
//           title: Text(
//             widget.items[_qno]['options'][4]['content'],
//             style: const TextStyle(
//                 fontWeight: FontWeight.w500, fontSize: 18),
//           ),
//           enabled: !answerWasSelected,
//         ),
//       )
//     : Text(""),

// // if option F exists
// (widget.items[_qno]['options'][5]['content'] != null)
//     ? Container(
//         color: _chosenAnswer == 'F' ? _selectedColor : _bgColor,
//         child: ListTile(
//           // on tap answer will be submitted
//           onTap: () {
//             setState(() {
//               _chosenAnswer = 'F';
//               _writeAnswer(_chosenAnswer!);
//               _selectedColor = selectedColor;
//               // disableOptions();
//             });
//           },
//           key: Key('F'),
//           leading: const Text(
//             'F.',
//             style:
//                 TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
//           ),
//           title: Text(
//             widget.items[_qno]['options'][5]['content'],
//             style: const TextStyle(
//                 fontWeight: FontWeight.w500, fontSize: 18),
//           ),
//           enabled: !answerWasSelected,
//         ),
//       )
//     : const Text(""),
