import 'package:equatable/equatable.dart';

/// Base failure class — all domain failures extend this
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Server returned an error response (4xx, 5xx)
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'خطأ في الخادم']);
}

/// No internet connection
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'لا يوجد اتصال بالإنترنت']);
}

/// Local storage read/write error
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'خطأ في التخزين المحلي']);
}

/// Unexpected / unknown error
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'خطأ غير متوقع']);
}
