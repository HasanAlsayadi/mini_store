import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/auth_usecases.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginWithEmail loginWithEmailUseCase;
  final LoginWithPhone loginWithPhoneUseCase;
  final VerifyOtp verifyOtpUseCase;
  final CheckLoginStatus checkLoginStatusUseCase;
  final Logout logoutUseCase;

  AuthCubit({
    required this.loginWithEmailUseCase,
    required this.loginWithPhoneUseCase,
    required this.verifyOtpUseCase,
    required this.checkLoginStatusUseCase,
    required this.logoutUseCase,
  }) : super(const AuthState());

  /// Check if user is already logged in
  Future<void> checkAuth() async {
    final isLoggedIn = await checkLoginStatusUseCase();
    if (isLoggedIn) {
      emit(state.copyWith(status: AuthStatus.authenticated));
    } else {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  /// Toggle between email and phone login
  void toggleLoginMode() {
    final newMode = state.loginMode == LoginMode.email
        ? LoginMode.phone
        : LoginMode.email;
    emit(state.copyWith(loginMode: newMode, status: AuthStatus.initial));
  }

  /// Login with email and password
  Future<void> loginWithEmail(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await loginWithEmailUseCase(email, password);

    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: AuthStatus.authenticated)),
    );
  }

  /// Login with phone — sends OTP
  Future<void> loginWithPhone(String phone) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await loginWithPhoneUseCase(phone);

    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        status: AuthStatus.otpSent,
        phoneNumber: phone,
      )),
    );
  }

  /// Verify OTP code
  Future<void> verifyOtp(String otp) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await verifyOtpUseCase(otp);

    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: AuthStatus.authenticated)),
    );
  }

  /// Logout
  Future<void> logout() async {
    await logoutUseCase();
    emit(state.copyWith(status: AuthStatus.unauthenticated));
  }

  /// Reset error state
  void clearError() {
    emit(state.copyWith(status: AuthStatus.initial));
  }
}
