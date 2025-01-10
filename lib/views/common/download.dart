import "dart:convert";
import "dart:io";

import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:http/http.dart" as http;
import "package:path_provider/path_provider.dart";
import "package:percent_indicator/percent_indicator.dart";

class DownloadWidget extends StatefulWidget {
  const DownloadWidget({super.key});

  @override
  State<DownloadWidget> createState() => _DownloadWidgetState();
}

class _DownloadWidgetState extends State<DownloadWidget> {
  double _progress = 0.0;

  Future<void> _downloadFile(int departmentId, String fileName) async {
    final url =
        Uri.parse("http://localhost:8000/questions/${departmentId}/index");
    final response = await http.Client().send(http.Request('GET', url));
    final file = File(fileName);
    final total = response.contentLength;

    int received = 0;

    response.stream.listen(
      (chunk) {
        file.writeAsBytesSync(chunk, mode: FileMode.append);
        setState(() {
          received += chunk.length;
          _progress = received / total!;
        });
      },
      onDone: () {
        print("download completed");
      },
      onError: (e) {
        print("$e");
      },
      cancelOnError: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Column(
      children: [
        LinearPercentIndicator(
          lineHeight: 14.0,
          percent: _progress,
          center: Text("${(_progress * 100).toStringAsFixed(1)}%"),
          linearStrokeCap: LinearStrokeCap.roundAll,
          progressColor: Colors.blue,
        ),
        SizedBox(height: 20),
        ElevatedButton(
            onPressed: () {
              _downloadFile(1, "hwre.csv");
            },
            child: Icon(Icons.download)),
      ],
    )));
  }
}

class DownloadQuestionsJson extends StatefulWidget {
  const DownloadQuestionsJson({super.key});

  @override
  State<DownloadQuestionsJson> createState() => _DownloadQuestionsJsonState();
}

class _DownloadQuestionsJsonState extends State<DownloadQuestionsJson> {
  double _progress = 0.0;
  TextEditingController yearController = TextEditingController();

  Future<void> _downloadData(int departmentId, int year) async {
    final url = Uri.parse(
        "http://localhost:8000/questions/${departmentId}/index?year=$year");
    final response = await http.get(url);
    late String message = "";
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final directory = await getApplicationDocumentsDirectory();
      final file = File("${directory.path}/data_$year.json");
      await file.writeAsString(json.encode(data));
      setState(() {
        _progress = 1.0;
      });
    } else {
      message = "Failed to load data, please check your connection!";
      throw Exception("Failed to load data, Please Check your connection");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 120,
          child: TextField(
              controller: yearController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 15, color: Colors.black),
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.analytics), hintText: 'Year')),
        ),
        CircularProgressIndicator(value: _progress),
        ElevatedButton(
            onPressed: () {
              _downloadData(1, 2024);
            },
            child: const Icon(Icons.download)),
        const SizedBox(height: 20),
      ],
    );
  }
}
