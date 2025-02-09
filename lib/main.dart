import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:smees/login_page.dart';
import 'package:smees/models/database.dart';
import 'package:smees/security/auth.dart';
import 'package:smees/security/logout.dart';
import 'package:smees/student_statistics.dart';
import 'package:smees/views/common/smees_feedback.dart';
import 'package:smees/views/exam_home.dart';
import 'package:smees/views/practice_quiz.dart';
import "package:smees/views/learn_zone.dart";
import "package:smees/user_profile.dart";
import 'package:smees/views/settings.dart';
import 'package:smees/views/user_provider.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'home_page.dart';

Future<void> main() async {
  try {
    await dotenv.load(fileName: ".env");
    
    
  } catch (err) {
    print(err.toString());
  }
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  // await SmeesHelper().database;
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UseModeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NavigationProvider(),
        ),
      ],
      child: const SmeesApp(),
    ),
  );
  // runApp(const MyApp());
}

class SmeesApp extends StatelessWidget {
  const SmeesApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Grand Success',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      theme: ThemeData.light(),
      themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
      // theme: ThemeData(
      //   primaryColor: Colors.blue[900],
      //   primarySwatch: Colors.blue, // (255, 142, 129, 157)
      //   scaffoldBackgroundColor: Colors.blue[50],
      //   textTheme: TextTheme(
      //     headlineLarge: TextStyle(
      //       fontSize: 32,
      //       fontWeight: FontWeight.bold,
      //       color: Colors.blue[900],
      //     ),
      //     bodyLarge: TextStyle(fontSize: 16, color: Colors.blue[700]),
      //   ),
      //   buttonTheme: ButtonThemeData(
      //     buttonColor: Colors.blue[300],
      //     textTheme: ButtonTextTheme.primary,
      //   ),
      //   elevatedButtonTheme: ElevatedButtonThemeData(
      //       style: ElevatedButton.styleFrom(
      //     backgroundColor: Colors.white,
      //   )),
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      // onGenerateRoute: ,
      // home: AuthWrapper(),

      initialRoute: "/login",
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
        "/profile": (context) => const UserProfile(),
        "/learn": (contest) => const LearnZone(department: ""),
        "/stats": (context) => const Statistics(),
        "/settings": (context) => const SmeesSettings(),
        "/feedback": (context) => const SmeesFeedback(),
        
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
