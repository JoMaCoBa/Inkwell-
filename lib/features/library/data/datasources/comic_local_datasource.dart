import 'package:sqflite/sqflite.dart' hide DatabaseException;
import '../../../../core/error/exceptions.dart';
import '../../../reader/data/models/reading_progress_model.dart';
import '../models/comic_model.dart';

abstract class ComicLocalDataSource {
  Future<List<ComicModel>> getAll();
  Future<ComicModel?> getById(String id);
  Future<void> insert(ComicModel comic);
  Future<void> delete(String id);
}

class ComicLocalDataSourceImpl implements ComicLocalDataSource {
  final Database database;
  ComicLocalDataSourceImpl({required this.database});

  @override
  Future<List<ComicModel>> getAll() async {
    try {
      final maps = await database.query('comics', orderBy: 'date_added DESC');
      final progressMaps = await database.query('reading_progress');
      final progressByComicId = {
        for (final p in progressMaps)
          p['comic_id'] as String: ReadingProgressModel.fromMap(p),
      };
      return maps
          .map((m) => ComicModel.fromMap(m,
              progress: progressByComicId[m['id'] as String]))
          .toList();
    } catch (e) {
      throw DatabaseException('Failed to load comics: $e');
    }
  }

  @override
  Future<ComicModel?> getById(String id) async {
    try {
      final maps =
          await database.query('comics', where: 'id = ?', whereArgs: [id]);
      if (maps.isEmpty) return null;
      final progressMaps = await database.query(
        'reading_progress',
        where: 'comic_id = ?',
        whereArgs: [id],
      );
      final progress =
          progressMaps.isNotEmpty ? ReadingProgressModel.fromMap(progressMaps.first) : null;
      return ComicModel.fromMap(maps.first, progress: progress);
    } catch (e) {
      throw DatabaseException('Failed to load comic: $e');
    }
  }

  @override
  Future<void> insert(ComicModel comic) async {
    try {
      await database.insert(
        'comics',
        comic.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw DatabaseException('Failed to insert comic: $e');
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await database.delete('comics', where: 'id = ?', whereArgs: [id]);
      await database.delete('reading_progress',
          where: 'comic_id = ?', whereArgs: [id]);
    } catch (e) {
      throw DatabaseException('Failed to delete comic: $e');
    }
  }
}
