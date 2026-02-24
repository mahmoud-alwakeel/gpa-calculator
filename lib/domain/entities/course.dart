import 'package:equatable/equatable.dart';

class Course extends Equatable {
  final String id;
  final String name;
  final int credits;
  final String? grade;

  const Course({
    required this.id,
    this.name = '',
    this.credits = 3,
    this.grade,
  });

  Course copyWith({
    String? name,
    int? credits,
    String? grade,
    bool clearGrade = false,
  }) {
    return Course(
      id: id,
      name: name ?? this.name,
      credits: credits ?? this.credits,
      grade: clearGrade ? null : (grade ?? this.grade),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'credits': credits,
        'grade': grade,
      };

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json['id'] as String,
        name: json['name'] as String? ?? '',
        credits: json['credits'] as int? ?? 3,
        grade: json['grade'] as String?,
      );

  @override
  List<Object?> get props => [id, name, credits, grade];
}
