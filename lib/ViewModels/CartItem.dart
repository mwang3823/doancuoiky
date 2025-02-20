import 'package:doancuoiky/Models/Cart.dart';
import '../Config/CustomInterceptor.dart';
import '../Config/Storage.dart';
import 'package:dio/dio.dart';

class CartItem {
  static final String url = "http://192.168.1.4:8181";
  final _storage = Storage();
  final _dio = Dio(
      BaseOptions(baseUrl: url, headers: {'Content-Type': 'application/json'}))
    ..interceptors.add(CustomInterceptor());

  Future<CartItemModel?> addProductToCart(
      CartItemModel cartItem, String cartID) async {
    try {
      final response = await _dio.post('/cartitems/addproduct/$cartID',
          options: Options(
              headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
          data: {
            'status': cartItem.status,
            'price': cartItem.price,
            'quantity': cartItem.quantity,
            'product_id': cartItem.productId,
          });
      if (response.statusCode == 200) {
        final data = CartItemModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return null;
  }

  Future<bool?> clearCart() async {
    try {
      final response = await _dio.post(
        '/cartitems/clearcart',
        options: Options(
            headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
      );
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return false;
  }

  Future<CartItemModel?> updateCartItem(CartItemModel cartItem) async {
    try {
      final response = await _dio.put('/cartitems/${cartItem.cartItemId}',
          options: Options(
              headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
          data: {
            'status': cartItem.status,
            'price': cartItem.price,
            'quantity': cartItem.quantity,
            'product_id': cartItem.productId,
            'cart_id': cartItem.cartId,
          });
      if (response.statusCode == 200) {
        final data = CartItemModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return null;
  }

  Future<bool?> deleteCartItem(String cartItemId) async {
    try {
      final response = await _dio.delete('/cartitems/$cartItemId',
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

  Future<CartItemModel?> getCartItemByID(String cartItemId) async {
    try {
      final response = await _dio.get('/cartitems/$cartItemId',
          options: Options(
              headers: {'Authorization': 'Bearer ${_storage.read('token')}'}));
      if (response.statusCode == 200) {
        final data = CartItemModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return null;
  }

  Future<CartItemModel?> getCartItemsByCartID(String cartId) async {
    try {
      final response = await _dio.get('/cartitems/cartitems/$cartId',
          options: Options(
              headers: {'Authorization': 'Bearer ${_storage.read('token')}'}));
      if (response.statusCode == 200) {
        final data = CartItemModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return null;
  }

  Future<List<CartItemModel>?> getAllCartItemsByCartID(String cartId) async {
    try {
      final response = await _dio.get('/cartitems/cartitems/all/$cartId',
          options: Options(
              headers: {'Authorization': 'Bearer ${_storage.read('token')}'}));
      if (response.statusCode == 200) {
        final List<dynamic> list = response.data;
        final data = list.map((e) => CartItemModel.fromJson(e)).toList();
        return data;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return null;
  }
}
// [GIN-debug] POST   /cartitems/addproduct/:cartID --> MSA-Project/internal/interfaces/http.CartItemHandler.AddProductToCart-fm (4 handlers)
// [GIN-debug] POST   /cartitems/clearcart      --> MSA-Project/internal/interfaces/http.CartItemHandler.ClearCart-fm (4 handlers)
// [GIN-debug] PUT    /cartitems/:id            --> MSA-Project/internal/interfaces/http.CartItemHandler.UpdateCartItem-fm (4 handlers)
// [GIN-debug] PUT    /cartitems/               --> MSA-Project/internal/interfaces/http.CartItemHandler.UpdateCartItemsStatus-fm (4 handlers)
// [GIN-debug] DELETE /cartitems/:id            --> MSA-Project/internal/interfaces/http.CartItemHandler.DeleteCartItem-fm (4 handlers)
// [GIN-debug] GET    /cartitems/:id            --> MSA-Project/internal/interfaces/http.CartItemHandler.GetCartItemByID-fm (4 handlers)
// [GIN-debug] GET    /cartitems/cartitems/:cartID  --> MSA-Project/internal/interfaces/http.CartItemHandler.GetCartItemsByCartID-fm (4 handlers)
// [GIN-debug] GET    /cartitems/cartitems/all/:cartID --> MSA-Project/internal/interfaces/http.CartItemHandler.GetAllCartItemsByCartID-fm (4 handlers)
