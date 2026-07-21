import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint("========== FLUTTER ERROR ==========");
    debugPrint(details.exceptionAsString());
    if (details.stack != null) {
      debugPrintStack(stackTrace: details.stack);
    }
  };

  runZonedGuarded(() async {
    const supabaseUrl = 'https://fqgftqenzaohpsvroclx.supabase.co';
    const supabaseKey = 'sb_publishable_2Q9gQwQHqsUvtUeD1xj1Vw_Ei4VBJXa';

    try {
      await Supabase.initialize(
        url: supabaseUrl,
        publishableKey: supabaseKey,
      );
      
      // أضف هذا السطر فقط للتجربة (سيسجل خروجك في كل مرة تشغل فيها التطبيق)
      // هذا سيجبر التطبيق على إظهار صفحة تسجيل الدخول دائماً أثناء التطوير
      await Supabase.instance.client.auth.signOut(); 
      
      debugPrint("Supabase initialized and session cleared for testing");
    } catch (e, s) {
      debugPrint("========== SUPABASE ERROR ==========");
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
    }

    runApp(
      const ProviderScope(
        child: TamkeenApp(),
      ),
    );
  }, (error, stack) {
    debugPrint("========== ZONED ERROR ==========");
    debugPrint(error.toString());
    debugPrintStack(stackTrace: stack);
  });
}