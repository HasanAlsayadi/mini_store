import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class LoginWithEmail {
  final AuthRepository repository;
  const LoginWithEmail(this.repository);

  Future<Either<Failure, bool>> call(String email, String password) {
    return repository.loginWithEmail(email, password);
  }
}

class LoginWithPhone {
  final AuthRepository repository;
  const LoginWithPhone(this.repository);

  Future<Either<Failure, bool>> call(String phone) {
    return repository.loginWithPhone(phone);
  }
}

class VerifyOtp {
  final AuthRepository repository;
  const VerifyOtp(this.repository);

  Future<Either<Failure, bool>> call(String otp) {
    return repository.verifyOtp(otp);
  }
}

class CheckLoginStatus {
  final AuthRepository repository;
  const CheckLoginStatus(this.repository);

  Future<bool> call() {
    return repository.isLoggedIn();
  }
}

class Logout {
  final AuthRepository repository;
  const Logout(this.repository);

  Future<void> call() {
    return repository.logout();
  }
}
