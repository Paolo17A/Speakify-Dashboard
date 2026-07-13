import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/features/lessons/data/models/lesson_model.dart';

enum AchievementCategory { quiz, speech }

class AchievementModel {
  String description;
  IconData? icon;
  String? imagePath;
  bool Function(Map<dynamic, dynamic> quizResults) achievementChecker;
  AchievementCategory achievementType;
  AchievementModel(
      {required this.description,
      required this.achievementChecker,
      required this.achievementType,
      this.icon = Icons.light,
      this.imagePath});
}

Map<String, AchievementModel> allAchievements = {
  "Beginner's Luck": AchievementModel(
      description: 'Finish the first quiz topic on all difficulty levels',
      achievementType: AchievementCategory.quiz,
      icon: Icons.star,
      achievementChecker: (quizResults) {
        if (quizResults.isNotEmpty &&
            (quizResults['1'] as Map<dynamic, dynamic>).length >= 3) {
          return true;
        }
        return false;
      }),
  "Quiz Whiz": AchievementModel(
      description:
          'Achieve an average score of 85% or higher in at least 50 quizzes.',
      achievementType: AchievementCategory.quiz,
      icon: Icons.star,
      imagePath: 'assets/images/badges/quiz_whiz.png',
      achievementChecker: (quizResults) {
        int totalScore = 0;
        List<int> allScores = getQuizScores(quizResults);
        for (int i = 0; i < allScores.length; i++) {
          totalScore += allScores[i];
        }
        double averageScore = totalScore / allScores.length;
        if (getQuizzesTaken(quizResults) >= 50 && averageScore >= 8.5) {
          return true;
        }
        return false;
      }),
  "Quiz Thinker": AchievementModel(
      description:
          'Answer all quiz questions within the time limit for 20 quizzes',
      achievementType: AchievementCategory.quiz,
      icon: Icons.speed,
      imagePath: 'assets/images/badges/quiz_thinker.png',
      achievementChecker: (quizResults) {
        if (getQuizzesTaken(quizResults) >= 20) {
          return true;
        }
        return false;
      }),
  "Subject Master": AchievementModel(
      description:
          'Score an average of 80% or higher in quizzes for three categories',
      achievementType: AchievementCategory.quiz,
      icon: Icons.subject,
      imagePath: 'assets/images/badges/subject_master.png',
      achievementChecker: (quizResults) {
        List<double> quizAverages = [];
        for (int i = 0; i < quizResults.length; i++) {
          if ((quizResults[(i + 1).toString()] as Map<dynamic, dynamic>)
                  .length ==
              3) {
            quizAverages
                .add(getAverageQuizScore(quizResults[(i + 1).toString()]));
          }
        }
        bool hasAllMetQuota = true;
        for (int i = 0; i < quizAverages.length; i++) {
          if (quizAverages[i] < 8.0) {
            hasAllMetQuota = false;
            break;
          }
        }
        if (quizAverages.length >= 3 && hasAllMetQuota) {
          return true;
        }
        return false;
      }),
  "Speed Racer": AchievementModel(
      description: 'Complete 10 quizzes within the specified time limit.',
      achievementType: AchievementCategory.quiz,
      icon: Icons.abc,
      imagePath: 'assets/images/badges/speed_racer.png',
      achievementChecker: (quizResults) {
        if (getQuizzesTaken(quizResults) >= 10) {
          return true;
        }
        return false;
      }),
  "Perfect Score": AchievementModel(
      description: 'Achieve a perfect score (100%) in five quizzes.',
      achievementType: AchievementCategory.quiz,
      icon: Icons.percent,
      imagePath: 'assets/images/badges/perfect_score.png',
      achievementChecker: (quizResults) {
        List<int> allScores = getQuizScores(quizResults);
        int perfectScores = 0;
        for (int i = 0; i < allScores.length; i++) {
          if (allScores[i] == 10) {
            perfectScores++;
          }
        }
        if (perfectScores >= 5) {
          return true;
        }
        return false;
      }),
  "Persistent Learner": AchievementModel(
      description: 'Attempt at least 50 quizzes, regardless of the score',
      achievementType: AchievementCategory.quiz,
      icon: Icons.person,
      imagePath: 'assets/images/badges/persistent_learner.png',
      achievementChecker: (quizResults) {
        if (getQuizzesTaken(quizResults) >= 50) {
          return true;
        }
        return false;
      }),
  "Knowledge Explorer": AchievementModel(
      description:
          'Complete quizzes from 10 different categories each with an average score of 75% or higher.',
      achievementType: AchievementCategory.quiz,
      icon: Icons.scale,
      imagePath: 'assets/images/badges/knowledge_explorer.png',
      achievementChecker: (quizResults) {
        List<double> quizAverages = [];
        for (int i = 0; i < quizResults.length; i++) {
          if ((quizResults[(i + 1).toString()] as Map<dynamic, dynamic>)
                  .length ==
              3) {
            quizAverages
                .add(getAverageQuizScore(quizResults[(i + 1).toString()]));
          }
        }
        bool hasAllMetQuota = true;
        for (int i = 0; i < quizAverages.length; i++) {
          if (quizAverages[i] < 7.5) {
            hasAllMetQuota = false;
            break;
          }
        }
        if (quizAverages.length >= 10 && hasAllMetQuota) {
          return true;
        }
        return false;
      }),
  "Challenge Conqueror": AchievementModel(
      description:
          'Successfully complete five difficult quizzes with a score of 80% or higher. ',
      achievementType: AchievementCategory.quiz,
      icon: Icons.medical_information,
      imagePath: 'assets/images/badges/challenge_conquerer.png',
      achievementChecker: (quizResults) {
        List<int> difficultQuizzesResults = [];
        quizResults.forEach((indexKey, indexValue) {
          if ((indexValue as Map<dynamic, dynamic>).containsKey('DIFFICULT')) {
            indexValue.forEach((key, value) {
              difficultQuizzesResults.add(value['score']);
            });
          }
        });
        bool isAllAboveQuota = true;
        for (int i = 0; i < difficultQuizzesResults.length; i++) {
          if (difficultQuizzesResults[i] < 8) {
            isAllAboveQuota = false;
          }
        }
        if (difficultQuizzesResults.length >= 5 && isAllAboveQuota) {
          return true;
        }
        return false;
      }),
  "Quiz Champion": AchievementModel(
      description: 'Answer all quizzes with a perfect score',
      achievementType: AchievementCategory.quiz,
      icon: Icons.medical_information,
      imagePath: 'assets/images/badges/quiz_champion.png',
      achievementChecker: (quizResults) {
        bool isAllPerfect = true;
        List<int> allScores = getQuizScores(quizResults);
        for (int i = 0; i < allScores.length; i++) {
          if (allScores[i] != 10) {
            isAllPerfect = false;
            break;
          }
        }
        if (quizResults.length == allLessons.length && isAllPerfect) {
          return true;
        }
        return false;
      }),
  "Diction Master": AchievementModel(
      description:
          'Aim for high accuracy and precision in articulation words and sounds',
      achievementType: AchievementCategory.speech,
      imagePath: 'assets/images/badges/diction_master.png',
      achievementChecker: (speechResults) {
        if (speechResults.isNotEmpty &&
            getAverageSpeechConfidence(speechResults['1']['confidenceScores']) >
                85) {
          return true;
        }
        return false;
      }),
  "Fluent Speaker": AchievementModel(
      description:
          'Use the app\'s feedback to refine and improve pronounciation and fluency',
      achievementType: AchievementCategory.speech,
      imagePath: 'assets/images/badges/fluent_speaker.png',
      achievementChecker: (speechResults) {
        if (speechResults.length >= 2 &&
            getAverageSpeechConfidence(speechResults['2']['confidenceScores']) >
                85) {
          return true;
        }
        return false;
      }),
  "Pronounciation Pro": AchievementModel(
      description:
          'Take advantage of the app\'s audio playback and comparison features to fine-tune pronounciation',
      achievementType: AchievementCategory.speech,
      imagePath: 'assets/images/badges/pronounciation_pro.png',
      achievementChecker: (speechResults) {
        if (speechResults.length >= 3 &&
            getAverageSpeechConfidence(speechResults['3']['confidenceScores']) >
                85) {
          return true;
        }
        return false;
      }),
  "Clear Communicator": AchievementModel(
      description:
          'Seek to convey messages in a concise and understandable manner',
      achievementType: AchievementCategory.speech,
      imagePath: 'assets/images/badges/clear_communicator.png',
      achievementChecker: (speechResults) {
        if (speechResults.length >= 4 &&
            getAverageSpeechConfidence(speechResults['4']['confidenceScores']) >
                85) {
          return true;
        }
        return false;
      }),
  "Linguistics Guru": AchievementModel(
      description:
          'Apply your knowledge to analyze and improve speech patterns and language usage',
      achievementType: AchievementCategory.speech,
      imagePath: 'assets/images/badges/linguistics_guru.png',
      achievementChecker: (speechResults) {
        if (speechResults.length >= 5 &&
            getAverageSpeechConfidence(speechResults['5']['confidenceScores']) >
                85) {
          return true;
        }
        return false;
      }),
  "Vocal Virtuoso": AchievementModel(
      description: 'Seek to develop a pleasant and expressive voice',
      achievementType: AchievementCategory.speech,
      imagePath: 'assets/images/badges/vocal virtuoso.png',
      achievementChecker: (speechResults) {
        if (speechResults.length >= 6 &&
            getAverageSpeechConfidence(speechResults['6']['confidenceScores']) >
                85) {
          return true;
        }
        return false;
      }),
  "Persuasive Orator": AchievementModel(
      description:
          'Incorporate appropriate gestures, body language, and vocal dynamics to enhance persuasion',
      achievementType: AchievementCategory.speech,
      imagePath: 'assets/images/badges/persuasive_orator.png',
      achievementChecker: (speechResults) {
        if (speechResults.length >= 7 &&
            getAverageSpeechConfidence(speechResults['7']['confidenceScores']) >
                85) {
          return true;
        }
        return false;
      }),
  "Eloquent Expresser": AchievementModel(
      description: 'Seek to develop a natural and engaging speaking style',
      achievementType: AchievementCategory.speech,
      imagePath: 'assets/images/badges/eloquent_expresser.png',
      achievementChecker: (speechResults) {
        if (speechResults.length >= 8 &&
            getAverageSpeechConfidence(speechResults['8']['confidenceScores']) >
                85) {
          return true;
        }
        return false;
      }),
  "Intonation Maestro": AchievementModel(
      description:
          'Use intonation to express emotions, emphasize important points, and create nuance in speech',
      achievementType: AchievementCategory.speech,
      imagePath: 'assets/images/badges/intonation_maestro.png',
      achievementChecker: (speechResults) {
        if (speechResults.length >= 9 &&
            getAverageSpeechConfidence(speechResults['9']['confidenceScores']) >
                85) {
          return true;
        }
        return false;
      }),
  "Resilient Learner": AchievementModel(
      description:
          'Persist in practicing, seeking feedback, and refining your skills',
      achievementType: AchievementCategory.speech,
      imagePath: 'assets/images/badges/resilient_learner.png',
      achievementChecker: (speechResults) {
        if (speechResults.length >= 10 &&
            getAverageSpeechConfidence(
                    speechResults['10']['confidenceScores']) >
                85) {
          return true;
        }
        return false;
      }),
};

