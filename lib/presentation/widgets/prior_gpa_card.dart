import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/gpa_bloc.dart';
import '../bloc/gpa_event.dart';

class PriorGpaCard extends StatefulWidget {
  const PriorGpaCard({super.key});

  @override
  State<PriorGpaCard> createState() => _PriorGpaCardState();
}

class _PriorGpaCardState extends State<PriorGpaCard> {
  final _gpaController = TextEditingController();
  final _creditsController = TextEditingController();

  @override
  void dispose() {
    _gpaController.dispose();
    _creditsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Prior Semester (Optional)',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _gpaController,
                    decoration: const InputDecoration(
                      labelText: 'Prior GPA',
                      hintText: 'e.g. 3.5',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      isDense: true,
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      final parsed = double.tryParse(value);
                      context.read<GpaBloc>().add(UpdatePriorGpa(parsed));
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _creditsController,
                    decoration: const InputDecoration(
                      labelText: 'Credits Completed',
                      hintText: 'e.g. 30',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final parsed = int.tryParse(value);
                      context.read<GpaBloc>().add(UpdatePriorCredits(parsed));
                    },
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
