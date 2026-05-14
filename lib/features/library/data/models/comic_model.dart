import '../../domain/entities/comic.dart';

class ComicModel extends Comic {
  const ComicModel({
    required super.id,
    required super.title,
    required super.filePath,
    required super.coverImagePath,
    required super.format,
    required super.totalPages,
    required super.dateAdded,
    super.progress,
  });

  factory ComicModel.fromMap(Map<String, dynamic> map,
      {ReadingProgress? progress}) {
    return ComicModel(
      id: map['id'] as String,
      title: map['title'] as String,
      filePath: map['file_path'] as String,
      coverImagePath: map['cover_image_path'] as String,
      format: ComicFormat.values.byName(map['format'] as String),
      totalPages: map['total_pages'] as int,
      dateAdded: DateTime.parse(map['date_added'] as String),
      progress: progress,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'file_path': filePath,
        'cover_image_path': coverImagePath,
        'format': format.name,
        'total_pages': totalPages,
        'date_added': dateAdded.toIso8601String(),
      };
}
