import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/gpa_bloc.dart';
import '../bloc/gpa_event.dart';
import '../bloc/gpa_state.dart';
import '../widgets/cumulative_gpa_bar.dart';
import '../widgets/gpa_summary_card.dart';
import '../widgets/prior_gpa_card.dart';
import '../widgets/semester_card.dart';

class GpaPage extends StatelessWidget {
  const GpaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<GpaBloc, GpaState>(
      listenWhen: (prev, curr) =>
          curr.errorMessage != null && curr.errorMessage != prev.errorMessage,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage!),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('GPA Calculator'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const PriorGpaCard(),
                    BlocBuilder<GpaBloc, GpaState>(
                      buildWhen: (prev, curr) =>
                          prev.semesters != curr.semesters,
                      builder: (context, state) {
                        return Column(
                          children: [
                            ...state.semesters.map(
                              (semester) => SemesterCard(
                                key: ValueKey(semester.id),
                                semester: semester,
                                canDelete: state.semesters.length > 1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextButton.icon(
                              onPressed: () {
                                context.read<GpaBloc>().add(AddSemester());
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Add Semester'),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              context
                                  .read<GpaBloc>()
                                  .add(CalculateGpaEvent());
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                'Calculate',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: () {
                            context.read<GpaBloc>().add(ResetAll());
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text('Reset All'),
                          ),
                        ),
                      ],
                    ),
                    const GpaSummaryCard(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            const CumulativeGpaBar(),
          ],
        ),
      ),
    );
  }
}
