import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'core/parsers/cbz_parser.dart';
import 'core/utils/image_cache_manager.dart';

import 'features/library/data/datasources/comic_file_datasource.dart';
import 'features/library/data/datasources/comic_local_datasource.dart';
import 'features/library/data/repositories/comic_repository_impl.dart';
import 'features/library/domain/repositories/comic_repository.dart';
import 'features/library/domain/usecases/delete_comic.dart';
import 'features/library/domain/usecases/get_all_comics.dart';
import 'features/library/domain/usecases/import_comic.dart';
import 'features/library/presentation/providers/library_provider.dart';

import 'features/reader/data/datasources/reader_local_datasource.dart';
import 'features/reader/data/repositories/reader_repository_impl.dart';
import 'features/reader/domain/repositories/reader_repository.dart';
import 'features/reader/domain/usecases/get_comic_pages.dart';
import 'features/reader/domain/usecases/save_progress.dart';
import 'features/reader/presentation/providers/reader_provider.dart';

import 'features/settings/data/settings_repository_impl.dart';
import 'features/settings/domain/usecases/save_settings.dart';
import 'features/settings/presentation/providers/settings_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ── External ──────────────────────────────────────────────────────────────
  final appDir = await getApplicationDocumentsDirectory();
  final dbPath = p.join(appDir.path, 'inkwell.db');
  final db = await openDatabase(
    dbPath,
    version: 1,
    onCreate: (db, _) async {
      await db.execute('''
        CREATE TABLE comics (
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          file_path TEXT NOT NULL,
          cover_image_path TEXT NOT NULL,
          format TEXT NOT NULL,
          total_pages INTEGER NOT NULL,
          date_added TEXT NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE reading_progress (
          comic_id TEXT PRIMARY KEY,
          current_page INTEGER NOT NULL,
          last_read TEXT NOT NULL
        )
      ''');
    },
  );
  sl.registerLazySingleton<Database>(() => db);

  // ── Core ──────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<CbzParser>(() => CbzParser());
  sl.registerLazySingleton<ImageCacheManager>(() => ImageCacheManager());

  // ── Library ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton<ComicLocalDataSource>(
      () => ComicLocalDataSourceImpl(database: sl()));
  sl.registerLazySingleton<ComicFileDataSource>(
      () => ComicFileDataSource(cbzParser: sl(), cacheManager: sl()));
  sl.registerLazySingleton<ComicRepository>(
      () => ComicRepositoryImpl(localDataSource: sl(), fileDataSource: sl()));
  sl.registerLazySingleton(() => GetAllComics(sl()));
  sl.registerLazySingleton(() => ImportComic(sl()));
  sl.registerLazySingleton(() => DeleteComic(sl()));
  sl.registerFactory(() => LibraryProvider(
        getAllComics: sl(),
        importComic: sl(),
        deleteComic: sl(),
      ));

  // ── Reader ────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<ReaderLocalDataSource>(
      () => ReaderLocalDataSourceImpl(database: sl()));
  sl.registerLazySingleton<ReaderRepository>(
      () => ReaderRepositoryImpl(localDataSource: sl(), cbzParser: sl()));
  sl.registerLazySingleton(() => GetComicPages(sl()));
  sl.registerLazySingleton(() => SaveProgress(sl()));
  sl.registerFactory(() => ReaderProvider(
        getComicPages: sl(),
        saveProgress: sl(),
        readerRepository: sl(),
      ));

  // ── Settings ──────────────────────────────────────────────────────────────
  sl.registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl());
  sl.registerLazySingleton(() => GetSettings(sl()));
  sl.registerLazySingleton(() => SaveSettings(sl()));
  sl.registerFactory(() => SettingsProvider(
        getSettings: sl(),
        saveSettings: sl(),
      ));
}
