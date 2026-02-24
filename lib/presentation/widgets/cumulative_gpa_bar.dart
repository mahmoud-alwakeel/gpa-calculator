import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/gpa_bloc.dart';
import '../bloc/gpa_state.dart';

class CumulativeGpaBar extends StatelessWidget {
  const CumulativeGpaBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocSelector<GpaBloc, GpaState, double?>(
      selector: (state) => state.liveResult.cumulativeGpa,
      builder: (context, gpa) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cumulative GPA',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                gpa != null ? gpa.toStringAsFixed(2) : '--',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
