import 'package:flutter/material.dart';
import 'package:gpa_calculator/models/grade.dart';

class CourseRow extends StatefulWidget {
  const CourseRow({super.key});

  @override
  State<CourseRow> createState() => _CourseRowState();
}

class _CourseRowState extends State<CourseRow> {
  Grade _selectedGrade = Grade.A;
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _creditHoursController = TextEditingController();

  @override
  void dispose() {
    _courseNameController.dispose();
    _creditHoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: _courseNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Math",
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: TextField(
              controller: _creditHoursController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "3",
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: DropdownButton(
              value: _selectedGrade,
              items: Grade.values
                  .map(
                    (grade) => DropdownMenuItem(
                      value: grade,
                      child: Text(
                        grade.display,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                setState(() {
                  if (val == null) {
                    return;
                  }
                  _selectedGrade = val;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
