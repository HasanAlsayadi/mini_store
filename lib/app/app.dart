import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../core/constants/app_strings.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/auth/presentation/cubit/auth_state.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/cart/presentation/cubit/cart_cubit.dart';
import '../features/products/presentation/cubit/products_cubit.dart';
import '../features/products/presentation/screens/home_screen.dart';
import 'di.dart';

class MiniStoreApp extends StatelessWidget {
  const MiniStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<AuthCubit>()..checkAuth(),
        ),
        BlocProvider(
          create: (_) => sl<ProductsCubit>()..fetchProducts(),
        ),
        BlocProvider(
          create: (_) => sl<CartCubit>(),
        ),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,

        // ── RTL + Arabic Locale ─────────────────────────
        locale: const Locale('ar'),
        supportedLocales: const [
          Locale('ar'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        // ── Auth-based routing ──────────────────────────
        home: BlocBuilder<AuthCubit, AuthState>(
          buildWhen: (prev, curr) =>
              prev.status != curr.status &&
              (curr.status == AuthStatus.authenticated ||
               curr.status == AuthStatus.unauthenticated),
          builder: (context, state) {
            if (state.status == AuthStatus.authenticated) {
              return const HomeScreen();
            }
            if (state.status == AuthStatus.unauthenticated) {
              return const LoginScreen();
            }
            // Initial / loading — show splash
            return const _SplashView();
          },
        ),
      ),
    );
  }
}

/// Minimal splash while checking auth status
class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A237E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.shopping_bag_rounded,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppStrings.appName,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
