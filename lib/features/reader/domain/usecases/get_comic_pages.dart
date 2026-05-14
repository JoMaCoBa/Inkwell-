import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../library/domain/entities/comic.dart';
import '../entities/reading_session.dart';
import '../repositories/reader_repository.dart';

class GetComicPages extends UseCase<ReadingSession, GetComicPagesParams> {
  final ReaderRepository repository;
  GetComicPages(this.repository);

  @override
  Future<Either<Failure, ReadingSession>> call(GetComicPagesParams params) =>
      repository.openComic(params.comic);
}

class GetComicPagesParams extends Equatable {
  final Comic comic;
  const GetComicPagesParams(this.comic);

  @override
  List<Object?> get props => [comic];
}
