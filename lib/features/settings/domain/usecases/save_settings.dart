import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_settings.dart';

abstract class SettingsRepository {
  Future<Either<Failure, AppSettings>> getSettings();
  Future<Either<Failure, Unit>> saveSettings(AppSettings settings);
}

class SaveSettings extends UseCase<Unit, SaveSettingsParams> {
  final SettingsRepository repository;
  SaveSettings(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SaveSettingsParams params) =>
      repository.saveSettings(params.settings);
}

class SaveSettingsParams extends Equatable {
  final AppSettings settings;
  const SaveSettingsParams(this.settings);

  @override
  List<Object?> get props => [settings];
}

class GetSettings extends UseCase<AppSettings, NoParams> {
  final SettingsRepository repository;
  GetSettings(this.repository);

  @override
  Future<Either<Failure, AppSettings>> call(NoParams params) =>
      repository.getSettings();
}
