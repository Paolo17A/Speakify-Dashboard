import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speechlab_dashboard/core/di/dependency_injection.dart';
import 'package:speechlab_dashboard/core/session/auth_session_notifier.dart';
import 'package:speechlab_dashboard/core/utils/app_router.dart';
import 'package:speechlab_dashboard/core/utils/color_util.dart';
import 'package:speechlab_dashboard/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Persistence.LOCAL is already the web default; avoid blocking startup if
  // IndexedDB is slow/unavailable (common cause of web freezes in debug).
  try {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  } catch (_) {}
  await configureDependencies();

  // Prefetch Google Fonts before first frame so ThemeData / TextStyles do not
  // stall the UI waiting on a network download mid-build.
  await GoogleFonts.pendingFonts([
    GoogleFonts.alata(),
    GoogleFonts.comicNeue(),
  ]);

  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Keep session notifier alive so authStateChanges + GoRouter redirects work.
    ref.watch(authSessionProvider);
    return MaterialApp.router(
      title: 'SpeechLab Dashboard',
      routerConfig: AppRouter.router,
      theme: appThemeData,
    );
  }
}
