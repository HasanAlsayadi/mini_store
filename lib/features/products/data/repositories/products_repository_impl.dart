import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/products_remote_source.dart';

/// Repository implementation — maps exceptions to Failures
class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteSource remoteSource;

  const ProductsRepositoryImpl(this.remoteSource);

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final products = await remoteSource.getProducts();
      return Right(products);
    } on NetworkException {
      return const Left(NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }
}
