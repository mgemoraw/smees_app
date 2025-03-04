import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smees/views/common/appbar.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';


class PDFViewerPage extends StatefulWidget {
  final String path;
  const PDFViewerPage({super.key, required this.path});

  @override
  State<PDFViewerPage> createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  int _totalPages = 0;
  int _currentPage = 0;
  bool _isReady = false;
  String _errorMessage = "";
  PDFViewController? _doc;
  String _filePath = "";

  @override
  void initState() {
    super.initState();
    _loadPDF();
  }

  void _loadPDF() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/sample.pdf';
    print("Saving PDF to: $filePath");
    try {
      // Load PDF from assets
      print("file Path: ${widget.path}");
      final byteData = await rootBundle.load
        (widget.path); // Path to your
      // asset
      final buffer = byteData.buffer.asUint8List();
      final file = File(filePath);
      await file.writeAsBytes(buffer);

      print("PDF written successfully to $filePath");

      // await file.writeAsBytes(byteData.buffer.asUint8List());
      setState(() {
        _isReady = true;
        _filePath = filePath;
      });
    } catch(error){
      print("Error: $error");
    }
  }
  @override
  Widget build(BuildContext context) {
    return  _isReady ? PDFView(
        filePath: _filePath,
        autoSpacing: true,
        enableSwipe: true,
        // pageSnap: true,
        swipeHorizontal: false, // Vertical scrolling enabled here
        // fitEachPage: true,
        onRender: (pages) {
          // print("PDF rendered with $pages pages");
          if (mounted){
            setState(() {
              _totalPages = pages ?? 0;
              _isReady = true;
            });
          }
        },
        onError: (error) {
          // print("Error loading PDF: $error");
          if (mounted){
            setState(() {
              _errorMessage = error.toString();
            });
          }

        },
        onPageError: (page, error){
          // print("Error on page $page: $error");
          if (mounted) {
            setState(() {
              _errorMessage = '$page: ${error.toString()}';
            });
          }
        },
        onViewCreated: (PDFViewController pdfViewController) {
          print("PDF view created");
          pdfViewController.getPageCount().then((count) {
            if (mounted) {
              setState(() {
                _totalPages = count!;
              });
            }

          });
        },

        onPageChanged: (int? page, int? total){
          if (mounted) {
            setState(() {
              _currentPage = page ?? 0;
              _totalPages = total ?? 0;
            });
          }
        },

    ) : _errorMessage.isEmpty
      ? Center(child: CircularProgressIndicator())
        : Center(child: Text(_errorMessage));
  }

}


class PDFViewScreen extends StatefulWidget {
  final filePath;
  const PDFViewScreen({super.key, required this.filePath});

  @override
  State<PDFViewScreen> createState() => _PDFViewScreenState();
}

class _PDFViewScreenState extends State<PDFViewScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,

      child: FutureBuilder(
        future: _loadPdf(widget.filePath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            return SfPdfViewer.asset(
              widget.filePath,
              key: _pdfViewerKey,
              scrollDirection: PdfScrollDirection.vertical,
            );
          } else {
            return Center(child: Text("No Blue Print file uploaded yet!"));
          }

        }
      ),

    );
  }

  Future<File> _loadPdf(String path) async {
    try {
      // check if the file exists
      final file = File(path);
      if (await file.exists()){
        return file;
      } else {
        throw Exception("File not found!");
      }
    } catch(e) {
      throw Exception("Error loading PDF file: $e");
    }
  }
}

