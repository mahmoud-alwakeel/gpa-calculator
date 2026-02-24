import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/semester.dart';
import '../bloc/gpa_bloc.dart';
import '../bloc/gpa_event.dart';
import '../bloc/gpa_state.dart';
import 'course_row.dart';

class SemesterCard extends StatelessWidget {
  final Semester semester;
  final bool canDelete;

  const SemesterCard({
    super.key,
    required this.semester,
    required this.canDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () {
              context
                  .read<GpaBloc>()
                  .add(ToggleSemesterExpansion(semester.id));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    semester.isExpanded
                        ? Icons.expand_less
                        : Icons.expand_more,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    semester.label,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  // Semester GPA
                  BlocSelector<GpaBloc, GpaState, double?>(
                    selector: (state) =>
                        state.liveResult.semesterGpas[semester.id],
                    builder: (context, gpa) {
                      return Text(
                        gpa != null
                            ? 'GPA: ${gpa.toStringAsFixed(2)}'
                            : 'GPA: --',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                  if (canDelete) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.delete_outline,
                          color: theme.colorScheme.error, size: 20),
                      onPressed: () {
                        context
                            .read<GpaBloc>()
                            .add(RemoveSemester(semester.id));
                      },
                      tooltip: 'Remove semester',
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Content
          if (semester.isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ...semester.courses.map(
                    (course) => CourseRow(
                      key: ValueKey(course.id),
                      semesterId: semester.id,
                      course: course,
                      canDelete: semester.courses.length > 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {
                        context
                            .read<GpaBloc>()
                            .add(AddCourse(semester.id));
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add Course'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
