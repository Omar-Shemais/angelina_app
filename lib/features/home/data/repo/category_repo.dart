import 'package:dio/dio.dart';
import '../model/category_model.dart';

class CategoryRepo {
  final Dio _dio = Dio();

  Future<List<CategoryModel>> fetchCategories() async {
    final response = await _dio.get(
      'https://angelinashop2025.com/wp-json/wc/v3/products/categories?consumer_key=ck_0e46d6f95c508e91ae3d99f64845cc3b6f5eb5e5&consumer_secret=cs_ab95108f084683daa92f347a81c6d7a5035435ac',
    );

    return (response.data as List)
        .map((json) => CategoryModel.fromJson(json))
        .toList();
  }
}
