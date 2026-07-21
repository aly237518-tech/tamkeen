import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/profile_provider.dart';
import 'woman_profile_page.dart';
import 'employer_profile_page.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return profileAsync.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (e, _) => Scaffold(
        body: Center(
          child: Text(e.toString()),
        ),
      ),
      data: (profile) {
        if (profile == null) {
          return const Scaffold(
            body: Center(
              child: Text("لا توجد بيانات"),
            ),
          );
        }

        final role = (profile.role ?? "").toLowerCase();

        if (role == "employer") {
          return const EmployerProfilePage();
        }

        return const WomanProfilePage();
      },
    );
  }
}