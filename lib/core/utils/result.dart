import '../errors/app_error.dart';

sealed class Result<S, F extends AppError> {
  const Result();

  // The 'when' method allows you to handle both success and failure cases.
  R when<R>(R Function(S success) success, R Function(F failure) failure);

  bool get isSuccess => this is Success<S, F>;
  bool get isFailure => this is Failure<S, F>;

  S get success => (this as Success<S, F>).value;
  F get failure => (this as Failure<S, F>).error;
}

final class Success<S, F extends AppError> extends Result<S, F> {
  final S value;
  const Success(this.value);

  @override
  R when<R>(R Function(S success) success, R Function(F failure) failure) {
    return success(value);
  }
}

final class Failure<S, F extends AppError> extends Result<S, F> {
  final F error;
  const Failure(this.error);

  @override
  R when<R>(R Function(S success) success, R Function(F failure) failure) {
    return failure(error);
  }
}