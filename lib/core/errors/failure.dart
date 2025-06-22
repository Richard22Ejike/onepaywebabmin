abstract class Failure {
  final String errorMessage;
  const Failure({required this.errorMessage});
}

abstract class SuccessMessage {
  final String successMessage;
  const SuccessMessage({required this.successMessage});
}

class ServerFailure extends Failure {
  ServerFailure({required String errorMessage})
      : super(errorMessage: errorMessage);
}

class SuccessApiMessage extends SuccessMessage {
  SuccessApiMessage({required String successMessage})
  :super(successMessage: successMessage);
}

class CacheFailure extends Failure {
  CacheFailure({required String errorMessage})
      : super(errorMessage: errorMessage);
}