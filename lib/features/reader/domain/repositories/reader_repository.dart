import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../library/domain/entities/comic.dart';
import '../entities/reading_session.dart';

abstract class ReaderRepository {
  Future<Either<Failure, ReadingSession>> openComic(Comic comic);
  Future<Either<Failure, Unit>> saveProgress(String comicId, int currentPage);
  Future<Either<Failure, ReadingProgress?>> getProgress(String comicId);
  Future<Either<Failure, List<int>>> getPageBytes(
      Comic comic, String pageName);
}
