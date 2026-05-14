import 'package:flutter/material.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/comic.dart';
import '../../domain/usecases/delete_comic.dart';
import '../../domain/usecases/get_all_comics.dart';
import '../../domain/usecases/import_comic.dart';

class LibraryProvider extends ChangeNotifier {
  final GetAllComics getAllComics;
  final ImportComic importComic;
  final DeleteComic deleteComic;

  List<Comic> comics = [];
  bool isLoading = false;
  bool isImporting = false;
  String? error;

  LibraryProvider({
    required this.getAllComics,
    required this.importComic,
    required this.deleteComic,
  });

  List<Comic> get inProgress =>
      comics.where((c) => c.isInProgress).toList();

  Future<void> loadComics() async {
    isLoading = true;
    error = null;
    notifyListeners();

    final result = await getAllComics(NoParams());
    result.fold(
      (failure) => error = failure.message,
      (data) => comics = data,
    );

    isLoading = false;
    notifyListeners();
  }

  Future<void> import(String filePath) async {
    isImporting = true;
    error = null;
    notifyListeners();

    final result = await importComic(ImportComicParams(filePath));
    result.fold(
      (failure) => error = failure.message,
      (comic) => comics = [comic, ...comics],
    );

    isImporting = false;
    notifyListeners();
  }

  Future<void> delete(String id) async {
    final result = await deleteComic(DeleteComicParams(id));
    result.fold(
      (failure) => error = failure.message,
      (_) => comics = comics.where((c) => c.id != id).toList(),
    );
    notifyListeners();
  }

  void updateProgress(String comicId, int currentPage) {
    comics = comics.map((c) {
      if (c.id != comicId) return c;
      return c.copyWith(
        progress: ReadingProgress(
          comicId: comicId,
          currentPage: currentPage,
          lastRead: DateTime.now(),
        ),
      );
    }).toList();
    notifyListeners();
  }
}
