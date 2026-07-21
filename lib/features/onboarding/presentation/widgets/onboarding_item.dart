import 'package:flutter/material.dart';

import '../models/onboarding_model.dart';

class OnboardingItem extends StatelessWidget {
  final OnboardingModel model;

  const OnboardingItem({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 20,
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),

          Expanded(
            flex: 6,
            child: Center(
              child: SizedBox(
                width: 280,
                height: 280,
                child: Image.asset(
                  model.image,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          Text(
            model.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xff6A1B9A),
            ),
          ),

          const SizedBox(height: 18),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              model.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                height: 1.7,
                color: Colors.black87,
              ),
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}