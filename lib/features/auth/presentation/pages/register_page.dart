import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final authService = AuthService();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;

  // نوع الحساب
  String selectedRole = "woman";

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    cityController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    if (fullNameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("يرجى ملء جميع الحقول المطلوبة"),
        ),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("كلمتا المرور غير متطابقتين"),
        ),
      );
      return;
    }

    try {
      setState(() => isLoading = true);

      await authService.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        fullName: fullNameController.text.trim(),
        phone: phoneController.text.trim(),
        city: cityController.text.trim(),
        role: selectedRole,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم إنشاء الحساب بنجاح"),
        ),
      );

      context.go('/login');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F5FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("إنشاء حساب"),
        centerTitle: true,
      ),
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
                  Center(
                    child: Image.asset(
                      "assets/logos/tamkeen_logo.png",
                      width: 110,
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "إنشاء حساب جديد",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "ابدئي رحلتك مع منصة تمكين",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 35),

                  AppTextField(
                    controller: fullNameController,
                    label: "الاسم الكامل",
                    hint: "أدخلي الاسم الكامل",
                    prefixIcon: Icons.person_outline,
                  ),

                  const SizedBox(height: 18),

                  AppTextField(
                    controller: emailController,
                    label: "البريد الإلكتروني",
                    hint: "example@email.com",
                    prefixIcon: Icons.email_outlined,
                  ),

                  const SizedBox(height: 18),

                  AppTextField(
                    controller: phoneController,
                    label: "رقم الهاتف",
                    hint: "07xxxxxxxxx",
                    prefixIcon: Icons.phone_outlined,
                  ),

                  const SizedBox(height: 18),

                  AppTextField(
                    controller: cityController,
                    label: "المحافظة",
                    hint: "بغداد",
                    prefixIcon: Icons.location_on_outlined,
                  ),

                  const SizedBox(height: 18),

                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    decoration: InputDecoration(
                      labelText: "نوع الحساب",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.badge_outlined),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "woman",
                        child: Text("باحثة عن عمل"),
                      ),
                      DropdownMenuItem(
                        value: "employer",
                        child: Text("صاحب عمل"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedRole = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 18),

                  AppTextField(
                    controller: passwordController,
                    label: "كلمة المرور",
                    hint: "********",
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                  ),

                  const SizedBox(height: 18),

                  AppTextField(
                    controller: confirmPasswordController,
                    label: "تأكيد كلمة المرور",
                    hint: "********",
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                  ),

                  const SizedBox(height: 30),

                  AppButton(
                    text: isLoading
                        ? "جاري إنشاء الحساب..."
                        : "إنشاء حساب",
                    onPressed: isLoading ? null : register,
                  ),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("لديك حساب بالفعل؟"),
                      TextButton(
                        onPressed: () {
                          context.pop();
                        },
                        child: const Text(
                          "تسجيل الدخول",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff6A1B9A),
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