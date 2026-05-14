import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImageCacheManager {
  static final ImageCacheManager _instance = ImageCacheManager._();
  factory ImageCacheManager() => _instance;
  ImageCacheManager._();

  Future<bool> hasCover(String comicId) async {
    final path = await _coverPath(comicId);
    return File(path).exists();
  }

  Future<String> coverPath(String comicId) => _coverPath(comicId);

  Future<void> saveCover(String comicId, List<int> bytes) async {
    final path = await _coverPath(comicId);
    await File(path).writeAsBytes(bytes);
  }

  Future<void> clearCovers() async {
    final dir = await _coversDir();
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  Future<String> _coverPath(String comicId) async {
    final dir = await _coversDir();
    return p.join(dir.path, '$comicId.jpg');
  }

  Future<Directory> _coversDir() async {
    final appDir = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(appDir.path, 'covers'));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }
}
