import 'package:flutter/material.dart';
import 'package:smees/views/common/appbar.dart';


class GeminiAIPage extends StatefulWidget {
  const GeminiAIPage({super.key});

  @override
  State<GeminiAIPage> createState() => _GeminiAIPageState();
}

class _GeminiAIPageState extends State<GeminiAIPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: SmeesAppbar(title: "SMEES - Gemini"),
      body: Placeholder(),
    );
  }
}
