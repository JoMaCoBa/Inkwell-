import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../library/domain/entities/comic.dart';
import '../repositories/reader_repository.dart';

class GetProgress extends UseCase<ReadingProgress?, GetProgressParams> {
  final ReaderRepository repository;
  GetProgress(this.repository);

  @override
  Future<Either<Failure, ReadingProgress?>> call(GetProgressParams params) =>
      repository.getProgress(params.comicId);
}

class GetProgressParams extends Equatable {
  final String comicId;
  const GetProgressParams(this.comicId);

  @override
  List<Object?> get props => [comicId];
}
