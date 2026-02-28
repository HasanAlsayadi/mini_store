import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/utils/validators.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _obscurePassword = true;
  String _fullPhoneNumber = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.error && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Iconsax.warning_2, color: Colors.white, size: 20),
                  const SizedBox(width: AppDimens.sm),
                  Expanded(
                    child: Text(
                      state.errorMessage!,
                      style: GoogleFonts.cairo(color: Colors.white),
                    ),
                  ),
                ],
              ),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusMd),
              ),
            ),
          );
          context.read<AuthCubit>().clearError();
        }

        if (state.status == AuthStatus.otpSent) {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => OtpScreen(
                phoneNumber: state.phoneNumber ?? '',
              ),
              transitionDuration: const Duration(milliseconds: 400),
              transitionsBuilder: (_, animation, __, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  )),
                  child: child,
                );
              },
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(AppDimens.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimens.xl),

                  // ── Logo / Brand ──────────────────────────
                  FadeInDown(
                    duration: const Duration(milliseconds: 500),
                    child: Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(AppDimens.radiusXl),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Iconsax.shop,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimens.xl),

                  // ── Welcome Text ──────────────────────────
                  FadeInDown(
                    delay: const Duration(milliseconds: 100),
                    duration: const Duration(milliseconds: 500),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            AppStrings.welcome,
                            style: AppStyles.headline1,
                          ),
                          const SizedBox(height: AppDimens.xs),
                          Text(
                            AppStrings.welcomeSubtitle,
                            style: AppStyles.body2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimens.xl),

                  // ── Login Mode Toggle ─────────────────────
                  FadeInDown(
                    delay: const Duration(milliseconds: 200),
                    duration: const Duration(milliseconds: 500),
                    child: BlocBuilder<AuthCubit, AuthState>(
                      buildWhen: (prev, curr) => prev.loginMode != curr.loginMode,
                      builder: (context, state) {
                        return Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: Row(
                            children: [
                              _buildToggleTab(
                                title: AppStrings.loginWithEmail,
                                icon: Iconsax.sms,
                                isSelected: state.loginMode == LoginMode.email,
                                onTap: () {
                                  if (state.loginMode != LoginMode.email) {
                                    context.read<AuthCubit>().toggleLoginMode();
                                  }
                                },
                              ),
                              _buildToggleTab(
                                title: AppStrings.loginWithPhone,
                                icon: Iconsax.call,
                                isSelected: state.loginMode == LoginMode.phone,
                                onTap: () {
                                  if (state.loginMode != LoginMode.phone) {
                                    context.read<AuthCubit>().toggleLoginMode();
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppDimens.lg),

                  // ── Form Fields ───────────────────────────
                  BlocBuilder<AuthCubit, AuthState>(
                    buildWhen: (prev, curr) =>
                        prev.loginMode != curr.loginMode ||
                        prev.status != curr.status,
                    builder: (context, state) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.1),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: state.loginMode == LoginMode.email
                            ? _buildEmailForm(state)
                            : _buildPhoneForm(state),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleTab({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: AppDimens.sm + 2),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.primaryGradient : null,
            borderRadius: BorderRadius.circular(AppDimens.radiusSm),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : AppColors.textHint,
              ),
              const SizedBox(width: AppDimens.xs),
              Flexible(
                child: Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textHint,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailForm(AuthState state) {
    return Column(
      key: const ValueKey('email_form'),
      children: [
        FadeInUp(
          duration: const Duration(milliseconds: 400),
          child: AppTextField(
            controller: _emailController,
            hintText: AppStrings.enterEmail,
            prefixIcon: Iconsax.sms,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
          ),
        ),
        const SizedBox(height: AppDimens.md),
        FadeInUp(
          delay: const Duration(milliseconds: 100),
          duration: const Duration(milliseconds: 400),
          child: AppTextField(
            controller: _passwordController,
            hintText: AppStrings.enterPassword,
            prefixIcon: Iconsax.lock,
            obscureText: _obscurePassword,
            validator: Validators.password,
            suffixIcon: GestureDetector(
              onTap: () => setState(() => _obscurePassword = !_obscurePassword),
              child: Icon(
                _obscurePassword ? Iconsax.eye_slash : Iconsax.eye,
                color: AppColors.textHint,
                size: 20,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppDimens.xl),
        FadeInUp(
          delay: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 400),
          child: AppButton(
            text: AppStrings.login,
            isLoading: state.status == AuthStatus.loading,
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                context.read<AuthCubit>().loginWithEmail(
                      _emailController.text.trim(),
                      _passwordController.text,
                    );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneForm(AuthState state) {
    return Column(
      key: const ValueKey('phone_form'),
      children: [
        FadeInUp(
          duration: const Duration(milliseconds: 400),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: IntlPhoneField(
              controller: _phoneController,
              initialCountryCode: 'SA',
              languageCode: 'ar',
              style: GoogleFonts.cairo(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: AppStrings.enterPhone,
                hintStyle: GoogleFonts.cairo(
                  fontSize: 14,
                  color: AppColors.textHint,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.md,
                  vertical: AppDimens.md,
                ),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
              ),
              onChanged: (phone) {
                _fullPhoneNumber = phone.completeNumber;
              },
            ),
          ),
        ),
        const SizedBox(height: AppDimens.xl),
        FadeInUp(
          delay: const Duration(milliseconds: 100),
          duration: const Duration(milliseconds: 400),
          child: AppButton(
            text: AppStrings.continueText,
            isLoading: state.status == AuthStatus.loading,
            onPressed: () {
              if (_phoneController.text.isNotEmpty) {
                context.read<AuthCubit>().loginWithPhone(
                      _fullPhoneNumber.isNotEmpty
                          ? _fullPhoneNumber
                          : _phoneController.text,
                    );
              }
            },
          ),
        ),
      ],
    );
  }
}
