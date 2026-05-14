abstract class Failure {
  final String message;
  const Failure(this.message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

class FileFailure extends Failure {
  const FileFailure(super.message);
}

class ParseFailure extends Failure {
  const ParseFailure(super.message);
}

class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}
