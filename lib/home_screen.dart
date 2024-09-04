import 'package:flutter/material.dart';
import 'package:gpa_calculator/widgets/calculate_clear_buttons.dart';
import 'package:gpa_calculator/widgets/course_row.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int courseCount = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "GPA Calculator",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 24,
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: courseCount,
                  itemBuilder: (context, index) {
                    return const CourseRow();
                  }),
            ),
            Row(
              children: [
                const Text("Your overall gpa is:" )
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    courseCount++;
                  });
                },
                child: const Text(
                  "+ Add more courses",
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            const CalculateClearButtons(),
          ],
        ),
      ),
    );
  }
}