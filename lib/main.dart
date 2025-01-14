import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:provider/provider.dart';
import 'package:smees/login_page.dart';
import 'package:smees/security/auth.dart';
import 'package:smees/security/logout.dart';
import 'package:smees/views/exam_home.dart';
import 'package:smees/views/practice_quiz.dart';
import "package:smees/views/learn_zone.dart";
import "package:smees/student_profile.dart";
import 'package:smees/security/auth.dart';
import 'home_page.dart';

Future<void> main() async {
  try {
    await dotenv.load(fileName: ".env");
  } catch (err) {
    print(err.toString());
  }
  WidgetsFlutterBinding.ensureInitialized();

  // runApp(ChangeNotifierProvider(
  //     create: (context) => AuthProvider(), child: const MyApp()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grand Success',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 142, 129, 157),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // onGenerateRoute: ,
      // home: AuthWrapper(),

      initialRoute: "/",
      routes: {
        '/login': (context) => const Login(),
        '/': (context) => const Home(
              title: "SMEES",
              department: "",
            ),
        '/quiz': (context) => const TestHome(
              department: "",
            ),
        "/exam": (context) => const ExamHome(department: ""),
        "/profile": (context) => const Profile(userId: "bdu20150001"),
        "/learn": (contest) => const LearnZone(department: ""),
      },
    );
  }
}

// class AuthWrapper extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     return authProvider.isAuthenticated
//         ? Home(
//             title: "SMEES",
//             department: "",
//           )
//         : Login();
//   }
// }
