import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/profile_provider.dart';
import '../providers/resume_provider.dart';


class WomanProfilePage extends ConsumerWidget {
  const WomanProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final resumeAsync = ref.watch(resumeUrlProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF9F5FC),
      appBar: AppBar(
        title: const Text("حسابي"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: profileAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, _) => Center(
          child: Text(e.toString()),
        ),
        data: (profile) {
          if (profile == null) {
            return const Center(
              child: Text("لا توجد بيانات"),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 45,
                  backgroundColor: Color(0xff6A1B9A),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 45,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  profile.fullName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                _item(Icons.email_outlined, "البريد الإلكتروني", profile.email),
                _item(Icons.phone_outlined, "رقم الهاتف", profile.phone ?? "-"),
                _item(Icons.location_on_outlined, "المحافظة", profile.city ?? "-"),

                const SizedBox(height: 20),

                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.work_history,
                      color: Color(0xff6A1B9A),
                    ),
                    title: const Text("طلباتي"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      context.push('/my-applications');
                    },
                  ),
                ),

                const SizedBox(height: 20),

                resumeAsync.when(
                  data: (url) {
                    return Column(
                      children: [
                        if (url != null && url.isNotEmpty)
                          Card(
                            child: ListTile(
                              leading: const Icon(
                                Icons.picture_as_pdf,
                                color: Colors.red,
                              ),
                              title: const Text("السيرة الذاتية"),
                              subtitle: const Text("تم رفع السيرة الذاتية"),
                              trailing: const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                            ),
                          ),

                        const SizedBox(height: 15),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff6A1B9A),
                            ),
                            icon: const Icon(
                              Icons.upload_file,
                              color: Colors.white,
                            ),
                            label: Text(
                              url == null || url.isEmpty
                                  ? "رفع السيرة الذاتية"
                                  : "تحديث السيرة الذاتية",
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              await ref
                                  .read(resumeServiceProvider)
                                  .uploadResume();

                              ref.invalidate(resumeUrlProvider);

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "تم رفع السيرة الذاتية بنجاح",
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => const SizedBox(),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
onPressed: () async {
  try {
    debugPrint("جاري تسجيل الخروج..."); // 1. رسالة تتبع
    
    await ref.read(profileServiceProvider).signOut();
    
    debugPrint("تم استدعاء دالة الخروج بنجاح."); // 2. رسالة تتبع
    
    ref.invalidate(profileProvider);
    ref.invalidate(resumeUrlProvider);
    
    debugPrint("تم مسح البيانات."); // 3. رسالة تتبع
  } catch (e) {
    debugPrint("حدث خطأ أثناء تسجيل الخروج: $e"); // 4. كشف أي خطأ
  }
},
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "تسجيل الخروج",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static Widget _item(
    IconData icon,
    String title,
    String value,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xff6A1B9A),
        ),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}