import "dart:convert";
import "dart:io";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:path_provider/path_provider.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:smees/api/end_points.dart";
import "package:smees/models/user.dart";
import "package:smees/views/common/appbar.dart";
import "package:smees/views/common/course_list.dart";
import "package:smees/views/common/navigation.dart";
import "package:smees/views/common/pdf_viewer.dart";
import "package:smees/views/user_provider.dart";



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
  Widget build(BuildContext context)  {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    User user = userProvider.user;

    return ListView(
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
      Padding(
        padding: EdgeInsets.all(10.0),
        child: Text("Study All ${user.department} Courses Here",
        style: TextStyle
          (fontSize: 16,
          fontWeight: FontWeight.bold,
        ),),
      ),
      SizedBox(height: 15.0,),

        // open webview page
      // SizedBox(
      //   width: double.infinity,
      //   child: MaterialButton(
      //     color: Colors.white12,
      //     child: Text("Open Google Search Engine", style: TextStyle(fontSize:
      //     18, fontWeight: FontWeight.bold,
      //         color: Colors.blue[900])),
      //     onPressed: ()  {
      //       //
      //       Navigator.pushNamed(context, '/webview');
      //     },
      //   ),
      // ),

        // open Gemini page
        // SizedBox(
        //   width: double.infinity,
        //   child: MaterialButton(
        //     color: Colors.blueGrey,
        //     child: Text("Open Gemini AI", style: TextStyle(fontSize: 18,
        //         color: Colors.white)),
        //     onPressed: ()  {
        //       //
        //       Navigator.pushNamed(context, '/gemini');
        //     },
        //   ),
        // ),
      // SizedBox(
      //   width: double.infinity,
      //   child: MaterialButton(
      //     color: Colors.white12,
      //     child: Text("Open Exit Exam blue print", style: TextStyle(fontSize: 18,
      //         color: Colors.blue[900], fontWeight: FontWeight.bold)),
      //     onPressed: ()  {
      //
      //       Navigator.pushNamed(context, "/blueprint");
      //         // setState(() {
      //         //   isReady = !isReady;
      //         // });
      //     },
      //   ),
      // ),


      //  !isReady ? Center(child: Text("Click 'Read blue print' to load "))
      //  : SizedBox(
      //    height: MediaQuery.of(context).size.height,
      //   child: PDFViewScreen(filePath: pdfPath,)
      // ),


        // list of courses
        ExpansionTile(
          leading: Icon(Icons.menu_book),
            title: Text("Learning Contents", style:
            TextStyle
              (fontSize: 18, fontWeight: FontWeight.bold),),
            children: [
              FutureBuilder<List<Map<String,dynamic>>>(
                future: getCoursesList(), // Fetch the items from the API
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No Contents.'));
                  } else {
                    // If data is loaded, display the list
                    List<Map<String, dynamic>> items = snapshot.data!;
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(items[index]['name']),
                          subtitle: Text("Course Code: ${items[index]['code']}"),
                        );
                      },
                    );
                  }
                },
              ),
            ],
        ),


      ],

    );
  }
}



