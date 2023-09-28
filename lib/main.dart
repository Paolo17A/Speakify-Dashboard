import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/firebase_options.dart';
import 'package:speechlab_dashboard/screens/active_students_screen.dart';
import 'package:speechlab_dashboard/screens/activies_quizzes_screen.dart';
import 'package:speechlab_dashboard/screens/add_lesson_screen.dart';
import 'package:speechlab_dashboard/screens/edit_profile_screen.dart';
import 'package:speechlab_dashboard/screens/home_screen.dart';
import 'package:speechlab_dashboard/screens/instructors_screen.dart';
import 'package:speechlab_dashboard/screens/lessons_screen.dart';
import 'package:speechlab_dashboard/screens/rankings_screen.dart';
import 'package:speechlab_dashboard/screens/reset_password_screen.dart';
import 'package:speechlab_dashboard/screens/scores_screen.dart';
import 'package:speechlab_dashboard/screens/students_sections_screen.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(App());
}

class App extends StatelessWidget {
  App({super.key});

  final Map<String, WidgetBuilder> _routes = {
    '/': (context) => const Welcome(),
    '/register': (context) => const RegisterScreen(),
    '/login': (context) => const LoginScreen(),
    '/reset': (context) => const ResetPasswordScreen(),
    '/home': (context) => const HomeScreen(),
    '/sections': (context) => const StudentsSectionsScreen(),
    '/instructors': (context) => const InstructorsScreen(),
    '/edit': (context) => const EditProfileScreen(),
    '/lessons': (context) => const LessonsScreen(),
    '/addLesson': (context) => const AddLessonScreen(),
    '/activeStudents': (context) => const ActiveStudentsScreen(),
    '/activitiesAndQuizzes': (context) => const ActiviesQuizzesScreen(),
    '/scores': (context) => const ScoresScreen(),
    '/ranking': (context) => const RankingsScreen()
  };

  final ThemeData _themeData = ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 60, 19, 97)),
      scaffoldBackgroundColor: const Color.fromARGB(255, 245, 245, 245),
      snackBarTheme: const SnackBarThemeData(backgroundColor: Colors.purple),
      appBarTheme:
          const AppBarTheme(backgroundColor: Color.fromARGB(255, 18, 13, 43)),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 82, 48, 124),
          selectedItemColor: Color.fromARGB(255, 120, 87, 161)),
      listTileTheme: const ListTileThemeData(
          iconColor: Color.fromARGB(255, 180, 145, 200),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)))),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<OutlinedBorder>(
                  const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadiusDirectional.all(Radius.circular(10)))),
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 60, 19, 97)))));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpeechLab Dashboard',
      initialRoute: '/',
      routes: _routes,
      theme: _themeData,
    );
  }
}
