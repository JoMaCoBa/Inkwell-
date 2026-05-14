import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app/router.dart';
import 'app/theme/app_theme.dart';
import 'features/library/presentation/providers/library_provider.dart';
import 'features/reader/presentation/providers/reader_provider.dart';
import 'features/settings/presentation/providers/settings_provider.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await di.init();
  runApp(const InkwellApp());
}

class InkwellApp extends StatelessWidget {
  const InkwellApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<LibraryProvider>()),
        ChangeNotifierProvider(create: (_) => sl<ReaderProvider>()),
        ChangeNotifierProvider(create: (_) => sl<SettingsProvider>()..load()),
      ],
      child: MaterialApp(
        title: 'Inkwell',
        theme: InkwellTheme.theme,
        debugShowCheckedModeBanner: false,
        initialRoute: AppRouter.splash,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
