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
              },
              routes: [
                GoRoute(
                    path: 'selectedSection',
                    pageBuilder: (context, state) {
                      final sectionParams =
                          state.extra as Map<dynamic, dynamic>;
                      return CustomTransitionPage(
                          key: state.pageKey,
                          child: SelectedSectionScreen(
                              section: sectionParams['section']),
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
              },
              routes: [
                GoRoute(
                    path: 'addLesson',
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
                    path: 'editLesson',
                    pageBuilder: (context, state) {
                      final lessonParams = state.extra as Map<dynamic, dynamic>;
                      return CustomTransitionPage(
                          key: state.pageKey,
                          child: EditLessonScreen(
                              lessonID: lessonParams['lessonID'],
                              lessonTitle: lessonParams['lessonTitle'],
                              lessonContent: lessonParams['lessonContent'],
                              additionalResources:
                                  lessonParams['additionalResources']),
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
              },
              routes: [
                GoRoute(
                    path: 'selectedQuiz',
                    pageBuilder: (context, state) {
                      final quizParams = state.extra as Map<dynamic, dynamic>;
                      return CustomTransitionPage(
                          key: state.pageKey,
                          child: SelectedQuizScreen(
                              currentQuizLevelReq:
                                  quizParams['currentQuizLevelReq'],
                              selectedQuiz: quizParams['selectedQuiz']),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                                opacity: CurveTween(curve: Curves.easeInOutCirc)
                                    .animate(animation),
                                child: child);
                          });
                    }),
                GoRoute(
                    path: 'selectedCustomQuiz',
                    pageBuilder: (context, state) {
                      final quizParams = state.extra as Map<dynamic, dynamic>;
                      return CustomTransitionPage(
                          key: state.pageKey,
                          child: SelectedCustomQuizScreen(
                              quizTitle: quizParams['quizTitle'],
                              serializedquizQuestions:
                                  quizParams['serializedquizQuestions']),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                                opacity: CurveTween(curve: Curves.easeInOutCirc)
                                    .animate(animation),
                                child: child);
                          });
                    }),
                GoRoute(
                    path: 'selectedSpeechLab',
                    pageBuilder: (context, state) {
                      final quizParams = state.extra as Map<dynamic, dynamic>;
                      return CustomTransitionPage(
                          key: state.pageKey,
                          child: SelectedSpeechLabScreen(
                              currentSpeechLevelReq:
                                  quizParams['currentSpeechLevelReq'],
                              selectedLevel: quizParams['selectedLevel']),
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
              },
              routes: [
                GoRoute(
                    path: 'addQuiz',
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
                    path: 'editQuiz',
                    pageBuilder: (context, state) {
                      final quizParams = state.extra as Map<dynamic, dynamic>;

                      return CustomTransitionPage(
                          key: state.pageKey,
                          child: EditQuizScreen(
                              quizTitle: quizParams['quizTitle']!,
                              serializedQuizContent:
                                  quizParams['serializedQuizContent']!),
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
      routerConfig: _router,
      theme: _themeData,
    );
  }
}
