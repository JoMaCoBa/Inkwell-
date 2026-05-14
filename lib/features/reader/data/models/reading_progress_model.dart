import '../../../library/domain/entities/comic.dart';

class ReadingProgressModel extends ReadingProgress {
  const ReadingProgressModel({
    required super.comicId,
    required super.currentPage,
    required super.lastRead,
  });

  factory ReadingProgressModel.fromMap(Map<String, dynamic> map) {
    return ReadingProgressModel(
      comicId: map['comic_id'] as String,
      currentPage: map['current_page'] as int,
      lastRead: DateTime.parse(map['last_read'] as String),
    );
  }

  Map<String, dynamic> toMap() => {
        'comic_id': comicId,
        'current_page': currentPage,
        'last_read': lastRead.toIso8601String(),
      };
}
