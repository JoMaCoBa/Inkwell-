import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/parsers/cbz_parser.dart';
import '../../../library/domain/entities/comic.dart';
import '../../domain/entities/reading_session.dart';
import '../../domain/repositories/reader_repository.dart';
import '../datasources/reader_local_datasource.dart';

class ReaderRepositoryImpl implements ReaderRepository {
  final ReaderLocalDataSource localDataSource;
  final CbzParser cbzParser;

  ReaderRepositoryImpl({
    required this.localDataSource,
    required this.cbzParser,
  });

  @override
  Future<Either<Failure, ReadingSession>> openComic(Comic comic) async {
    try {
      List<String> pages;
      if (comic.format == ComicFormat.pdf) {
        // PDF pages are handled as index strings by pdfx
        pages = List.generate(
            comic.totalPages > 0 ? comic.totalPages : 1,
            (i) => i.toString());
      } else {
        pages = await cbzParser.getImageList(comic.filePath);
      }
      final progress = await localDataSource.getProgress(comic.id);
      final startPage = progress?.currentPage ?? 0;
      return Right(ReadingSession(
        comicId: comic.id,
        pages: pages,
        currentIndex: startPage.clamp(0, pages.length - 1),
      ));
    } on ComicParseException catch (e) {
      return Left(ParseFailure(e.message));
    } on FileNotFoundException catch (e) {
      return Left(FileFailure(e.message));
    } catch (e) {
      return Left(FileFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveProgress(
      String comicId, int currentPage) async {
    try {
      await localDataSource.saveProgress(comicId, currentPage);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ReadingProgress?>> getProgress(
      String comicId) async {
    try {
      final progress = await localDataSource.getProgress(comicId);
      return Right(progress);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<int>>> getPageBytes(
      Comic comic, String pageName) async {
    try {
      final bytes = await cbzParser.getPageBytes(comic.filePath, pageName);
      return Right(bytes);
    } on ComicParseException catch (e) {
      return Left(ParseFailure(e.message));
    } catch (e) {
      return Left(FileFailure(e.toString()));
    }
  }
}
