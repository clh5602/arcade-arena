import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'layout.dart';
import 'store.dart';
import 'tasks.dart';
import 'config.dart';
import 'about.dart';
import 'utils.dart';

// Bit of a mess, but the comments should help
final _router = GoRouter(
  initialLocation: pageTitlesEndpoints[0][1],
  routes: <GoRoute>[
    // Arcade Page
    GoRoute(
      // Endpoint specified in utils.dart
      path: pageTitlesEndpoints[0][1], 
      // LayoutPage() from layout.dart
      builder: (context, state) => const LayoutPage(),
      // Fade transition to override the default
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const LayoutPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
    // Store Page
    GoRoute(
      path: pageTitlesEndpoints[1][1],
      builder: (context, state) => const StorePage(),
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const StorePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
    // Tasks Page
    GoRoute(
      path: pageTitlesEndpoints[2][1],
      builder: (context, state) => const TasksPage(),
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const TasksPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
    // Config Page
    GoRoute(
      path: pageTitlesEndpoints[3][1],
      builder: (context, state) => const ConfigPage(),
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const ConfigPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
    // About page
    GoRoute(
      path: pageTitlesEndpoints[4][1],
      builder: (context, state) => const AboutPage(),
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const AboutPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
  ],
);

/// Getter for this router
/// 
/// @author Colby Heaton
/// @returns the router we created

GoRouter getRouter() {
  return _router;
}