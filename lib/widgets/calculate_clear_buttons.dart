import 'package:flutter/material.dart';

class CalculateClearButtons extends StatelessWidget {
  const CalculateClearButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            label: const Text(
              "Calculate",
            ),
            icon: const Icon(Icons.play_arrow),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        ElevatedButton.icon(
          onPressed: () {},
          label: const Text(
            "Clear",
          ),
          icon: const Icon(Icons.restart_alt_rounded),
        ),
      ],
    );
  }
}
