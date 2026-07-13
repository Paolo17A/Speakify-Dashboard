class UserTypes {
  static const String student = 'STUDENT';
  static const String teacher = 'TEACHER';
  static const String admin = 'ADMIN';
}

class FirestoreCollections {
  static const String users = 'users';
  static const String sections = 'sections';
  static const String lessons = 'lessons';
  static const String quizzes = 'quizzes';
  static const String recentActivities = 'recentActivities';
}

class StoragePaths {
  static const String profilePics = 'profilePics';
}

class UserFields {
  static const String uid = 'uid';
  static const String email = 'email';
  static const String password = 'password';
  static const String firstName = 'firstName';
  static const String lastName = 'lastName';
  static const String userType = 'userType';
  static const String studentID = 'studentID';
  static const String profileImageURL = 'profileImageURL';
  static const String section = 'section';
  static const String currentLesson = 'currentLesson';
  static const String speechLesson = 'speechLesson';
  static const String quizResults = 'quizResults';
  static const String customQuizResults = 'customQuizResults';
  static const String speechResults = 'speechResults';
  static const String achievements = 'achievements';
  static const String lastLoginTime = 'lastLoginTime';
  static const String handledSections = 'handledSections';
}

class SectionFields {
  static const String students = 'students';
  static const String instructors = 'instructors';
  static const String accessedLessons = 'accessedLessons';
  static const String accessedQuizzes = 'accessedQuizzes';
  static const String sectionName = 'sectionName';
}

class QuizResultFields {
  static const String answers = 'answers';
  static const String score = 'score';
  static const String elapsedTime = 'elapsedTime';
  static const String hours = 'hours';
  static const String minutes = 'minutes';
  static const String seconds = 'seconds';
  static const String completedAt = 'completedAt';
  static const String average = 'average';
}

class QuizContentFields {
  static const String question = 'question';
  static const String options = 'options';
  static const String answer = 'answer';
  static const String easy = 'easy';
  static const String average = 'average';
  static const String difficult = 'difficult';
}

class SpeechResultFields {
  static const String confidenceScores = 'confidenceScores';
  static const String completedAt = 'completedAt';
  static const String confidence = 'confidence';
  static const String average = 'average';
}

class QuizDocFields {
  static const String isArchived = 'isArchived';
  static const String quizTitle = 'quizTitle';
  static const String title = 'title';
  static const String quizContent = 'quizContent';
  static const String dateAdded = 'dateAdded';
}

class LessonDocFields {
  static const String title = 'title';
  static const String lessonTitle = 'lessonTitle';
  static const String quizPath = 'quizPath';
  static const String videoPath = 'videoPath';
  static const String description = 'description';
  static const String lessonContent = 'lessonContent';
  static const String index = 'index';
  static const String additionalResources = 'additionalResources';
}
