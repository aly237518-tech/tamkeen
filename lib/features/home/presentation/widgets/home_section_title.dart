import 'package:flutter/material.dart';

class HomeSectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const HomeSectionTitle({
    super.key,
    required this.title,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const Spacer(),

        TextButton(
          onPressed: onPressed,
          child: const Text("عرض الكل"),
        ),
      ],
    );
  }
}