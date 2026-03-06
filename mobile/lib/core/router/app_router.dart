// MIT License - Copyright (c) 2026 InfraGuard AI Contributors
// InfraGuard AI - App Router Configuration

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/electricity/screens/electricity_dashboard_screen.dart';
import '../../features/electricity/screens/outage_prediction_screen.dart';
import '../../features/electricity/screens/technician_workflow_screen.dart';
import '../../features/roads/screens/roads_dashboard_screen.dart';
import '../../features/roads/screens/road_report_screen.dart';
import '../../features/roads/screens/repair_priority_screen.dart';
import '../../features/dashboard/screens/analytics_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/work_orders/screens/work_orders_screen.dart';
import '../../shared/widgets/app_shell.dart';

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    routes: [
      // Auth routes (no shell)
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Main app routes (with bottom nav shell)
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const HomeScreen(),
              transitionsBuilder: _fadeTransition,
            ),
          ),
          GoRoute(
            path: '/electricity',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const ElectricityDashboardScreen(),
              transitionsBuilder: _fadeTransition,
            ),
            routes: [
              GoRoute(
                path: 'prediction',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const OutagePredictionScreen(),
              ),
              GoRoute(
                path: 'technician',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const TechnicianWorkflowScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/roads',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const RoadsDashboardScreen(),
              transitionsBuilder: _fadeTransition,
            ),
            routes: [
              GoRoute(
                path: 'report',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const RoadReportScreen(),
              ),
              GoRoute(
                path: 'priorities',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const RepairPriorityScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/analytics',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const AnalyticsScreen(),
              transitionsBuilder: _fadeTransition,
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const SettingsScreen(),
              transitionsBuilder: _fadeTransition,
            ),
          ),
        ],
      ),

      // Work orders (full screen)
      GoRoute(
        path: '/work-orders',
        builder: (context, state) => const WorkOrdersScreen(),
      ),
    ],
  );

  static Widget _fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }
}
