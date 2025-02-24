import "dart:convert";
import "dart:io";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:path_provider/path_provider.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:smees/views/common/appbar.dart";
import "package:smees/views/common/navigation.dart";
import "package:smees/views/common/pdf_viewer.dart";



class LearnZone extends StatefulWidget {
  final String department;
  const LearnZone({super.key, required this.department});

  @override
  State<LearnZone> createState() => _LearnZoneState();
}

class _LearnZoneState extends State<LearnZone> {
  late String pdfPath = "";
  String department = "";
  bool isReady = false;

  @override
  void initState(){
    super.initState();
    // load department and then the pdf content path
    _loadPDF();
  }

  Future <void> _loadPDF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString("smees-user");


    if (userString != null) {
      Map<String, dynamic> userData = jsonDecode(userString);
      String departmentName = userData['department'];
      if (departmentName.isNotEmpty) {
        String departmentPath = departmentName.replaceAll(" ", "");
        String filePath = "assets/$departmentPath/$departmentPath.pdf";
        setState(() {
          pdfPath = filePath;
          department = departmentPath;
        });
      }
      setState(() {
        //
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Text("Read blue print below",
          style: TextStyle
            (fontSize: 22,
            fontWeight: FontWeight.bold,
          ),),
          SizedBox(height: 15.0,),
          SizedBox(
            width: double.infinity,
            child: MaterialButton(
              color: Colors.grey,
              child: Text("Read blue print", style: TextStyle(fontSize: 18,
                  color: Colors.blue[900])),
              onPressed: () async {
        
                  // await _loadPDF();
                  setState(() {
                    isReady = true;
                  });
              },
            ),
          ),
        
           !isReady ? Center(child: Text("Click 'Read blue print' to load "))
           : SizedBox(
             height: 1000,
            child: PDFViewerPage(
                path: pdfPath),
          ),
          ],
        ),
      ),
    );
  }
}



