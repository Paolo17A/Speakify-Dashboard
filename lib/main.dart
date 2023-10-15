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
import 'package:speechlab_dashboard/screens/selected_section_screen.dart';
import 'package:speechlab_dashboard/screens/selected_speechlab_screen.dart';
import 'package:speechlab_dashboard/screens/students_sections_screen.dart';
import 'package:speechlab_dashboard/utils/color_util.dart';

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

  final GoRouter _router = GoRouter(initialLocation: '/', routes: [
    GoRoute(
        path: '/',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
              fullscreenDialog: true,
              key: state.pageKey,
              child: const Welcome(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child);
              });
        },
        routes: [
          GoRoute(
            path: 'register',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                  fullscreenDialog: true,
                  key: state.pageKey,
                  child: const RegisterScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                        opacity: CurveTween(curve: Curves.easeInOutCirc)
                            .animate(animation),
                        child: child);
                  });
            },
          ),
          GoRoute(
              path: 'login',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                    key: state.pageKey,
                    child: const LoginScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                          opacity: CurveTween(curve: Curves.easeInOutCirc)
                              .animate(animation),
                          child: child);
                    });
              }),
          GoRoute(
              path: 'reset',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                    key: state.pageKey,
                    child: const ResetPasswordScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                          opacity: CurveTween(curve: Curves.easeInOutCirc)
                              .animate(animation),
                          child: child);
                    });
              }),
          GoRoute(
              path: 'home',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                    key: state.pageKey,
                    child: const HomeScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                          opacity: CurveTween(curve: Curves.easeInOutCirc)
                              .animate(animation),
                          child: child);
                    });
              }),
          GoRoute(
              path: 'sections',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                    key: state.pageKey,
                    child: const StudentsSectionsScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                          opacity: CurveTween(curve: Curves.easeInOutCirc)
                              .animate(animation),
                          child: child);
                    });
              }),
          GoRoute(
              name: 'selectedSection',
              path: 'sections/:selectedSection',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                    key: state.pageKey,
                    child: SelectedSectionScreen(
                        section: state.pathParameters['selectedSection']!),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                          opacity: CurveTween(curve: Curves.easeInOutCirc)
                              .animate(animation),
                          child: child);
                    });
              }),
          GoRoute(
              path: 'instructors',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                    key: state.pageKey,
                    child: const InstructorsScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                          opacity: CurveTween(curve: Curves.easeInOutCirc)
                              .animate(animation),
                          child: child);
                    });
              },
              routes: [
                GoRoute(
                    path: 'edit',
                    pageBuilder: (context, state) {
                      return CustomTransitionPage(
                          key: state.pageKey,
                          child: const EditProfileScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                                opacity: CurveTween(curve: Curves.easeInOutCirc)
                                    .animate(animation),
                                child: child);
                          });
                    })
              ]),
          GoRoute(
              path: 'lessons',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                    key: state.pageKey,
                    child: const LessonsScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                          opacity: CurveTween(curve: Curves.easeInOutCirc)
                              .animate(animation),
                          child: child);
                    });
              }),
          GoRoute(
              path: 'lessons/addLesson',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                    key: state.pageKey,
                    child: const AddLessonScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                          opacity: CurveTween(curve: Curves.easeInOutCirc)
                              .animate(animation),
                          child: child);
                    });
              }),
          GoRoute(
              name: 'editLesson',
              path: 'lessons/editLesson/:lessonID',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                    key: state.pageKey,
                    child: EditLessonScreen(
                        lessonID: state.pathParameters['lessonID']!),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                          opacity: CurveTween(curve: Curves.easeInOutCirc)
                              .animate(animation),
                          child: child);
                    });
              }),
          GoRoute(
              path: 'scores',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                    key: state.pageKey,
                    child: const ScoresScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                          opacity: CurveTween(curve: Curves.easeInOutCirc)
                              .animate(animation),
                          child: child);
                    });
              }),
          GoRoute(
              name: 'selectedQuiz',
              path: 'scores/selectedQuiz/:quizTitle/:serializedQuizQuestions',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                    key: state.pageKey,
                    child: SelectedCustomQuizScreen(
                        quizTitle: state.pathParameters['quizTitle']!,
                        serializedQuizQuestions:
                            state.pathParameters['serializedQuizQuestions']!),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                          opacity: CurveTween(curve: Curves.easeInOutCirc)
                              .animate(animation),
                          child: child);
                    });
              }),
          GoRoute(
              name: 'selectedSpeechLab',
              path:
                  'scores/selectedSpeechLab/:currentSpeechLevelReq/:selectedLevel',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                    key: state.pageKey,
                    child: SelectedSpeechLabScreen(
                        currentSpeechLevelReq:
                            state.pathParameters['currentSpeechLevelReq']!,
                        selectedLevel: state.pathParameters['selectedLevel']!),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                          opacity: CurveTween(curve: Curves.easeInOutCirc)
                              .animate(animation),
                          child: child);
                    });
              }),
          GoRoute(
              path: 'quizzes',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                    key: state.pageKey,
                    child: const CustomQuizzesScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                          opacity: CurveTween(curve: Curves.easeInOutCirc)
                              .animate(animation),
                          child: child);
                    });
              }),
          GoRoute(
              path: 'quizzes/addQuiz',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                    key: state.pageKey,
                    child: const AddQuizScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                          opacity: CurveTween(curve: Curves.easeInOutCirc)
                              .animate(animation),
                          child: child);
                    });
              }),
          GoRoute(
              name: 'editQuiz',
              path: 'quizzes/editQuiz/:quizTitle/:serializedQuizContent',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                    key: state.pageKey,
                    child: EditQuizScreen(
                        quizTitle: state.pathParameters['quizTitle']!,
                        serializedQuizContent:
                            state.pathParameters['serializedQuizContent']!),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                          opacity: CurveTween(curve: Curves.easeInOutCirc)
                              .animate(animation),
                          child: child);
                    });
              }),
          GoRoute(
              path: 'ranking',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                    key: state.pageKey,
                    child: const RankingsScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                          opacity: CurveTween(curve: Curves.easeInOutCirc)
                              .animate(animation),
                          child: child);
                    });
              })
        ]),
  ]);

  final ThemeData _themeData = ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 60, 19, 97)),
      scaffoldBackgroundColor: const Color.fromARGB(255, 245, 245, 245),
      snackBarTheme: const SnackBarThemeData(backgroundColor: Colors.purple),
      appBarTheme: const AppBarTheme(backgroundColor: CustomColors.orchid),
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
              backgroundColor:
                  MaterialStateProperty.all<Color>(CustomColors.orchid))));

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SpeechLab Dashboard',
      routerConfig: _router,
      theme: _themeData,
    );
  }
}
