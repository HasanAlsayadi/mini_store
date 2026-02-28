import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/usecases/get_products.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final GetProducts getProductsUseCase;

  ProductsCubit(this.getProductsUseCase) : super(const ProductsState());

  /// Category name mapping (English → Arabic)
  static const Map<String, String> categoryMap = {
    'الكل': 'الكل',
    "men's clothing": AppStrings.mensClothing,
    "women's clothing": AppStrings.womensClothing,
    'electronics': AppStrings.electronics,
    'jewelery': AppStrings.jewelery,
  };

  /// Reverse map for filtering
  static const Map<String, String> reverseCategoryMap = {
    'الكل': 'الكل',
    AppStrings.mensClothing: "men's clothing",
    AppStrings.womensClothing: "women's clothing",
    AppStrings.electronics: 'electronics',
    AppStrings.jewelery: 'jewelery',
  };

  /// Fetch all products
  Future<void> fetchProducts() async {
    emit(state.copyWith(status: ProductsStatus.loading));

    final result = await getProductsUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProductsStatus.error,
        errorMessage: failure.message,
      )),
      (products) => emit(state.copyWith(
        status: ProductsStatus.loaded,
        products: products,
        filteredProducts: products,
        selectedCategory: 'الكل',
      )),
    );
  }

  /// Filter products by category
  void filterByCategory(String arabicCategory) {
    if (arabicCategory == 'الكل') {
      emit(state.copyWith(
        filteredProducts: state.products,
        selectedCategory: arabicCategory,
      ));
      return;
    }

    final englishCategory = reverseCategoryMap[arabicCategory] ?? arabicCategory;
    final filtered = state.products
        .where((p) => p.category == englishCategory)
        .toList();

    emit(state.copyWith(
      filteredProducts: filtered,
      selectedCategory: arabicCategory,
    ));
  }

  /// Get available category list (Arabic)
  List<String> get categories => categoryMap.values.toList();
}
