import 'package:equatable/equatable.dart';

abstract class GpaEvent extends Equatable {
  const GpaEvent();

  @override
  List<Object?> get props => [];
}

class AddSemester extends GpaEvent {}

class RemoveSemester extends GpaEvent {
  final String semesterId;
  const RemoveSemester(this.semesterId);

  @override
  List<Object?> get props => [semesterId];
}

class ToggleSemesterExpansion extends GpaEvent {
  final String semesterId;
  const ToggleSemesterExpansion(this.semesterId);

  @override
  List<Object?> get props => [semesterId];
}

class AddCourse extends GpaEvent {
  final String semesterId;
  const AddCourse(this.semesterId);

  @override
  List<Object?> get props => [semesterId];
}

class RemoveCourse extends GpaEvent {
  final String semesterId;
  final String courseId;
  const RemoveCourse({required this.semesterId, required this.courseId});

  @override
  List<Object?> get props => [semesterId, courseId];
}

class UpdateCourseName extends GpaEvent {
  final String semesterId;
  final String courseId;
  final String name;
  const UpdateCourseName({
    required this.semesterId,
    required this.courseId,
    required this.name,
  });

  @override
  List<Object?> get props => [semesterId, courseId, name];
}

class UpdateCourseCredits extends GpaEvent {
  final String semesterId;
  final String courseId;
  final int credits;
  const UpdateCourseCredits({
    required this.semesterId,
    required this.courseId,
    required this.credits,
  });

  @override
  List<Object?> get props => [semesterId, courseId, credits];
}

class UpdateCourseGrade extends GpaEvent {
  final String semesterId;
  final String courseId;
  final String grade;
  const UpdateCourseGrade({
    required this.semesterId,
    required this.courseId,
    required this.grade,
  });

  @override
  List<Object?> get props => [semesterId, courseId, grade];
}

class UpdatePriorGpa extends GpaEvent {
  final double? priorGpa;
  const UpdatePriorGpa(this.priorGpa);

  @override
  List<Object?> get props => [priorGpa];
}

class UpdatePriorCredits extends GpaEvent {
  final int? priorCredits;
  const UpdatePriorCredits(this.priorCredits);

  @override
  List<Object?> get props => [priorCredits];
}

class CalculateGpaEvent extends GpaEvent {}

class ResetAll extends GpaEvent {}

class LoadSavedData extends GpaEvent {}
