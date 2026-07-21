import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService authService = AuthService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("يرجى إدخال البريد الإلكتروني وكلمة المرور"),
        ),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      await authService.signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final role = await authService.getUserRole();
      debugPrint("================================");
      debugPrint("ROLE = $role");
      debugPrint("================================");


      if (!mounted) return;

      if (role == 'employer') {
        context.go('/employer-home');
      } else {
        context.go('/home');
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst("Exception: ", ""),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F5FC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 450,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  Center(
                    child: Image.asset(
                      "assets/logos/tamkeen_logo.png",
                      width: 120,
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    "مرحباً بكِ",
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff222222),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "سجلي الدخول للمتابعة",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 35),

                  AppTextField(
                    controller: emailController,
                    hint: "البريد الإلكتروني",
                    label: "البريد الإلكتروني",
                    prefixIcon: Icons.email_outlined,
                  ),

                  const SizedBox(height: 20),

                  AppTextField(
                    controller: passwordController,
                    hint: "كلمة المرور",
                    label: "كلمة المرور",
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                  ),

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "نسيت كلمة المرور؟",
                        style: TextStyle(
                          color: Color(0xff6A1B9A),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  AppButton(
                    text: isLoading
                        ? "جاري تسجيل الدخول..."
                        : "تسجيل الدخول",
                    onPressed: isLoading ? null : login,
                  ),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "ليس لديك حساب؟",
                        style: TextStyle(fontSize: 15),
                      ),
                      TextButton(
                        onPressed: () {
                          context.go('/register');
                        },
                        child: const Text(
                          "إنشاء حساب",
                          style: TextStyle(
                            color: Color(0xff6A1B9A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}