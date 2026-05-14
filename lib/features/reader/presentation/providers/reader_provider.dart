import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../../core/parsers/cbz_parser.dart';
import '../../../library/domain/entities/comic.dart';
import '../../domain/entities/reading_session.dart';
import '../../domain/repositories/reader_repository.dart';
import '../../domain/usecases/get_comic_pages.dart';
import '../../domain/usecases/save_progress.dart';

class ReaderProvider extends ChangeNotifier {
  final GetComicPages getComicPages;
  final SaveProgress saveProgress;
  final ReaderRepository readerRepository;
  final CbzParser cbzParser;

  ReaderProvider({
    required this.getComicPages,
    required this.saveProgress,
    required this.readerRepository,
    required this.cbzParser,
  });

  Comic? comic;
  ReadingSession? session;
  bool isLoading = false;
  String? error;

  int get currentPage => session?.currentIndex ?? 0;
  int get totalPages => session?.totalPages ?? 0;
  bool get hasSession => session != null;

  Future<void> openComic(Comic c) async {
    comic = c;
    isLoading = true;
    error = null;
    notifyListeners();

    final result = await getComicPages(GetComicPagesParams(c));
    result.fold(
      (failure) => error = failure.message,
      (s) => session = s,
    );

    isLoading = false;
    notifyListeners();
  }

  Future<Uint8List?> loadPageBytes(String pageName) async {
    if (comic == null) return null;
    final result = await readerRepository.getPageBytes(comic!, pageName);
    return result.fold((_) => null, (bytes) => Uint8List.fromList(bytes));
  }

  Future<void> goToPage(int index) async {
    if (session == null) return;
    session = session!.goToPage(index);
    notifyListeners();
    await saveProgress(SaveProgressParams(
      comicId: comic!.id,
      currentPage: index,
    ));
  }

  void close() {
    cbzParser.closeArchive();
    comic = null;
    session = null;
    error = null;
    notifyListeners();
  }
}
