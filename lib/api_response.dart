
///THIS IS like sealed class of Kotlin. Basically it wraps the data you're passing on
///the methods parameters. These are the emitted values from NetworkStreamHandler
///ApiResponse<T> where T is the data a generic of Dart Class that you will input
///See MetaResponse and LoginResponse

class ApiResponse<T> {
  Status status;
  T? data;
  String? message;
  bool isLoading = false;

  ApiResponse.loading(this.isLoading) : status = Status.LOADING;
  ApiResponse.completed(this.data) : status = Status.COMPLETED;
  ApiResponse.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status { LOADING, COMPLETED, ERROR }

