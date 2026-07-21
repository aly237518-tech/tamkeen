import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// الصفحات
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/main/presentation/pages/main_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/jobs/presentation/pages/job_details_page.dart';
import '../../features/applications/presentation/pages/my_applications_page.dart';
import '../../features/employer/presentation/pages/add_job_page.dart';
import '../../features/employer/presentation/pages/my_jobs_page.dart';
import '../../features/employer/presentation/pages/employer_main_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/jobs/presentation/pages/jobs_page.dart'; // (تأكد من مطابقة مسار الملف حسب هيكل مشروعك)


class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<AuthState> stream) {
    notifyListeners();
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  refreshListenable: GoRouterRefreshStream(
    Supabase.instance.client.auth.onAuthStateChange,
  ),

  redirect: (context, state) {
    final session = Supabase.instance.client.auth.currentSession;

    final isLoggedIn = session != null;

    final isSplash = state.matchedLocation == '/';
    final isLogin = state.matchedLocation == '/login';
    final isRegister = state.matchedLocation == '/register';

    // المستخدم غير مسجل
    if (!isLoggedIn) {
      if (isSplash || isLogin || isRegister) {
        return null;
      }
      return '/login';
    }

    // المستخدم مسجل
    // لا توجه مباشرة إلى /home
    // دع LoginPage هي التي تحدد الصفحة حسب role
    if (isSplash) {
      return '/login';
    }

    if (isLogin || isRegister) {
      return null;
    }

    return null;
  },

  routes: [
    GoRoute(
  path: '/notifications',
  builder: (context, state) => const NotificationsPage(),
),
    GoRoute(
  path: '/jobs',
  builder: (context, state) => const JobsPage(),
),
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),

    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(),
    ),

    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterPage(),
    ),

    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),

    GoRoute(
      path: '/home',
      builder: (context, state) => const MainPage(),
    ),

    GoRoute(
      path: '/employer-home',
      builder: (context, state) => const EmployerMainPage(),
    ),

    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),

    GoRoute(
      path: '/my-applications',
      builder: (context, state) => const MyApplicationsPage(),
    ),

    GoRoute(
      path: '/my-jobs',
      builder: (context, state) => const MyJobsPage(),
    ),

    GoRoute(
      path: '/add-job',
      builder: (context, state) => const AddJobPage(),
    ),

    GoRoute(
      path: '/job/:id',
      builder: (context, state) =>
          JobDetailsPage(jobId: state.pathParameters['id']!),
    ),
  ],
);
