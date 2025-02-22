// [GIN-debug] POST   /returnorders/:order_id   --> MSA-Project/internal/interfaces/http.ReturnOrderHandler.CreateReturnOrder-fm (4 handlers)
// [GIN-debug] DELETE /returnorders/:id         --> MSA-Project/internal/interfaces/http.ReturnOrderHandler.DeleteReturnOrder-fm (4 handlers)
// [GIN-debug] GET    /returnorders/all         --> MSA-Project/internal/interfaces/http.ReturnOrderHandler.GetAllReturnOrders-fm (4 handlers)
// [GIN-debug] GET    /returnorders/:id         --> MSA-Project/internal/interfaces/http.ReturnOrderHandler.GetReturnOrderByID-fm (4 handlers)
import 'package:dio/dio.dart';
import 'package:doancuoiky/Config/CustomInterceptor.dart';
import 'package:doancuoiky/Config/Storage.dart';
import 'package:doancuoiky/Models/Order.dart';

class ReturnOrderService {
  static final String url="http://192.168.1.4:8181";
  final _dio = Dio(BaseOptions(
      baseUrl: url,
      headers: {'Content_Type': 'application/json'}))
    ..interceptors.add(CustomInterceptor());
  final _storage = Storage();

  Future<ReturnOrderModel?> createReturnOrder(ReturnOrderModel returnOrder, String orderId) async {
    try {
      final response = await _dio.post(
        '/returnorders/$orderId',
        options: Options(
            headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
        data: {
          'status': returnOrder.status,
          'reason': returnOrder.reason,
          'refundamount': returnOrder.refundAmount,
          'order_id': returnOrder.orderId,
        },
      );
      if (response.statusCode == 200) {
        final data = ReturnOrderModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return null;
  }

  Future<bool> deleteReturnOrder(String returnOrderId) async {
    try {
      final response = await _dio.delete(
        '/returnorders/$returnOrderId',
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

  Future<List<ReturnOrderModel>> getAllReturnOrders() async {
    try {
      final response = await _dio.get(
        '/returnorders/all',
        options: Options(
            headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
      );
      if (response.statusCode == 200) {
        final List<dynamic> list = response.data;
        final data = list
            .map(
              (e) => ReturnOrderModel.fromJson(e),
        )
            .toList();
        return data;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return [];
  }

  Future<ReturnOrderModel?> getReturnOrderByID(String returnOrderId) async {
    try {
      final response = await _dio.get(
        '/returnorders/$returnOrderId',
        options: Options(
            headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
      );
      if (response.statusCode == 200) {
        final data = ReturnOrderModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return null;
  }
}