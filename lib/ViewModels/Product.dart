import 'package:dio/dio.dart';
import 'package:doancuoiky/Config/CustomInterceptor.dart';
import 'package:doancuoiky/Config/Storage.dart';
import 'package:doancuoiky/Models/Product.dart';

class Product {
  static final String url="http://192.168.1.4:8181";
  final _dio = Dio(BaseOptions(
      baseUrl: url,
      headers: {'Content_Type': 'application/json'}))
    ..interceptors.add(CustomInterceptor());
  final _storage = Storage();

  Future<ProductModel?> createProduct(ProductModel product) async {
    try {
      final response = await _dio.post(
        '/products/',
        options: Options(
            headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
        data: {
          'name': product.name,
          'image': product.image,
          'sales': product.sales,
          'size': product.size,
          'color': product.color,
          'specification': product.specification,
          'expiry': product.expiry,
          'stocknumber': product.stockNumber,
          'stocklevel': product.stockLevel,
          'category_id': product.categoryId,
          'manufacturer_id': product.manufacturerId,
        },
      );
      if (response.statusCode == 200) {
        final data = ProductModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return null;
  }

  Future<ProductModel?> updateProduct(ProductModel product) async {
    try {
      final response = await _dio.put(
        '/products/${product.productId}',
        options: Options(
            headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
        data: {
          'name': product.name,
          'image': product.image,
          'sales': product.sales,
          'size': product.size,
          'color': product.color,
          'specification': product.specification,
          'expiry': product.expiry,
          'stocknumber': product.stockNumber,
          'stocklevel': product.stockLevel,
          'category_id': product.categoryId,
          'manufacturer_id': product.manufacturerId,
        },
      );
      if (response.statusCode == 200) {
        final data = ProductModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return null;
  }

  Future<bool> deleteProduct(String id) async {
    try {
      final response = await _dio.delete(
        '/products/$id',
        options: Options(
            headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
      );
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return false;
  }

  Future<ProductModel?> getProductById(String id) async {
    try {
      final response = await _dio.get(
        '/products/$id',
        options: Options(
            headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
      );
      if (response.statusCode == 200) {
        final data = ProductModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return null;
  }

  Future<List<ProductModel>> getAllProduct() async {
    try {
      final response = await _dio.get(
        '/products/',
        options: Options(
            headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
      );
      if (response.statusCode == 200) {
        final List<dynamic> list = response.data;
        final data = list
            .map(
              (e) => ProductModel.fromJson(e),
            )
            .toList();
        return data;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return [];
  }

  Future<List<ProductModel>> searchProduct(String name) async {
    try {
      final response =
          await _dio.get('/products/search', queryParameters: {'name': name},
              options: Options(
              headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),);
      if (response.statusCode == 200) {
        final List<dynamic> list = response.data;
        final data = list
            .map(
              (e) => ProductModel.fromJson(e),
            )
            .toList();
        return data;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return [];
  }
}
// [GIN-debug] GET    /products/                --> MSA-Project/internal/interfaces/http.ProductHandler.GetAllProducts-fm (3 handlers)
// [GIN-debug] GET    /products/:id             --> MSA-Project/internal/interfaces/http.ProductHandler.GetProductByID-fm (3 handlers)
// [GIN-debug] GET    /products/search          --> MSA-Project/internal/interfaces/http.ProductHandler.SearchProducts-fm (3 handlers)
// [GIN-debug] GET    /products/filter          --> MSA-Project/internal/interfaces/http.ProductHandler.FilterAndSortProducts-fm (3 handlers)
// [GIN-debug] POST   /products/                --> MSA-Project/internal/interfaces/http.ProductHandler.CreateProduct-fm (4 handlers)
// [GIN-debug] PUT    /products/:id             --> MSA-Project/internal/interfaces/http.ProductHandler.UpdateProduct-fm (4 handlers)
// [GIN-debug] DELETE /products/:id             --> MSA-Project/internal/interfaces/http.ProductHandler.DeleteProduct-fm (4 handlers)