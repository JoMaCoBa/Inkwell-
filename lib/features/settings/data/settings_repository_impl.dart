import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../../core/error/failures.dart';
import '../domain/entities/app_settings.dart';
import '../domain/usecases/save_settings.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  Future<File> get _file async {
    final dir = await getApplicationDocumentsDirectory();
    return File(p.join(dir.path, 'settings.json'));
  }

  @override
  Future<Either<Failure, AppSettings>> getSettings() async {
    try {
      final file = await _file;
      if (!await file.exists()) return const Right(AppSettings());
      final json = jsonDecode(await file.readAsString()) as Map;
      return Right(AppSettings.fromMap(Map<String, dynamic>.from(json)));
    } catch (_) {
      return const Right(AppSettings());
    }
  }

  @override
  Future<Either<Failure, Unit>> saveSettings(AppSettings settings) async {
    try {
      final file = await _file;
      await file.writeAsString(jsonEncode(settings.toMap()));
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
