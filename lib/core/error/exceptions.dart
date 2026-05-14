class DatabaseException implements Exception {
  final String message;
  const DatabaseException(this.message);
}

class ComicParseException implements Exception {
  final String message;
  const ComicParseException(this.message);
}

class FileNotFoundException implements Exception {
  final String message;
  const FileNotFoundException(this.message);
}

class PermissionException implements Exception {
  final String message;
  const PermissionException(this.message);
}
