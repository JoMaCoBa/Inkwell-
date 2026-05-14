import 'package:flutter/material.dart';
import '../features/comic_detail/presentation/screens/detail_screen.dart';
import '../features/library/domain/entities/comic.dart';
import '../features/library/presentation/screens/library_screen.dart';
import '../features/reader/presentation/screens/reader_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/splash/presentation/splash_screen.dart';

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
        return _cut(const LibraryScreen());
      case detail:
        final comic = settings.arguments as Comic;
        return _cut(DetailScreen(comic: comic));
      case reader:
        final comic = settings.arguments as Comic;
        return _cut(ReaderScreen(comic: comic));
      case AppRouter.settings:
        return _cut(const SettingsScreen());
      default:
        return _cut(const LibraryScreen());
    }
  }

  static PageRouteBuilder<T> _cut<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }
}
