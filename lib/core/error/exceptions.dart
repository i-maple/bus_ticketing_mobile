class ServerException implements Exception {
  const ServerException(this.message, {this.code});

  final String message;
  final String? code;
}

class CacheException implements Exception {
  const CacheException(this.message, {this.code});

  final String message;
  final String? code;
}

class ParsingException implements Exception {
  const ParsingException(this.message, {this.code});

  final String message;
  final String? code;
}
