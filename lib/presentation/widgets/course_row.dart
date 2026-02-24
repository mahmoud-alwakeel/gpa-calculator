import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/grade_scale.dart';
import '../../domain/entities/course.dart';
import '../bloc/gpa_bloc.dart';
import '../bloc/gpa_event.dart';

class CourseRow extends StatefulWidget {
  final String semesterId;
  final Course course;
  final bool canDelete;

  const CourseRow({
    super.key,
    required this.semesterId,
    required this.course,
    required this.canDelete,
  });

  @override
  State<CourseRow> createState() => _CourseRowState();
}

class _CourseRowState extends State<CourseRow> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.course.name);
  }

  @override
  void didUpdateWidget(CourseRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.course.id != widget.course.id) {
      _nameController.text = widget.course.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Course name
          Expanded(
            flex: 3,
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Course name',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                isDense: true,
              ),
              onChanged: (value) {
                context.read<GpaBloc>().add(UpdateCourseName(
                      semesterId: widget.semesterId,
                      courseId: widget.course.id,
                      name: value,
                    ));
              },
            ),
          ),
          const SizedBox(width: 8),

          // Credits dropdown
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<int>(
              value: widget.course.credits,
              decoration: const InputDecoration(
                labelText: 'Credits',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                isDense: true,
              ),
              items: List.generate(6, (i) => i + 1)
                  .map((c) => DropdownMenuItem(value: c, child: Text('$c')))
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                context.read<GpaBloc>().add(UpdateCourseCredits(
                      semesterId: widget.semesterId,
                      courseId: widget.course.id,
                      credits: value,
                    ));
              },
            ),
          ),
          const SizedBox(width: 8),

          // Grade dropdown
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<String>(
              value: widget.course.grade,
              decoration: const InputDecoration(
                labelText: 'Grade',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                isDense: true,
              ),
              items: GradeScale.grades
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                context.read<GpaBloc>().add(UpdateCourseGrade(
                      semesterId: widget.semesterId,
                      courseId: widget.course.id,
                      grade: value,
                    ));
              },
            ),
          ),
          const SizedBox(width: 4),

          // Delete button
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: widget.canDelete
                ? () {
                    context.read<GpaBloc>().add(RemoveCourse(
                          semesterId: widget.semesterId,
                          courseId: widget.course.id,
                        ));
                  }
                : null,
            tooltip: 'Remove course',
          ),
        ],
      ),
    );
  }
}