AchievementModel? getAchievement(String achievementName) {
  return allAchievements[achievementName];
}

int getQuizzesTaken(Map<dynamic, dynamic> quizResults) {
  int quizzesTaken = 0;
  quizResults.forEach((key, value) {
    quizzesTaken += (value as Map<dynamic, dynamic>).length;
  });
  return quizzesTaken;
}

List<int> getQuizScores(Map<dynamic, dynamic> quizResults) {
  List<int> allScores = [];
  quizResults.forEach((quizIndexKey, quizIndexValue) {
    (quizIndexValue as Map<dynamic, dynamic>).forEach((key, value) {
      allScores.add(value['score']);
    });
  });
  return allScores;
}

double getAverageQuizScore(Map<dynamic, dynamic> quizCategory) {
  double totalScore = 0;
  quizCategory.forEach((difficultyKey, difficultyValue) {
    totalScore += (difficultyValue as Map<dynamic, dynamic>)['score'];
  });
  return totalScore / quizCategory.length;
}

double getAverageSpeechConfidence(List<dynamic> confidenceLevels) {
  double sum = 0;
  int count = 0;
  for (var value in confidenceLevels) {
    if (value is double) {
      sum += value;
      count++;
    }
  }
  if (count == 0) return 0;
  return (sum / count) * 100;
}
