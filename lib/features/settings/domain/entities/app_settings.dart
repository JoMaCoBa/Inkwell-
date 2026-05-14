import 'package:equatable/equatable.dart';

enum ReadingDirection { ltr, rtl }
enum AppTheme { normal, sepia }

class AppSettings extends Equatable {
  final ReadingDirection readingDirection;
  final AppTheme theme;
  final String? customStoragePath;

  const AppSettings({
    this.readingDirection = ReadingDirection.ltr,
    this.theme = AppTheme.normal,
    this.customStoragePath,
  });

  AppSettings copyWith({
    ReadingDirection? readingDirection,
    AppTheme? theme,
    String? customStoragePath,
  }) {
    return AppSettings(
      readingDirection: readingDirection ?? this.readingDirection,
      theme: theme ?? this.theme,
      customStoragePath: customStoragePath ?? this.customStoragePath,
    );
  }

  Map<String, dynamic> toMap() => {
        'reading_direction': readingDirection.name,
        'theme': theme.name,
        'custom_storage_path': customStoragePath,
      };

  factory AppSettings.fromMap(Map<String, dynamic> map) => AppSettings(
        readingDirection: ReadingDirection.values.byName(
          map['reading_direction'] as String? ?? 'ltr',
        ),
        theme: AppTheme.values.byName(
          map['theme'] as String? ?? 'normal',
        ),
        customStoragePath: map['custom_storage_path'] as String?,
      );

  @override
  List<Object?> get props => [readingDirection, theme, customStoragePath];
}
