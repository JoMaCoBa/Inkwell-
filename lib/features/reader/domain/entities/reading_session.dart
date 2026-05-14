import 'package:equatable/equatable.dart';

class ReadingSession extends Equatable {
  final String comicId;
  final List<String> pages; // image names or paths
  final int currentIndex;

  const ReadingSession({
    required this.comicId,
    required this.pages,
    this.currentIndex = 0,
  });

  int get totalPages => pages.length;
  String? get currentPage => pages.isNotEmpty ? pages[currentIndex] : null;

  ReadingSession goToPage(int index) => ReadingSession(
        comicId: comicId,
        pages: pages,
        currentIndex: index.clamp(0, pages.length - 1),
      );

  @override
  List<Object?> get props => [comicId, pages, currentIndex];
}
