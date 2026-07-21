import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // تأكد من إضافة هذا الاستيراد

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      final session = Supabase.instance.client.auth.currentSession;

      // 1. إذا كان المستخدم لم يسجل دخولاً سابقاً، نرسله للـ Onboarding
      if (session == null) {
        context.go('/onboarding');
      } else {
        // 2. إذا كان مسجلاً، نتركه لـ Router ليقوم بتوجيهه حسب الـ redirect
        // (الذي سيتحقق من الدور ويوديه للـ Home أو EmployerHome)
        context.go('/home'); 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F5FC),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/logos/tamkeen_logo.png",
                  width: 180,
                ),
                const SizedBox(height: 30),
                const Text(
                  "تمكين",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff6A1B9A),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "منصة المرأة العراقية\nللتمكين الاقتصادي",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  "أنتِ قادرة،\nونحن معكِ خطوة بخطوة",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xff9C27B0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}