import 'package:equatable/equatable.dart';

enum ComicFormat { cbz, cbr, pdf }

class ReadingProgress extends Equatable {
  final String comicId;
  final int currentPage;
  final DateTime lastRead;

  const ReadingProgress({
    required this.comicId,
    required this.currentPage,
    required this.lastRead,
  });

  double percentage(int totalPages) =>
      totalPages > 0 ? currentPage / totalPages : 0.0;

  @override
  List<Object?> get props => [comicId, currentPage, lastRead];
}

class Comic extends Equatable {
  final String id;
  final String title;
  final String filePath;
  final String coverImagePath;
  final ComicFormat format;
  final int totalPages;
  final DateTime dateAdded;
  final ReadingProgress? progress;

  const Comic({
    required this.id,
    required this.title,
    required this.filePath,
    required this.coverImagePath,
    required this.format,
    required this.totalPages,
    required this.dateAdded,
    this.progress,
  });

  bool get isNew => progress == null;

  bool get isInProgress =>
      progress != null &&
      progress!.currentPage > 0 &&
      progress!.currentPage < totalPages - 1;

  bool get isFinished =>
      progress != null && progress!.currentPage >= totalPages - 1;

  Comic copyWith({ReadingProgress? progress}) {
    return Comic(
      id: id,
      title: title,
      filePath: filePath,
      coverImagePath: coverImagePath,
      format: format,
      totalPages: totalPages,
      dateAdded: dateAdded,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object?> get props =>
      [id, title, filePath, coverImagePath, format, totalPages, dateAdded, progress];
}
