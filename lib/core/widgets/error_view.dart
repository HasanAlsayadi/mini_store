import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimens.dart';
import '../constants/app_styles.dart';
import '../constants/app_strings.dart';
import 'app_button.dart';

/// Professional error view with retry button
class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorView({
    super.key,
    this.message = AppStrings.errorOccurred,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeInUp(
        duration: const Duration(milliseconds: 400),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error icon with animated container
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.warning_2,
                  size: 48,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: AppDimens.lg),

              Text(
                AppStrings.errorOccurred,
                style: AppStyles.headline3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimens.sm),

              Text(
                message,
                style: AppStyles.body2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimens.xl),

              if (onRetry != null)
                SizedBox(
                  width: 200,
                  child: AppButton(
                    text: AppStrings.retry,
                    icon: Iconsax.refresh,
                    onPressed: onRetry,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
