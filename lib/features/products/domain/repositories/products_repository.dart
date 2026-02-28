import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product.dart';

/// Abstract repository contract — domain layer depends on this
abstract class ProductsRepository {
  Future<Either<Failure, List<Product>>> getProducts();
}
