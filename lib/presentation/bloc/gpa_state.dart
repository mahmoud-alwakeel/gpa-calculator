import 'package:equatable/equatable.dart';

import '../../domain/entities/gpa_result.dart';
import '../../domain/entities/semester.dart';

class GpaState extends Equatable {
  final List<Semester> semesters;
  final double? priorGpa;
  final int? priorCredits;
  final GpaResult liveResult;
  final GpaResult? confirmedResult;
  final String? errorMessage;

  const GpaState({
    this.semesters = const [],
    this.priorGpa,
    this.priorCredits,
    this.liveResult = const GpaResult(),
    this.confirmedResult,
    this.errorMessage,
  });

  GpaState copyWith({
    List<Semester>? semesters,
    double? priorGpa,
    bool clearPriorGpa = false,
    int? priorCredits,
    bool clearPriorCredits = false,
    GpaResult? liveResult,
    GpaResult? confirmedResult,
    bool clearConfirmedResult = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return GpaState(
      semesters: semesters ?? this.semesters,
      priorGpa: clearPriorGpa ? null : (priorGpa ?? this.priorGpa),
      priorCredits:
          clearPriorCredits ? null : (priorCredits ?? this.priorCredits),
      liveResult: liveResult ?? this.liveResult,
      confirmedResult: clearConfirmedResult
          ? null
          : (confirmedResult ?? this.confirmedResult),
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        semesters,
        priorGpa,
        priorCredits,
        liveResult,
        confirmedResult,
        errorMessage,
      ];
}
