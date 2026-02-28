import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_source.dart';

/// Auth repository implementation — mock login logic
class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalSource localSource;

  const AuthRepositoryImpl(this.localSource);

  @override
  Future<Either<Failure, bool>> loginWithEmail(
    String email,
    String password,
  ) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock validation — accept any valid format
      if (email.isNotEmpty && password.length >= 6) {
        await localSource.saveLoginState(
          method: 'email',
          identifier: email,
        );
        return const Right(true);
      }

      return const Left(ServerFailure('بيانات الدخول غير صحيحة'));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> loginWithPhone(String phone) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      if (phone.isNotEmpty) {
        // Phone login just sends OTP — don't save login yet
        return const Right(true);
      }

      return const Left(ServerFailure('رقم الهاتف غير صالح'));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> verifyOtp(String otp) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      // Static OTP code: 0000
      if (otp == '0000') {
        await localSource.saveLoginState(
          method: 'phone',
          identifier: 'phone_user',
        );
        return const Right(true);
      }

      return const Left(ServerFailure('رمز التحقق غير صحيح'));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return localSource.isLoggedIn();
  }

  @override
  Future<void> logout() async {
    await localSource.clearLoginState();
  }
}
