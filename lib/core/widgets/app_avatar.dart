import 'package:flutter/material.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.radius = 28,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return CircleAvatar(
        radius: radius,
        child: const Icon(Icons.person),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundImage: NetworkImage(imageUrl!),
    );
  }
}