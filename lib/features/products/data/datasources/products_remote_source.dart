import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/product_model.dart';

/// Remote data source — fetches products from FakeStore API
class ProductsRemoteSource {
  final Dio dio;

  const ProductsRemoteSource(this.dio);

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await dio.get(ApiEndpoints.products);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Failed to load products',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw const NetworkException();
      }
      throw ServerException(
        message: e.message ?? 'Server error',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
