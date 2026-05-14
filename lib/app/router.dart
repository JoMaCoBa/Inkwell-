import 'package:flutter/material.dart';
import '../features/comic_detail/presentation/screens/detail_screen.dart';
import '../features/library/domain/entities/comic.dart';
import '../features/reader/presentation/screens/reader_screen.dart';
import '../features/splash/presentation/splash_screen.dart';
import 'main_shell.dart';

class AppRouter {
  static const splash   = '/';
  static const library  = '/library';
  static const detail   = '/detail';
  static const reader   = '/reader';
  static const settings = '/settings';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _cut(const SplashScreen());
      case library:
      case AppRouter.settings: // settings tab lives inside MainShell
        return _cut(const MainShell());
      case detail:
        final comic = settings.arguments as Comic;
        return _hero(DetailScreen(comic: comic));
      case reader:
        final comic = settings.arguments as Comic;
        return _cut(ReaderScreen(comic: comic));
      default:
        return _cut(const MainShell());
    }
  }

  // Instant cut — splash, shell, reader
  static PageRouteBuilder<T> _cut<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }

  // Hero-compatible route for library → detail
  static PageRouteBuilder<T> _hero<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 280),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      transitionsBuilder: (_, animation, __, child) => FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}
