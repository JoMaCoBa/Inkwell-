import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/comic_repository.dart';

class DeleteComic extends UseCase<Unit, DeleteComicParams> {
  final ComicRepository repository;
  DeleteComic(this.repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteComicParams params) =>
      repository.deleteComic(params.id);
}

class DeleteComicParams extends Equatable {
  final String id;
  const DeleteComicParams(this.id);

  @override
  List<Object?> get props => [id];
}
