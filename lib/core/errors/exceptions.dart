class ServerException implements Exception{

}
class ServerExceptions implements Exception{
  final String errorMessage;

  ServerExceptions(this.errorMessage);
  @override
  String toString() {
    return 'ServerException: $errorMessage';
  }

}

class CacheException implements Exception{}