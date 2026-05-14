import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import '../error/exceptions.dart';

class CbzParser {
  static const _imageExtensions = {'jpg', 'jpeg', 'png', 'webp', 'gif', 'bmp'};

  Future<List<String>> getImageList(String filePath) async {
    final archive = await _openArchive(filePath);
    final images = archive.files
        .where((f) => f.isFile && _isImage(f.name))
        .map((f) => f.name)
        .toList();
    if (images.isEmpty) {
      throw const ComicParseException('No images found in archive');
    }
    images.sort(_naturalSort);
    return images;
  }

  Future<Uint8List> getPageBytes(String filePath, String imageName) async {
    final archive = await _openArchive(filePath);
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

  Future<Archive> _openArchive(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw FileNotFoundException('File not found: $filePath');
    }
    try {
      final bytes = await file.readAsBytes();
      return ZipDecoder().decodeBytes(bytes);
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
      int cmp;
      if (aInt != null && bInt != null) {
        cmp = aInt.compareTo(bInt);
      } else {
        cmp = aSegments[i].compareTo(bSegments[i]);
      }
      if (cmp != 0) return cmp;
    }
    return aSegments.length.compareTo(bSegments.length);
  }
}
