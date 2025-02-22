// [GIN-debug] POST   /orderpromocodes/         --> MSA-Project/internal/interfaces/http.OrderPromoCodeHandler.CreateOrderPromoCode-fm (4 handlers)
// [GIN-debug] DELETE /orderpromocodes/:id      --> MSA-Project/internal/interfaces/http.OrderPromoCodeHandler.DeleteOrderPromoCode-fm (4 handlers)
// [GIN-debug] GET    /orderpromocodes/:id      --> MSA-Project/internal/interfaces/http.OrderPromoCodeHandler.GetOrderPromoCodeByID-fm (4 handlers)
import 'package:dio/dio.dart';
import 'package:doancuoiky/Config/CustomInterceptor.dart';
import 'package:doancuoiky/Config/Storage.dart';
import 'package:doancuoiky/Models/Order.dart';

class OrderPromoCodeService {
  static final String url = "http://192.168.1.4:8181";
  final _storage = Storage();
  final _dio = Dio(
      BaseOptions(baseUrl: url, headers: {'Content-Type': 'application/json'}))
    ..interceptors.add(CustomInterceptor());

  Future<OrderPromoCodeModel?> createOrderPromoCode(
      OrderPromoCodeModel orderPromoCode) async {
    try {
      final response = await _dio.post('/orderpromocodes/',
          options: Options(
              headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
          data: {
            'order_id': orderPromoCode.orderId,
            'promocode_id': orderPromoCode.promoCodeID,
          });

      if (response.statusCode == 200) {
        final data = OrderPromoCodeModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return null;
  }

  Future<bool> deleteOrderPromoCode(String orderPromoCodeId) async {
    try {
      final response = await _dio.delete('/orderdetails/$orderPromoCodeId',
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

  Future<OrderPromoCodeModel?> getOrderPromoCodeByID(String orderPromoCodeId) async {
    try {
      final response = await _dio.get('/orderpromocodes/$orderPromoCodeId',
          options: Options(
              headers: {'Authorization': 'Bearer ${_storage.read('token')}'}));
      if (response.statusCode == 200) {
        final data = OrderPromoCodeModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return null;
  }
}