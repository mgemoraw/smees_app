import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smees/login_page.dart';
import 'package:smees/models/database.dart';
import 'package:smees/security/auth.dart';
import 'package:smees/security/logout.dart';
import 'package:smees/services/auth_screen.dart';
import 'package:smees/student_statistics.dart';
import 'package:smees/views/common/smees_feedback.dart';
import 'package:smees/views/exam_home.dart';
import 'package:smees/views/practice_quiz.dart';
import "package:smees/views/learn_zone.dart";
import "package:smees/user_profile.dart";
import 'package:smees/views/settings.dart';
import 'package:smees/views/user_provider.dart';
import 'package:smees/services/working_directories.dart';
import 'package:smees/services/storage_permission.dart';
import 'package:smees/views/accounts/account_reset.dart';
import 'package:smees/views/accounts/account_create.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await requestStoragePermission(); // Ask for storage permission
  await safeInitialize();

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
        // '/login': (context) => const Login(),
        '/login': (context) => AuthScreen(),
        '/': (context) => const Home(title: "SMEES", department: ""),
        '/quiz': (context) => const TestHome(department: ""),
        "/exam": (context) => const ExamHome(department: ""),
        "/profile": (context) => const UserProfile(),
        "/learn": (contest) => const LearnZone(department: ""),
        "/stats": (context) => const Statistics(),
        "/settings": (context) => const SmeesSettings(),
        "/feedback": (context) => const SmeesFeedback(),
        "/reset": (context) => const AccountReset(),
        "/register": (context) => const AccountCreate(),
      },
    );
  }
}

Future<void> initializeDatabase() async {
  try {
    if (kIsWeb) {
      print("running on web");
      await Firebase.initializeApp(
          options: FirebaseOptions(
              apiKey: "AIzaSyATx5-RdiT1Qw54-Do-pMm4I6faChgVgjw",
              authDomain: "smees-fa0cb.firebaseapp.com",
              projectId: "smees-fa0cb",
              storageBucket: "smees-fa0cb.firebasestorage.app",
              messagingSenderId: "292538494392",
              appId: "1:292538494392:web:cae5aad3a743e3b5b8334d",
              measurementId: "G-L0RK3FW8ND"));
    } else if (Platform.isWindows) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      await Firebase.initializeApp();
    } else {
      await SmeesHelper().database;
      await Firebase.initializeApp();
    }
    print("Database initialized successfully!");
  } catch (e) {
    print("Database Initialization Error: ${e.toString()}");
  }
}

Future<void> safeInitialize() async {
  try {
    await dotenv.load(fileName: ".env");
    await createWorkingDirectory();
    await initializeDatabase();
  } catch (e, stacktrace) {
    debugPrint("Initialization Error: $e");
    debugPrint(stacktrace.toString()); // Shows where the error occurred
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
 