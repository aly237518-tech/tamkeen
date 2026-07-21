import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';

class AppEmpty extends StatelessWidget {
  final String message;
  final IconData icon;

  const AppEmpty({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 70,
            color: Colors.grey,
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: AppTextStyles.body,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}