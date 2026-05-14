import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/comic.dart';
import '../repositories/comic_repository.dart';

class ImportComic extends UseCase<Comic, ImportComicParams> {
  final ComicRepository repository;
  ImportComic(this.repository);

  @override
  Future<Either<Failure, Comic>> call(ImportComicParams params) =>
      repository.importComic(params.filePath);
}

class ImportComicParams extends Equatable {
  final String filePath;
  const ImportComicParams(this.filePath);

  @override
  List<Object?> get props => [filePath];
}
