double calculateAverage(List averages) {
  if (averages.isEmpty) return 0;
  double sum = 0;
  for (final entry in averages) {
    if (entry is Map && entry.containsKey('average')) {
      sum += (entry['average'] as num).toDouble();
    }
  }
  return sum / averages.length;
}
