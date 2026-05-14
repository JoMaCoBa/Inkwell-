import 'dart:typed_data';
import '../../../../core/parsers/cbz_parser.dart';
import '../../../../core/utils/file_utils.dart';
import '../../../../core/utils/image_cache_manager.dart';
import '../../../library/domain/entities/comic.dart';
import '../models/comic_model.dart';
import 'package:uuid/uuid.dart';

class ComicFileDataSource {
  final CbzParser cbzParser;
  final ImageCacheManager cacheManager;
  static const _uuid = Uuid();

  ComicFileDataSource({required this.cbzParser, required this.cacheManager});

  Future<ComicModel> importComic(String sourcePath) async {
    final format = FileUtils.formatFromExtension(sourcePath);
    final id = _uuid.v4();
    final destPath = await FileUtils.copyToComicsDir(sourcePath);
    final title = FileUtils.titleFromFilename(sourcePath);

    int totalPages;
    String coverImagePath;

    if (format == ComicFormat.pdf) {
      totalPages = 1; // pdfx will determine actual count at read time
      coverImagePath = '';
    } else {
      final images = await cbzParser.getImageList(destPath);
      totalPages = images.length;
      final coverBytes = await cbzParser.getCoverBytes(destPath);
      coverImagePath = await FileUtils.saveCover(id, coverBytes);
    }

    return ComicModel(
      id: id,
      title: title,
      filePath: destPath,
      coverImagePath: coverImagePath,
      format: format,
      totalPages: totalPages,
      dateAdded: DateTime.now(),
    );
  }

  Future<Uint8List> getPageBytes(String filePath, String pageName) =>
      cbzParser.getPageBytes(filePath, pageName);

  Future<List<String>> getPageList(String filePath) =>
      cbzParser.getImageList(filePath);
}
