import 'package:angelina_app/features/home/data/model/product_model.dart';
import 'package:dio/dio.dart';

class ProductRepository {
  final Dio _dio = Dio();
  static const String _baseUrl =
      'https://angelinashop2025.com/wp-json/wc/v3/products';
  static const String _consumerKey =
      'ck_0e46d6f95c508e91ae3d99f64845cc3b6f5eb5e5';
  static const String _consumerSecret =
      'cs_ab95108f084683daa92f347a81c6d7a5035435ac';

  Future<List<ProductModel>> fetchProducts({
    int page = 1,
    int perPage = 5,
  }) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'consumer_key': _consumerKey,
          'consumer_secret': _consumerSecret,
          'page': page,
          'per_page': perPage,
        },
      );
      return (response.data as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<List<ProductModel>> fetchProductsByCategory({
    required int categoryId,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'consumer_key': _consumerKey,
          'consumer_secret': _consumerSecret,
          'page': page,
          'per_page': perPage,
          'category': categoryId, // <-- THIS filters by category
        },
      );

      return (response.data as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load category products: $e');
    }
  }
}

// class ProductRepository {
//   final Dio _dio = Dio();

//   Future<List<ProductModel>> fetchProducts() async {
//     try {
//       final response = await _dio.get(
//         'https://angelinashop2025.com/wp-json/wc/v3/products?per_page=100&consumer_key=ck_0e46d6f95c508e91ae3d99f64845cc3b6f5eb5e5&consumer_secret=cs_ab95108f084683daa92f347a81c6d7a5035435ac',
//       );
//       List<ProductModel> products =
//           (response.data as List)
//               .map((json) => ProductModel.fromJson(json))
//               .toList();

//       return products;
//     } catch (e) {
//       throw Exception('Failed to load products');
//     }
//   }
// }
