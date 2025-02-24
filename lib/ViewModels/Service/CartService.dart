import '../../Config/CustomInterceptor.dart';
import '../../Config/Storage.dart';
import 'package:dio/dio.dart';

import '../../Models/Cart.dart';

class CartService {
  static final String url = "http://192.168.1.4:8181";
  final _storage = Storage();
  final _dio = Dio(
      BaseOptions(baseUrl: url, headers: {'Content-Type':'application/json'}))
    ..interceptors.add(CustomInterceptor());

  Future<CartModel?> createCategory(CartModel category, String userId) async {
    try {
      final response = await _dio.post('/carts/',
          options: Options(
              headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
          data: {"user_id": userId, "status": category.status});
      if (response.statusCode == 200) {
        final data = CartModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return null;
  }

  Future<CartModel?> getOrCreateCartForUser(int userId) async {
    try {
      final token=await  _storage.read('token');
      final response = await _dio.post(
        '/carts/$userId',
        options: Options(
            headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        final data = CartModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return null;
  }

  Future<bool> deleteCategory(String cartID) async {
    try {
      final response = await _dio.delete('/carts/$cartID',
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

  Future<CartModel?> getCartByID(String cartId) async {
    try {
      final response = await _dio.get('/carts/$cartId',
          options: Options(
              headers: {'Authorization': 'Bearer ${_storage.read('token')}'}));
      if (response.statusCode == 200) {
        final data = CartModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return null;
  }
}
// [GIN-debug] POST   /carts/                   --> MSA-Project/internal/interfaces/http.CartHandler.CreateCart-fm (4 handlers)
// [GIN-debug] POST   /carts/:user_id           --> MSA-Project/internal/interfaces/http.CartHandler.GetOrCreateCartForUser-fm (4 handlers)
// [GIN-debug] DELETE /carts/:id                --> MSA-Project/internal/interfaces/http.CartHandler.DeleteCart-fm (4 handlers)
// [GIN-debug] GET    /carts/:id                --> MSA-Project/internal/interfaces/http.CartHandler.GetCartByID-fm (4 handlers)
