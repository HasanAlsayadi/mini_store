import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

/// Auth repository contract
abstract class AuthRepository {
  Future<Either<Failure, bool>> loginWithEmail(String email, String password);
  Future<Either<Failure, bool>> loginWithPhone(String phone);
  Future<Either<Failure, bool>> verifyOtp(String otp);
  Future<bool> isLoggedIn();
  Future<void> logout();
}
