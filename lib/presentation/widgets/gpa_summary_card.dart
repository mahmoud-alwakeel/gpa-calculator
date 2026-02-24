import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/gpa_result.dart';
import '../bloc/gpa_bloc.dart';
import '../bloc/gpa_state.dart';

class GpaSummaryCard extends StatelessWidget {
  const GpaSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GpaBloc, GpaState>(
      buildWhen: (prev, curr) => prev.confirmedResult != curr.confirmedResult,
      builder: (context, state) {
        final result = state.confirmedResult;
        if (result == null) return const SizedBox.shrink();

        return _buildSummary(context, state, result);
      },
    );
  }

  Widget _buildSummary(
    BuildContext context,
    GpaState state,
    GpaResult result,
  ) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(top: 16),
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GPA Results',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 12),

            // Per-semester GPAs
            ...state.semesters.map((semester) {
              final gpa = result.semesterGpas[semester.id];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      semester.label,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      gpa != null ? gpa.toStringAsFixed(2) : 'N/A',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              );
            }),

            const Divider(height: 24),

            // Cumulative GPA
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cumulative GPA',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                Text(
                  result.cumulativeGpa != null
                      ? result.cumulativeGpa!.toStringAsFixed(2)
                      : 'N/A',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
