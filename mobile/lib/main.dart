// MIT License - Copyright (c) 2026 InfraGuard AI Contributors
// InfraGuard AI - Main Entry Point

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/constants/env.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait for mobile
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  // TODO: Initialize Supabase
  // await Supabase.initialize(
  //   url: Env.supabaseUrl,
  //   anonKey: Env.supabaseAnonKey,
  // );

  // TODO: Initialize Firebase
  // await Firebase.initializeApp();

  runApp(
    const ProviderScope(
      child: InfraGuardApp(),
    ),
  );
}

class InfraGuardApp extends ConsumerStatefulWidget {
  const InfraGuardApp({super.key});

  @override
  ConsumerState<InfraGuardApp> createState() => _InfraGuardAppState();
}

class _InfraGuardAppState extends ConsumerState<InfraGuardApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: Env.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      routerConfig: AppRouter.router,
    );
  }
}
