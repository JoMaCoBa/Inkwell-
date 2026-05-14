import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/comic.dart';
import '../../domain/repositories/comic_repository.dart';
import '../datasources/comic_file_datasource.dart';
import '../datasources/comic_local_datasource.dart';

class ComicRepositoryImpl implements ComicRepository {
  final ComicLocalDataSource localDataSource;
  final ComicFileDataSource fileDataSource;

  ComicRepositoryImpl({
    required this.localDataSource,
    required this.fileDataSource,
  });

  @override
  Future<Either<Failure, List<Comic>>> getAll() async {
    try {
      final models = await localDataSource.getAll();
      return Right(models);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Comic>> getById(String id) async {
    try {
      final model = await localDataSource.getById(id);
      if (model == null) return Left(DatabaseFailure('Comic not found'));
      return Right(model);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Comic>> importComic(String filePath) async {
    try {
      final model = await fileDataSource.importComic(filePath);
      await localDataSource.insert(model);
      return Right(model);
    } on ComicParseException catch (e) {
      return Left(ParseFailure(e.message));
    } on FileNotFoundException catch (e) {
      return Left(FileFailure(e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(FileFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteComic(String id) async {
    try {
      await localDataSource.delete(id);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}
