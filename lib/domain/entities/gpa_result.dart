import 'package:equatable/equatable.dart';

class GpaResult extends Equatable {
  final Map<String, double?> semesterGpas;
  final double? cumulativeGpa;

  const GpaResult({
    this.semesterGpas = const {},
    this.cumulativeGpa,
  });

  @override
  List<Object?> get props => [semesterGpas, cumulativeGpa];
}
