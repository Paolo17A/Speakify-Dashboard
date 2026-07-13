import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/core/session/auth_session_notifier.dart';
import 'package:speechlab_dashboard/core/utils/app_routes.dart';
import 'package:speechlab_dashboard/features/auth/presentation/pages/login_page.dart';
import 'package:speechlab_dashboard/features/auth/presentation/pages/register_page.dart';
import 'package:speechlab_dashboard/features/auth/presentation/pages/reset_password_page.dart';
import 'package:speechlab_dashboard/features/auth/presentation/pages/welcome_page.dart';
import 'package:speechlab_dashboard/features/home/presentation/pages/home_page.dart';
import 'package:speechlab_dashboard/features/instructors/presentation/pages/edit_profile_page.dart';
import 'package:speechlab_dashboard/features/instructors/presentation/pages/instructors_page.dart';
import 'package:speechlab_dashboard/features/lessons/presentation/pages/add_lesson_page.dart';
import 'package:speechlab_dashboard/features/lessons/presentation/pages/edit_lesson_page.dart';
import 'package:speechlab_dashboard/features/lessons/presentation/pages/lessons_page.dart';
import 'package:speechlab_dashboard/features/quizzes/presentation/pages/add_quiz_page.dart';
import 'package:speechlab_dashboard/features/quizzes/presentation/pages/custom_quizzes_page.dart';
import 'package:speechlab_dashboard/features/quizzes/presentation/pages/edit_quiz_page.dart';
import 'package:speechlab_dashboard/features/ranking/presentation/pages/rankings_page.dart';
import 'package:speechlab_dashboard/features/ranking/presentation/pages/selected_quiz_leaderboard_page.dart';
import 'package:speechlab_dashboard/features/ranking/presentation/pages/selected_speechlab_leaderboard_page.dart';
import 'package:speechlab_dashboard/features/scores/presentation/pages/scores_page.dart';
import 'package:speechlab_dashboard/features/scores/presentation/pages/selected_custom_quiz_page.dart';
import 'package:speechlab_dashboard/features/scores/presentation/pages/selected_speechlab_page.dart';
import 'package:speechlab_dashboard/features/sections/presentation/pages/edit_section_page.dart';
import 'package:speechlab_dashboard/features/sections/presentation/pages/students_sections_page.dart';

class AppRouter {
  AppRouter._();

