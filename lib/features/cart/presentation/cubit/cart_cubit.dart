import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../products/domain/entities/product.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addToCart(Product product) {
    if (!state.containsProduct(product.id)) {
      emit(state.copyWith(items: [...state.items, product]));
    }
  }

  void removeFromCart(int productId) {
    emit(state.copyWith(
      items: state.items.where((item) => item.id != productId).toList(),
    ));
  }

  void clearCart() {
    emit(const CartState());
  }
}
