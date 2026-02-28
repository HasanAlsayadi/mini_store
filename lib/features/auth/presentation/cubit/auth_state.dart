import 'package:equatable/equatable.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  otpSent,
  unauthenticated,
  error,
}

enum LoginMode { email, phone }

class AuthState extends Equatable {
  final AuthStatus status;
  final LoginMode loginMode;
  final String? errorMessage;
  final String? phoneNumber;

  const AuthState({
    this.status = AuthStatus.initial,
    this.loginMode = LoginMode.email,
    this.errorMessage,
    this.phoneNumber,
  });

  AuthState copyWith({
    AuthStatus? status,
    LoginMode? loginMode,
    String? errorMessage,
    String? phoneNumber,
  }) {
    return AuthState(
      status: status ?? this.status,
      loginMode: loginMode ?? this.loginMode,
      errorMessage: errorMessage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  List<Object?> get props => [status, loginMode, errorMessage, phoneNumber];
}
