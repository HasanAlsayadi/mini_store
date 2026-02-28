import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/network/api_client.dart';
import '../features/auth/data/datasources/auth_local_source.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/auth_usecases.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/cart/presentation/cubit/cart_cubit.dart';
import '../features/products/data/datasources/products_remote_source.dart';
import '../features/products/data/repositories/products_repository_impl.dart';
import '../features/products/domain/repositories/products_repository.dart';
import '../features/products/domain/usecases/get_products.dart';
import '../features/products/presentation/cubit/products_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ── External ─────────────────────────────────────────
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  final apiClient = ApiClient();
  sl.registerLazySingleton<Dio>(() => apiClient.dio);

  // ── Data Sources ─────────────────────────────────────
  sl.registerLazySingleton(() => AuthLocalSource(sl()));
  sl.registerLazySingleton(() => ProductsRemoteSource(sl()));

  // ── Repositories ─────────────────────────────────────
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImpl(sl()),
  );

  // ── Use Cases ────────────────────────────────────────
  sl.registerLazySingleton(() => LoginWithEmail(sl()));
  sl.registerLazySingleton(() => LoginWithPhone(sl()));
  sl.registerLazySingleton(() => VerifyOtp(sl()));
  sl.registerLazySingleton(() => CheckLoginStatus(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => GetProducts(sl()));

  // ── Cubits ───────────────────────────────────────────
  sl.registerFactory(() => AuthCubit(
        loginWithEmailUseCase: sl(),
        loginWithPhoneUseCase: sl(),
        verifyOtpUseCase: sl(),
        checkLoginStatusUseCase: sl(),
        logoutUseCase: sl(),
      ));
  sl.registerFactory(() => ProductsCubit(sl()));
  sl.registerFactory(() => CartCubit());
}
