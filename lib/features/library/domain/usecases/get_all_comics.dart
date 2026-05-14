import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/comic.dart';
import '../repositories/comic_repository.dart';

class GetAllComics extends UseCase<List<Comic>, NoParams> {
  final ComicRepository repository;
  GetAllComics(this.repository);

  @override
  Future<Either<Failure, List<Comic>>> call(NoParams params) =>
      repository.getAll();
}
