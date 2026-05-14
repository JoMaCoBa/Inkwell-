import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/comic.dart';

abstract class ComicRepository {
  Future<Either<Failure, List<Comic>>> getAll();
  Future<Either<Failure, Comic>> importComic(String filePath);
  Future<Either<Failure, Unit>> deleteComic(String id);
  Future<Either<Failure, Comic>> getById(String id);
}
