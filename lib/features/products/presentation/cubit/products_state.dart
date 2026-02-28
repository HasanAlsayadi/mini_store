import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

enum ProductsStatus { initial, loading, loaded, error }

class ProductsState extends Equatable {
  final ProductsStatus status;
  final List<Product> products;
  final List<Product> filteredProducts;
  final String? errorMessage;
  final String selectedCategory;

  const ProductsState({
    this.status = ProductsStatus.initial,
    this.products = const [],
    this.filteredProducts = const [],
    this.errorMessage,
    this.selectedCategory = 'الكل',
  });

  ProductsState copyWith({
    ProductsStatus? status,
    List<Product>? products,
    List<Product>? filteredProducts,
    String? errorMessage,
    String? selectedCategory,
  }) {
    return ProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      errorMessage: errorMessage,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [
        status,
        products,
        filteredProducts,
        errorMessage,
        selectedCategory,
      ];
}
