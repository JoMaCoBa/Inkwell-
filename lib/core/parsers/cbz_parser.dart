import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import '../error/exceptions.dart';

class CbzParser {
  static const _imageExtensions = {'jpg', 'jpeg', 'png', 'webp', 'gif', 'bmp'};

  // Single open archive cache — holds one CBZ in memory during reading.
  // Cleared by calling [closeArchive] when the reading session ends.
  String? _cachedPath;
  Archive? _cachedArchive;

  Future<List<String>> getImageList(String filePath) async {
    final archive = await _archive(filePath);
    final images = archive.files
        .where((f) => f.isFile && _isImage(f.name))
        .map((f) => f.name)
        .toList();
    if (images.isEmpty) throw const ComicParseException('No images found in archive');
    images.sort(_naturalSort);
    return images;
  }

  Future<Uint8List> getPageBytes(String filePath, String imageName) async {
    final archive = await _archive(filePath);
    final file = archive.files.firstWhere(
      (f) => f.name == imageName,
      orElse: () => throw ComicParseException('Page not found: $imageName'),
    );
    return file.content as Uint8List;
  }

  Future<Uint8List> getCoverBytes(String filePath) async {
    final images = await getImageList(filePath);
    return getPageBytes(filePath, images.first);
  }

  void closeArchive() {
    _cachedPath = null;
    _cachedArchive = null;
  }

  Future<Archive> _archive(String filePath) async {
    if (_cachedPath == filePath && _cachedArchive != null) {
      return _cachedArchive!;
    }
    final file = File(filePath);
    if (!await file.exists()) throw FileNotFoundException('File not found: $filePath');
    try {
      final bytes = await file.readAsBytes();
      _cachedArchive = ZipDecoder().decodeBytes(bytes);
      _cachedPath = filePath;
      return _cachedArchive!;
    } catch (e) {
      throw ComicParseException('Failed to parse archive: $e');
    }
  }

  bool _isImage(String name) {
    final parts = name.toLowerCase().split('.');
    return parts.length > 1 && _imageExtensions.contains(parts.last);
  }

  int _naturalSort(String a, String b) {
    final regExp = RegExp(r'(\d+|\D+)');
    final aSegments = regExp.allMatches(a).map((m) => m.group(0)!).toList();
    final bSegments = regExp.allMatches(b).map((m) => m.group(0)!).toList();
    for (var i = 0; i < aSegments.length && i < bSegments.length; i++) {
      final aInt = int.tryParse(aSegments[i]);
      final bInt = int.tryParse(bSegments[i]);
      final cmp = (aInt != null && bInt != null)
          ? aInt.compareTo(bInt)
          : aSegments[i].compareTo(bSegments[i]);
      if (cmp != 0) return cmp;
    }
    return aSegments.length.compareTo(bSegments.length);
  }
}
