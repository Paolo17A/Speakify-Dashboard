import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speechlab_dashboard/core/di/dependency_injection.dart';
import 'package:speechlab_dashboard/core/session/auth_session_notifier.dart';
import 'package:speechlab_dashboard/core/utils/app_router.dart';
import 'package:speechlab_dashboard/core/utils/color_util.dart';
import 'package:speechlab_dashboard/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  await configureDependencies();
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
