import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product.dart';
import '../repositories/products_repository.dart';

/// Use case: fetch all products from the API
class GetProducts {
  final ProductsRepository repository;

  const GetProducts(this.repository);

  Future<Either<Failure, List<Product>>> call() {
    return repository.getProducts();
  }
}
