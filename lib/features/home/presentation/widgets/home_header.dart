import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 28,
          backgroundColor: Color(0xff6A1B9A),
          child: Icon(
            Icons.person,
            color: Colors.white,
            size: 30,
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "مرحباً بكِ 🌸",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "منصة تمكين",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        IconButton(
          onPressed: () {
            context.push('/notifications');
          },
          icon: const Icon(Icons.notifications_none),
        ),
      ],
    );
  }
}