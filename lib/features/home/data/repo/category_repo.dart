import 'package:angelina_app/core/utils/constants/constants.dart';
import 'package:dio/dio.dart';
import '../model/category_model.dart';

class CategoryRepo {
  final Dio _dio = Dio();

  Future<List<CategoryModel>> fetchCategories() async {
    final response = await _dio.get(AppConstants.categoryBaseUrl);

    return (response.data as List)
        .map((json) => CategoryModel.fromJson(json))
        .toList();
  }
}
