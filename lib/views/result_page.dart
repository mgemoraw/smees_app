import "package:flutter/material.dart";



class ResultPage extends StatelessWidget  {
  final int score;
  const ResultPage({super.key, required this.score});

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Your Score Summary",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  Container(height: 24),
                  Text("Your total Score: $score", style: TextStyle(fontSize: 15),),
                ],
              ),
            ),
          ),
      ),
    );
  }
}