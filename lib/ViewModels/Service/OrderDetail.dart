import 'package:dio/dio.dart';
import 'package:doancuoiky/Config/CustomInterceptor.dart';
import 'package:doancuoiky/Config/Storage.dart';
import 'package:doancuoiky/Models/Order.dart';

class OrderDetailService {
  static final String url = "http://192.168.1.4:8181";
  final _storage = Storage();
  final _dio = Dio(
      BaseOptions(baseUrl: url, headers: {'Content-Type': 'application/json'}))
    ..interceptors.add(CustomInterceptor());

  Future<OrderDetailModel?> createOrderDetail(OrderDetailModel orderDetail) async {
    try {
      final response = await _dio.post('/orderdetails/',
          options: Options(
              headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
          data: {
        'status': orderDetail.status,
            'quantity': orderDetail.quantity,
            'unitprice': orderDetail.unitPrice,
            'totalprice': orderDetail.totalPrice,
            'order_id': orderDetail.orderId,
            'product_id': orderDetail.productId,
      });

      if (response.statusCode == 200) {
        final data = OrderDetailModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return null;
  }

  Future<bool> deleteCategory(String orderDetail) async {
    try {
      final response = await _dio.delete('/orderdetails/$orderDetail',
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

  Future<OrderDetailModel?> getOrderDetailByID(String orderDetailId) async {
    try {
      final response = await _dio.get('/orderdetails/$orderDetailId',
          options: Options(
              headers: {'Authorization': 'Bearer ${_storage.read('token')}'}));
      if (response.statusCode == 200) {
        final data = OrderDetailModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return null;
  }
}
// [GIN-debug] POST   /orderdetails/            --> MSA-Project/internal/interfaces/http.OrderDetailHandler.CreateOrderDetail-fm (4 handlers)
// [GIN-debug] DELETE /orderdetails/:id         --> MSA-Project/internal/interfaces/http.OrderDetailHandler.DeleteOrderDetail-fm (4 handlers)
// [GIN-debug] GET    /orderdetails/:id         --> MSA-Project/internal/interfaces/http.OrderDetailHandler.GetOrderDetailByID-fm (4 handlers)
