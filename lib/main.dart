import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/firebase_options.dart';
import 'package:speechlab_dashboard/screens/add_quiz_screen.dart';
import 'package:speechlab_dashboard/screens/custom_quizzes_screen.dart';
import 'package:speechlab_dashboard/screens/add_lesson_screen.dart';
import 'package:speechlab_dashboard/screens/edit_lesson_screen.dart';
import 'package:speechlab_dashboard/screens/edit_profile_screen.dart';
import 'package:speechlab_dashboard/screens/edit_quiz_screen.dart';
import 'package:speechlab_dashboard/screens/home_screen.dart';
import 'package:speechlab_dashboard/screens/instructors_screen.dart';
import 'package:speechlab_dashboard/screens/lessons_screen.dart';
import 'package:speechlab_dashboard/screens/rankings_screen.dart';
import 'package:speechlab_dashboard/screens/reset_password_screen.dart';
import 'package:speechlab_dashboard/screens/scores_screen.dart';
import 'package:speechlab_dashboard/screens/selected_custom_quiz_screen.dart';
import 'package:speechlab_dashboard/screens/selected_quiz_screen.dart';
import 'package:speechlab_dashboard/screens/selected_section_screen.dart';
import 'package:speechlab_dashboard/screens/selected_speechlab_screen.dart';
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

  /*final Map<String, WidgetBuilder> _routes = {
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
    '/quizzes': (context) => const CustomQuizzesScreen(),
    '/addQuiz': (context) => const AddQuizScreen(),
    '/scores': (context) => const ScoresScreen(),
    '/ranking': (context) => const RankingsScreen()
  };*/

  final GoRouter _router = GoRouter(initialLocation: '/', routes: [
    GoRoute(path: '/', builder: (context, state) => const Welcome(), routes: [
      GoRoute(
          path: 'register',
          builder: (context, state) => const RegisterScreen()),
      GoRoute(path: 'login', builder: (context, state) => const LoginScreen()),
      GoRoute(
          path: 'reset',
          builder: (context, state) => const ResetPasswordScreen()),
      GoRoute(path: 'home', builder: (context, state) => const HomeScreen()),
      GoRoute(
          path: 'sections',
          builder: (context, builder) => const StudentsSectionsScreen(),
          routes: [
            GoRoute(
                path: 'selectedSection',
                builder: (context, state) {
                  final sectionParams = state.extra as Map<dynamic, dynamic>;
                  return SelectedSectionScreen(
                      section: sectionParams['section']);
                })
          ]),
      GoRoute(
          path: 'instructors',
          builder: (context, state) => const InstructorsScreen(),
          routes: [
            GoRoute(
                path: 'edit',
                builder: (context, state) => const EditProfileScreen())
          ]),
      GoRoute(
          path: 'lessons',
          builder: (context, state) => const LessonsScreen(),
          routes: [
            GoRoute(
                path: 'addLesson',
                builder: (context, state) => const AddLessonScreen()),
            GoRoute(
                path: 'editLesson',
                builder: (context, state) {
                  final lessonParams = state.extra as Map<dynamic, dynamic>;

                  return EditLessonScreen(
                      lessonID: lessonParams['lessonID'],
                      lessonTitle: lessonParams['lessonTitle'],
                      lessonContent: lessonParams['lessonContent'],
                      additionalResources: lessonParams['additionalResources']);
                })
          ]),
      GoRoute(
          path: 'scores',
          builder: (context, state) => const ScoresScreen(),
          routes: [
            GoRoute(
                path: 'selectedQuiz',
                builder: (context, state) {
                  final quizParams = state.extra as Map<dynamic, dynamic>;
                  return SelectedQuizScreen(
                      currentQuizLevelReq: quizParams['currentQuizLevelReq'],
                      selectedQuiz: quizParams['selectedQuiz']);
                }),
            GoRoute(
                path: 'selectedCustomQuiz',
                builder: (context, state) {
                  final quizParams = state.extra as Map<dynamic, dynamic>;
                  return SelectedCustomQuizScreen(
                      quizTitle: quizParams['quizTitle'],
                      serializedquizQuestions:
                          quizParams['serializedquizQuestions']);
                }),
            GoRoute(
                path: 'selectedSpeechLab',
                builder: (context, state) {
                  final quizParams = state.extra as Map<dynamic, dynamic>;
                  return SelectedSpeechLabScreen(
                      currentSpeechLevelReq:
                          quizParams['currentSpeechLevelReq'],
                      selectedLevel: quizParams['selectedLevel']);
                })
          ]),
      GoRoute(
          path: 'quizzes',
          builder: (context, state) => const CustomQuizzesScreen(),
          routes: [
            GoRoute(
                path: 'addQuiz',
                builder: (context, state) => const AddQuizScreen()),
            GoRoute(
                path: 'editQuiz',
                builder: (context, state) {
                  final quizParams = state.extra as Map<dynamic, dynamic>;
                  return EditQuizScreen(
                      quizTitle: quizParams['quizTitle']!,
                      serializedQuizContent:
                          quizParams['serializedQuizContent']!);
                })
          ]),
      GoRoute(
          path: 'ranking', builder: (context, state) => const RankingsScreen())
    ]),
  ]);

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
    return MaterialApp.router(
      title: 'SpeechLab Dashboard',
      /*initialRoute: '/',
      routes: _routes,*/
      routerConfig: _router,
      theme: _themeData,
    );
  }
}
