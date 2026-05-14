import 'package:flutter/material.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/save_settings.dart';

class SettingsProvider extends ChangeNotifier {
  final GetSettings getSettings;
  final SaveSettings saveSettings;

  SettingsProvider({required this.getSettings, required this.saveSettings});

  AppSettings settings = const AppSettings();

  Future<void> load() async {
    final result = await getSettings(NoParams());
    result.fold((_) {}, (s) => settings = s);
    notifyListeners();
  }

  Future<void> update(AppSettings updated) async {
    settings = updated;
    notifyListeners();
    await saveSettings(SaveSettingsParams(updated));
  }
}
