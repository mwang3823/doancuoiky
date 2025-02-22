import 'package:dio/dio.dart';
import 'package:doancuoiky/Config/CustomInterceptor.dart';
import 'package:doancuoiky/Config/Storage.dart';
import 'package:doancuoiky/Models/Product.dart';

class CategoryService {
  static final String url = "http://192.168.1.4:8181";
  final _storage = Storage();
  final _dio = Dio(
      BaseOptions(baseUrl: url, headers: {'Content-Type': 'application/json'}))
    ..interceptors.add(CustomInterceptor());

  Future<CategoryModel?> createCategory(CategoryModel category) async {
    try {
      final response = await _dio.post('/categories/',
          options: Options(
              headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
          data: {'name': category.name, 'description': category.description});

      if (response.statusCode == 200) {
        final data = CategoryModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return null;
  }

  Future<CategoryModel?> updateCategory(CategoryModel category) async {
    try {
      final response = await _dio.put('/categories/${category.categoryId}',
          options: Options(
              headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
          data: {'name': category.name, 'description': category.description});
      if (response.statusCode == 200) {
        final data = CategoryModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return null;
  }

  Future<bool> deleteCategory(String categoryId) async {
    try {
      final response = await _dio.delete('/categories/$categoryId',
          options: Options(
              headers: {'Authorization': 'Bearer ${_storage.read('token')}'}));
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return false;
  }

  Future<CategoryModel?> getCategoryById(String categoryId) async {
    try {
      final response = await _dio.get('/categories/$categoryId',
          options: Options(
              headers: {'Authorization': 'Bearer ${_storage.read('token')}'}));
      if (response.statusCode == 200) {
        final data = CategoryModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return null;
  }

  Future<List<CategoryModel>?> getAllCategory() async {
    try {
      final response = await _dio.get('/categories/',
          options: Options(
              headers: {'Authorization': 'Bearer ${_storage.read('token')}'}));
      if (response.statusCode == 200) {
        final List<dynamic> list = response.data;
        final data = list
            .map(
              (e) => CategoryModel.fromJson(e),
            )
            .toList();
        return data;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return null;
  }
}
// [GIN-debug] GET    /categories/              --> MSA-Project/internal/interfaces/http.CategoryHandler.GetAllCategories-fm (3 handlers)
// [GIN-debug] GET    /categories/:id           --> MSA-Project/internal/interfaces/http.CategoryHandler.GetCategoryByID-fm (3 handlers)
// [GIN-debug] POST   /categories/              --> MSA-Project/internal/interfaces/http.CategoryHandler.CreateCategory-fm (4 handlers)
// [GIN-debug] PUT    /categories/:id           --> MSA-Project/internal/interfaces/http.CategoryHandler.UpdateCategory-fm (4 handlers)
// [GIN-debug] DELETE /categories/:id           --> MSA-Project/internal/interfaces/http.CategoryHandler.DeleteCategory-fm (4 handlers)
