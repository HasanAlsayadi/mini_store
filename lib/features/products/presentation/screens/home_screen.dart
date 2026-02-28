import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_state.dart';
import '../../../cart/presentation/widgets/cart_badge.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/products_cubit.dart';
import '../cubit/products_state.dart';
import '../widgets/category_chips.dart';
import '../widgets/product_card.dart';
import 'product_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => context.read<ProductsCubit>().fetchProducts(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // ── Header ──────────────────────────────────
              SliverToBoxAdapter(
                child: FadeInDown(
                  duration: const Duration(milliseconds: 500),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimens.md,
                      AppDimens.md,
                      AppDimens.md,
                      AppDimens.sm,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.greeting,
                                style: AppStyles.body2,
                              ),
                              const SizedBox(height: AppDimens.xs),
                              Text(
                                AppStrings.explore,
                                style: AppStyles.headline2,
                              ),
                            ],
                          ),
                        ),
                        // Cart badge
                        BlocBuilder<CartCubit, CartState>(
                          builder: (context, cartState) {
                            return CartBadge(
                              itemCount: cartState.itemCount,
                            );
                          },
                        ),
                        const SizedBox(width: AppDimens.sm),
                        // Logout
                        GestureDetector(
                          onTap: () => _showLogoutDialog(context),
                          child: Container(
                            padding: const EdgeInsets.all(AppDimens.sm),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius:
                                  BorderRadius.circular(AppDimens.radiusMd),
                              border: Border.all(color: AppColors.divider),
                            ),
                            child: const Icon(
                              Iconsax.logout,
                              color: AppColors.textSecondary,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Search Bar ──────────────────────────────
              SliverToBoxAdapter(
                child: FadeInDown(
                  delay: const Duration(milliseconds: 100),
                  duration: const Duration(milliseconds: 500),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.md,
                      vertical: AppDimens.sm,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.md,
                        vertical: AppDimens.sm,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius:
                            BorderRadius.circular(AppDimens.radiusMd),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Iconsax.search_normal,
                            color: AppColors.textHint,
                            size: 20,
                          ),
                          const SizedBox(width: AppDimens.sm),
                          Text(
                            AppStrings.searchProducts,
                            style: AppStyles.body2.copyWith(
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Categories ──────────────────────────────
              SliverToBoxAdapter(
                child: FadeInDown(
                  delay: const Duration(milliseconds: 200),
                  duration: const Duration(milliseconds: 500),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppDimens.sm),
                    child: BlocBuilder<ProductsCubit, ProductsState>(
                      builder: (context, state) {
                        return CategoryChips(
                          categories: context.read<ProductsCubit>().categories,
                          selectedCategory: state.selectedCategory,
                          onSelected: (cat) {
                            context.read<ProductsCubit>().filterByCategory(cat);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),

              // ── Section Title ───────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimens.md,
                    AppDimens.sm,
                    AppDimens.md,
                    AppDimens.sm,
                  ),
                  child: Text(
                    AppStrings.featuredProducts,
                    style: AppStyles.headline3,
                  ),
                ),
              ),

              // ── Products Grid ───────────────────────────
              BlocBuilder<ProductsCubit, ProductsState>(
                builder: (context, state) {
                  switch (state.status) {
                    case ProductsStatus.loading:
                    case ProductsStatus.initial:
                      return const SliverToBoxAdapter(
                        child: LoadingShimmer(),
                      );

                    case ProductsStatus.error:
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: ErrorView(
                          message: state.errorMessage ?? AppStrings.unexpectedError,
                          onRetry: () => context.read<ProductsCubit>().fetchProducts(),
                        ),
                      );

                    case ProductsStatus.loaded:
                      if (state.filteredProducts.isEmpty) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Iconsax.box,
                                  size: 64,
                                  color: AppColors.textHint.withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: AppDimens.md),
                                Text(
                                  AppStrings.emptyProducts,
                                  style: AppStyles.body1.copyWith(
                                    color: AppColors.textHint,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.md,
                        ),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: AppDimens.md,
                            crossAxisSpacing: AppDimens.md,
                            childAspectRatio: 0.62,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final product = state.filteredProducts[index];
                              return ProductCard(
                                product: product,
                                index: index,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          ProductDetailsScreen(
                                        product: product,
                                      ),
                                      transitionDuration:
                                          const Duration(milliseconds: 400),
                                      reverseTransitionDuration:
                                          const Duration(milliseconds: 300),
                                      transitionsBuilder:
                                          (_, animation, __, child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                            childCount: state.filteredProducts.length,
                          ),
                        ),
                      );
                  }
                },
              ),

              // Bottom padding
              const SliverToBoxAdapter(
                child: SizedBox(height: AppDimens.xl),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        ),
        title: Text(
          AppStrings.logout,
          style: AppStyles.headline3,
        ),
        content: Text(
          AppStrings.logoutConfirm,
          style: AppStyles.body1,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              AppStrings.no,
              style: AppStyles.label.copyWith(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthCubit>().logout();
            },
            child: Text(
              AppStrings.yes,
              style: AppStyles.label.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
