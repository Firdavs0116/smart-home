class APIExceptions implements Exception{
  const APIExceptions({
    required this.message,
    required this.statuscode,
  });
  final String message;
  final int statuscode;
}

class ServerExceptions implements Exception{
  const ServerExceptions({
    required this.message,
    required this.statuscode,
  });
  final String message;
  final int statuscode;
  
}
class CacheException implements Exception {
  const CacheException({
    required this.message,
    required this.statusCode,
  });

  final String message;
  final int statusCode;
}