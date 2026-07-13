/// Static route path/name constants. Use these instead of raw path strings.
class AppRoutes {
  AppRoutes._();

  // Public / auth
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String reset = '/reset';

  // Authenticated
  static const String home = '/home';
  static const String sections = '/sections';
  static const String instructors = '/instructors';
  static const String instructorsEdit = '/instructors/edit';
  static const String lessons = '/lessons';
  static const String addLesson = '/lessons/addLesson';
  static const String editLesson = 'editLesson';
  static const String editLessonPath = '/lessons/editLesson/:lessonID';
  static const String editSection = 'editSection';
  static const String editSectionPath = '/editSection/:sectionName';
  static const String scores = '/scores';
  static const String selectedQuiz = 'selectedQuiz';
  static const String selectedQuizPath = '/scores/selectedQuiz/:quizTitle';
  static const String selectedSpeechLab = 'selectedSpeechLab';
  static const String selectedSpeechLabPath =
      '/scores/selectedSpeechLab/:currentSpeechLevelReq';
  static const String quizzes = '/quizzes';
  static const String addQuiz = '/quizzes/addQuiz';
  static const String editQuiz = 'editQuiz';
  static const String editQuizPath = '/quizzes/editQuiz/:quizTitle';
  static const String ranking = '/ranking';
  static const String quizRanking = 'quizRanking';
  static const String quizRankingPath = '/quizRanking/:quizID';
  static const String speechRanking = 'speechRanking';
  static const String speechRankingPath =
      '/speechRanking/:currentSpeechLevelReq';

  static const Set<String> publicPaths = {
    welcome,
    login,
    register,
    reset,
  };

  /// Routes only ADMIN may open. TEACHER deep-links redirect to [home].
  static const Set<String> adminOnlyExactPaths = {
    instructors,
  };

  static bool isPublicPath(String location) {
    final path = Uri.parse(location).path;
    return publicPaths.contains(path);
  }

  static bool isAdminOnlyPath(String location) {
    final path = Uri.parse(location).path;
    if (adminOnlyExactPaths.contains(path)) return true;
    // Exact match only for /instructors — /instructors/edit is allowed for teachers.
    return false;
  }
}
