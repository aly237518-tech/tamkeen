import 'package:flutter/material.dart';

import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

class TamkeenApp extends StatelessWidget {
  const TamkeenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'تمكين',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}