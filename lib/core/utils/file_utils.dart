import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../features/library/domain/entities/comic.dart';

class FileUtils {
  static Future<String> getCoversDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final coversDir = Directory(p.join(appDir.path, 'covers'));
    if (!await coversDir.exists()) {
      await coversDir.create(recursive: true);
    }
    return coversDir.path;
  }

  static Future<String> getComicsDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final comicsDir = Directory(p.join(appDir.path, 'comics'));
    if (!await comicsDir.exists()) {
      await comicsDir.create(recursive: true);
    }
    return comicsDir.path;
  }

  static Future<String> copyToComicsDir(String sourcePath) async {
    final comicsDir = await getComicsDirectory();
    final fileName = p.basename(sourcePath);
    final destPath = p.join(comicsDir, fileName);
    await File(sourcePath).copy(destPath);
    return destPath;
  }

  static Future<String> saveCover(String comicId, List<int> bytes) async {
    final coversDir = await getCoversDirectory();
    final coverPath = p.join(coversDir, '$comicId.jpg');
    await File(coverPath).writeAsBytes(bytes);
    return coverPath;
  }

  static ComicFormat formatFromExtension(String filePath) {
    final ext = p.extension(filePath).toLowerCase();
    switch (ext) {
      case '.cbz':
        return ComicFormat.cbz;
      case '.cbr':
        return ComicFormat.cbr;
      case '.pdf':
        return ComicFormat.pdf;
      default:
        return ComicFormat.cbz;
    }
  }

  static String titleFromFilename(String filePath) {
    final name = p.basenameWithoutExtension(filePath);
    return name.replaceAll(RegExp(r'[_\-]+'), ' ').trim();
  }
}
