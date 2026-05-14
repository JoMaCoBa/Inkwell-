import 'package:sqflite/sqflite.dart' hide DatabaseException;
import '../../../../core/error/exceptions.dart';
import '../models/reading_progress_model.dart';

abstract class ReaderLocalDataSource {
  Future<ReadingProgressModel?> getProgress(String comicId);
  Future<void> saveProgress(String comicId, int currentPage);
}

class ReaderLocalDataSourceImpl implements ReaderLocalDataSource {
  final Database database;
  ReaderLocalDataSourceImpl({required this.database});

  @override
  Future<ReadingProgressModel?> getProgress(String comicId) async {
    try {
      final maps = await database.query(
        'reading_progress',
        where: 'comic_id = ?',
        whereArgs: [comicId],
      );
      if (maps.isEmpty) return null;
      return ReadingProgressModel.fromMap(maps.first);
    } catch (e) {
      throw DatabaseException('Failed to get progress: $e');
    }
  }

  @override
  Future<void> saveProgress(String comicId, int currentPage) async {
    try {
      await database.insert(
        'reading_progress',
        {
          'comic_id': comicId,
          'current_page': currentPage,
          'last_read': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw DatabaseException('Failed to save progress: $e');
    }
  }
}
