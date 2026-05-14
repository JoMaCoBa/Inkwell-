import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../library/domain/entities/comic.dart';
import '../../../library/domain/repositories/comic_repository.dart';

class GetComicDetail extends UseCase<Comic, GetComicDetailParams> {
  final ComicRepository repository;
  GetComicDetail(this.repository);

  @override
  Future<Either<Failure, Comic>> call(GetComicDetailParams params) =>
      repository.getById(params.id);
}

class GetComicDetailParams extends Equatable {
  final String id;
  const GetComicDetailParams(this.id);

  @override
  List<Object?> get props => [id];
}
