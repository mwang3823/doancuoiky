import 'package:dio/dio.dart';
import 'package:doancuoiky/Config/CustomInterceptor.dart';
import 'package:doancuoiky/Config/Storage.dart';
import 'package:doancuoiky/Models/Order.dart';

class Order {
  static final String url = "http://192.168.1.4:8181";
  final _dio = Dio(
      BaseOptions(baseUrl: url, headers: {'Content_Type': 'application/json'}))
    ..interceptors.add(CustomInterceptor());
  final _storage = Storage();

  Future<OrderModel?> createOrder(OrderModel order, String userId, String cartId, String promoCode) async {
    try {
      final response = await _dio.post('/orders/',
          options: Options(
              headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
          queryParameters: {
            "user_id": userId,
            "cart_id": cartId,
            "promo_code": promoCode ?? "",
          });
      if (response.statusCode == 200) {
        final data = OrderModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return null;
  }

  Future<OrderModel?> updateOrder(OrderModel order) async {
    try {
      final response = await _dio.put(
        '/orders/${order.orderId}',
        options: Options(
            headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
        data: {
          'grandtotal': order.grandTotal,
          'user_id': order.userId,
          'cart_id': order.cartId,
          'status': order.status,
        },
      );
      if (response.statusCode == 200) {
        final data = OrderModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return null;
  }

  Future<bool> deleteOrder(String id) async {
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

  Future<OrderModel?> getOrderById(String id) async {
    try {
      final response = await _dio.get(
        '/orders/$id',
        options: Options(
            headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
      );
      if (response.statusCode == 200) {
        final data = OrderModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return null;
  }

  Future<List<OrderModel>> getOrdersByStatus(String userId, String status) async {
    try {
      final response = await _dio.get(
        '/orders/history/$userId/$status',
        options: Options(
            headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
      );
      if (response.statusCode == 200) {
        final List<dynamic> list = response.data;
        final data = list
            .map(
              (e) => OrderModel.fromJson(e),
            )
            .toList();
        return data;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return [];
  }

  Future<List<OrderModel>> searchOrderByPhoneNumber(String numberPhone) async {
    try {
      final response = await _dio.get(
        '/orders/search',
        queryParameters: {'phonenumber': numberPhone},
        options: Options(
            headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
      );
      if (response.statusCode == 200) {
        final List<dynamic> list = response.data;
        final data = list
            .map(
              (e) => OrderModel.fromJson(e),
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
// [GIN-debug] POST   /orders/                  --> MSA-Project/internal/interfaces/http.OrderHandler.CreateOrder-fm (4 handlers)
// [GIN-debug] PUT    /orders/:id               --> MSA-Project/internal/interfaces/http.OrderHandler.UpdateOrder-fm (4 handlers)
// [GIN-debug] DELETE /orders/:id               --> MSA-Project/internal/interfaces/http.OrderHandler.DeleteOrder-fm (4 handlers)
// [GIN-debug] GET    /orders/:id               --> MSA-Project/internal/interfaces/http.OrderHandler.GetOrderByID-fm (4 handlers)
// [GIN-debug] GET    /orders/                  --> MSA-Project/internal/interfaces/http.OrderHandler.GetAllOrders-fm (4 handlers)
// [GIN-debug] GET    /orders/preview-order     --> MSA-Project/internal/interfaces/http.OrderHandler.PreviewOrder-fm (4 handlers)
// [GIN-debug] GET    /orders/history/:user_id/:status --> MSA-Project/internal/interfaces/http.OrderHandler.GetOrdersByStatus-fm (4 handlers)
// [GIN-debug] GET    /orders/search            --> MSA-Project/internal/interfaces/http.OrderHandler.SearchOrderByPhoneNumber-fm (4 handlers)
