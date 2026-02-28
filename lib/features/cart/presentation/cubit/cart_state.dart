import 'package:equatable/equatable.dart';
import '../../../products/domain/entities/product.dart';

class CartState extends Equatable {
  final List<Product> items;

  const CartState({this.items = const []});

  int get itemCount => items.length;

  double get totalPrice =>
      items.fold(0, (sum, item) => sum + item.price);

  bool containsProduct(int productId) =>
      items.any((item) => item.id == productId);

  CartState copyWith({List<Product>? items}) {
    return CartState(items: items ?? this.items);
  }

  @override
  List<Object> get props => [items];
}
