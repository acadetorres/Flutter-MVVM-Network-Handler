

/// This class is an from https://medium.com/@ermarajhussain/flutter-mvvm-architecture-best-practice-using-provide-http-4939bdaae171
/// It is now modified for our use cases.
class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}

class HttpNotFoundException extends AppException {
  HttpNotFoundException([String? message]) {
    throw AppException(message, "HTTP 404: ");
  }
}

class HttpException extends AppException {
  HttpException([String? message]) {
    throw AppException(message, "");
  }
}