  static CustomTransitionPage<void> _fadePage({
    required GoRouterState state,
    required Widget child,
    bool fullscreenDialog = false,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      fullscreenDialog: fullscreenDialog,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
          child: child,
        );
      },
    );
  }

  static String? _redirect(BuildContext context, GoRouterState state) {
    final session = authRefreshListenable.session;
    if (!session.authReady) return null;

    final location = state.matchedLocation;
    final isPublic = AppRoutes.isPublicPath(location);

    if (!session.isAuthenticated) {
      return isPublic ? null : AppRoutes.login;
    }

    if (isPublic) return AppRoutes.home;

    if (AppRoutes.isAdminOnlyPath(location) && !session.isAdmin) {
      return AppRoutes.home;
    }

    return null;
  }

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.welcome,
    refreshListenable: authRefreshListenable,
    redirect: _redirect,
    routes: [
      GoRoute(
        path: AppRoutes.welcome,
        pageBuilder: (context, state) => _fadePage(
          state: state,
          child: const WelcomePage(),
          fullscreenDialog: true,
        ),
        routes: [
          GoRoute(
            path: 'register',
            pageBuilder: (context, state) => _fadePage(
              state: state,
              child: const RegisterPage(),
              fullscreenDialog: true,
            ),
          ),
          GoRoute(
            path: 'login',
            pageBuilder: (context, state) =>
                _fadePage(state: state, child: const LoginPage()),
          ),
          GoRoute(
            path: 'reset',
            pageBuilder: (context, state) =>
                _fadePage(state: state, child: const ResetPasswordPage()),
          ),
          GoRoute(
            path: 'home',
            pageBuilder: (context, state) =>
                _fadePage(state: state, child: const HomePage()),
          ),
          GoRoute(
            path: 'sections',
            pageBuilder: (context, state) =>
                _fadePage(state: state, child: const StudentsSectionsPage()),
          ),
          GoRoute(
            path: 'instructors',
            pageBuilder: (context, state) =>
                _fadePage(state: state, child: const InstructorsPage()),
            routes: [
              GoRoute(
                path: 'edit',
                pageBuilder: (context, state) =>
                    _fadePage(state: state, child: const EditProfilePage()),
              ),
            ],
          ),
          GoRoute(
            path: 'lessons',
            pageBuilder: (context, state) =>
                _fadePage(state: state, child: const LessonsPage()),
          ),
          GoRoute(
            name: AppRoutes.editSection,
            path: 'editSection/:sectionName',
            pageBuilder: (context, state) => _fadePage(
              state: state,
              child: EditSectionPage(
                sectionName: state.pathParameters['sectionName']!,
              ),
            ),
          ),
          GoRoute(
            path: 'lessons/addLesson',
            pageBuilder: (context, state) =>
                _fadePage(state: state, child: const AddLessonPage()),
          ),
          GoRoute(
            name: AppRoutes.editLesson,
            path: 'lessons/editLesson/:lessonID',
            pageBuilder: (context, state) => _fadePage(
              state: state,
              child: EditLessonPage(
                lessonID: state.pathParameters['lessonID']!,
              ),
            ),
          ),
          GoRoute(
            path: 'scores',
            pageBuilder: (context, state) =>
                _fadePage(state: state, child: const ScoresPage()),
          ),
          GoRoute(
            name: AppRoutes.selectedQuiz,
            path: 'scores/selectedQuiz/:quizTitle',
            pageBuilder: (context, state) => _fadePage(
              state: state,
              child: SelectedCustomQuizPage(
                quizTitle: state.pathParameters['quizTitle']!,
              ),
            ),
          ),
          GoRoute(
            name: AppRoutes.selectedSpeechLab,
            path: 'scores/selectedSpeechLab/:currentSpeechLevelReq',
            pageBuilder: (context, state) => _fadePage(
              state: state,
              child: SelectedSpeechLabPage(
                currentSpeechLevelReq:
                    state.pathParameters['currentSpeechLevelReq']!,
              ),
            ),
          ),
          GoRoute(
            path: 'quizzes',
            pageBuilder: (context, state) =>
                _fadePage(state: state, child: const CustomQuizzesPage()),
          ),
          GoRoute(
            path: 'quizzes/addQuiz',
            pageBuilder: (context, state) =>
                _fadePage(state: state, child: const AddQuizPage()),
          ),
          GoRoute(
            name: AppRoutes.editQuiz,
            path: 'quizzes/editQuiz/:quizTitle',
            pageBuilder: (context, state) => _fadePage(
              state: state,
              child: EditQuizPage(
                quizTitle: state.pathParameters['quizTitle']!,
              ),
            ),
          ),
          GoRoute(
            path: 'ranking',
            pageBuilder: (context, state) =>
                _fadePage(state: state, child: const RankingsPage()),
          ),
          GoRoute(
            name: AppRoutes.quizRanking,
            path: 'quizRanking/:quizID',
            pageBuilder: (context, state) => _fadePage(
              state: state,
              child: SelectedQuizLeaderboardPage(
                quizID: state.pathParameters['quizID']!,
              ),
            ),
          ),
          GoRoute(
            name: AppRoutes.speechRanking,
            path: 'speechRanking/:currentSpeechLevelReq',
            pageBuilder: (context, state) => _fadePage(
              state: state,
              child: SelectedSpeechlabLeaderboardPage(
                currentSpeechLevelReq:
                    state.pathParameters['currentSpeechLevelReq']!,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
