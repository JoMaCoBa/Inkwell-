import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/reader_repository.dart';

class SaveProgress extends UseCase<Unit, SaveProgressParams> {
  final ReaderRepository repository;
  SaveProgress(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SaveProgressParams params) =>
      repository.saveProgress(params.comicId, params.currentPage);
}

class SaveProgressParams extends Equatable {
  final String comicId;
  final int currentPage;
  const SaveProgressParams({required this.comicId, required this.currentPage});

  @override
  List<Object?> get props => [comicId, currentPage];
}
