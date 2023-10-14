double calculateAverage(List<dynamic> selectedLevel) {
  double sum = 0;

  for (var value in selectedLevel) {
    sum += value['average'];
  }

  return sum / selectedLevel.length;
}
