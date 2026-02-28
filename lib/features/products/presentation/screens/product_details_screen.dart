import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/widgets/cached_image.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_state.dart';
import '../../domain/entities/product.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── App Bar with Image ────────────────────────
          SliverAppBar(
            expandedHeight: AppDimens.detailImageHeight,
            pinned: true,
            stretch: true,
            backgroundColor: AppColors.surface,
            leading: Padding(
              padding: const EdgeInsets.all(AppDimens.sm),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.surface,
                padding: const EdgeInsets.all(AppDimens.xl),
                child: Hero(
                  tag: 'product-${product.id}',
                  child: CachedImage(
                    imageUrl: product.image,
                    fit: BoxFit.contain,
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
            ),
          ),

          // ── Product Details ───────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppDimens.radiusXl),
                  topRight: Radius.circular(AppDimens.radiusXl),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Title & Price ─────────────────────
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              product.title,
                              style: AppStyles.headline3,
                            ),
                          ),
                          const SizedBox(width: AppDimens.md),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimens.md,
                              vertical: AppDimens.sm,
                            ),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(
                                AppDimens.radiusMd,
                              ),
                            ),
                            child: Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: GoogleFonts.cairo(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimens.md),

                    // ── Rating ────────────────────────────
                    FadeInUp(
                      delay: const Duration(milliseconds: 100),
                      duration: const Duration(milliseconds: 400),
                      child: Container(
                        padding: const EdgeInsets.all(AppDimens.md),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius:
                              BorderRadius.circular(AppDimens.radiusMd),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            RatingBar.builder(
                              initialRating: product.rating,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 20,
                              ignoreGestures: true,
                              unratedColor: AppColors.divider,
                              itemBuilder: (_, __) => const Icon(
                                Icons.star_rounded,
                                color: AppColors.ratingStar,
                              ),
                              onRatingUpdate: (_) {},
                            ),
                            const SizedBox(width: AppDimens.sm),
                            Text(
                              product.rating.toStringAsFixed(1),
                              style: AppStyles.label.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: AppDimens.xs),
                            Text(
                              '(${product.ratingCount} ${AppStrings.reviews})',
                              style: AppStyles.caption,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimens.lg),

                    // ── Description ───────────────────────
                    FadeInUp(
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 400),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.description,
                            style: AppStyles.headline3.copyWith(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: AppDimens.sm),
                          Text(
                            product.description,
                            style: AppStyles.body1.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimens.xxl),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // ── Bottom Bar: Add to Cart ─────────────────────
      bottomNavigationBar: FadeInUp(
        duration: const Duration(milliseconds: 500),
        child: Container(
          padding: const EdgeInsets.all(AppDimens.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: BlocBuilder<CartCubit, CartState>(
              builder: (context, cartState) {
                final isInCart = cartState.containsProduct(product.id);

                return GestureDetector(
                  onTap: () {
                    if (!isInCart) {
                      context.read<CartCubit>().addToCart(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(
                                Iconsax.tick_circle,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: AppDimens.sm),
                              Text(
                                AppStrings.addedToCart,
                                style: GoogleFonts.cairo(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppDimens.radiusMd),
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: AppDimens.buttonHeight,
                    decoration: BoxDecoration(
                      gradient: isInCart ? null : AppColors.primaryGradient,
                      color: isInCart ? AppColors.success : null,
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusMd),
                      boxShadow: [
                        BoxShadow(
                          color: (isInCart
                                  ? AppColors.success
                                  : AppColors.primary)
                              .withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isInCart
                              ? Iconsax.tick_circle
                              : Iconsax.shopping_bag,
                          color: Colors.white,
                          size: 22,
                        ),
                        const SizedBox(width: AppDimens.sm),
                        Text(
                          isInCart
                              ? AppStrings.addedToCart
                              : AppStrings.addToCart,
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
