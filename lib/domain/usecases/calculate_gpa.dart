import '../entities/gpa_result.dart';
import '../entities/semester.dart';
import '../../core/constants/grade_scale.dart';

class CalculateGpa {
  GpaResult call({
    required List<Semester> semesters,
    double? priorGpa,
    int? priorCredits,
  }) {
    final semesterGpas = <String, double?>{};
    double totalPoints = 0;
    int totalCredits = 0;

    for (final semester in semesters) {
      double semPoints = 0;
      int semCredits = 0;

      for (final course in semester.courses) {
        if (course.grade == null) continue;
        final points = GradeScale.gradePoints[course.grade];
        if (points == null) continue; // P/NP excluded

        semPoints += course.credits * points;
        semCredits += course.credits;
      }

      semesterGpas[semester.id] =
          semCredits > 0 ? semPoints / semCredits : null;

      totalPoints += semPoints;
      totalCredits += semCredits;
    }

    double? cumulativeGpa;

    if (priorGpa != null && priorCredits != null && priorCredits > 0) {
      final combinedPoints = priorGpa * priorCredits + totalPoints;
      final combinedCredits = priorCredits + totalCredits;
      if (combinedCredits > 0) {
        cumulativeGpa = combinedPoints / combinedCredits;
      }
    } else if (totalCredits > 0) {
      cumulativeGpa = totalPoints / totalCredits;
    }

    return GpaResult(
      semesterGpas: semesterGpas,
      cumulativeGpa: cumulativeGpa,
    );
  }
}
