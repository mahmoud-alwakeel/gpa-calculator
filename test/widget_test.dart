import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gpa_calculator/presentation/bloc/gpa_bloc.dart';
import 'package:gpa_calculator/presentation/pages/gpa_page.dart';

void main() {
  testWidgets('GPA Calculator smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => GpaBloc(),
          child: const GpaPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('GPA Calculator'), findsOneWidget);
    expect(find.text('Semester 1'), findsOneWidget);
    expect(find.text('Cumulative GPA'), findsOneWidget);
    expect(find.text('Add Course'), findsOneWidget);
    expect(find.text('Add Semester'), findsOneWidget);
    expect(find.text('Calculate'), findsOneWidget);
    expect(find.text('Reset All'), findsOneWidget);
  });
}
