import "package:flutter/material.dart";
import "package:smees/questions.dart";



class ResultPage extends StatelessWidget  {
  final Map resultData;
  final String backRoute;
  const ResultPage({super.key, required this.resultData, required this
      .backRoute});

  @override
  Widget build(BuildContext context ) {
    return Scaffold(
  appBar: AppBar(),
      body:  SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Your Score Summary",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  Container(height: 24),
                  Text("Total Questions: ${resultData['questions']}"),
                  Text("Your Score: ${resultData['score']}", style:
                  TextStyle(fontSize: 18)),

                  // Text("Test Started: ${resultData['testStarted']}"),
                  // Text("Quiz Ended: ${resultData['testEnded']}"),
                  SizedBox(
                    height: 30,
                  ),
                  // restart quiz
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (){
                      Navigator.pushReplacementNamed(context, backRoute);
                    },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors
                            .white12),
                      ),
                        child: Text("Retake another test", style: TextStyle
                          (fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
          ),
      ),
    );
  }
}