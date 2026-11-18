import 'api_error.dart';

/// Resultado estilo HTTP para tests de contrato in-process (DEC-005).
sealed class ApiResult<T> {
  const ApiResult(this.statusCode);

  final int statusCode;
}

class ApiSuccess<T> extends ApiResult<T> {
  ApiSuccess(this.data, {required int statusCode}) : super(statusCode);

  final T data;
}

class ApiFailure<T> extends ApiResult<T> {
  ApiFailure(this.error, {required int statusCode}) : super(statusCode);

  final ApiErrorBody error;
}