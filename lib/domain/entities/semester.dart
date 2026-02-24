import 'package:equatable/equatable.dart';

import 'course.dart';

class Semester extends Equatable {
  final String id;
  final String label;
  final List<Course> courses;
  final bool isExpanded;

  const Semester({
    required this.id,
    required this.label,
    this.courses = const [],
    this.isExpanded = true,
  });

  Semester copyWith({
    String? label,
    List<Course>? courses,
    bool? isExpanded,
  }) {
    return Semester(
      id: id,
      label: label ?? this.label,
      courses: courses ?? this.courses,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'courses': courses.map((c) => c.toJson()).toList(),
      };

  factory Semester.fromJson(Map<String, dynamic> json) => Semester(
        id: json['id'] as String,
        label: json['label'] as String,
        courses: (json['courses'] as List)
            .map((c) => Course.fromJson(c as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props => [id, label, courses, isExpanded];
}
