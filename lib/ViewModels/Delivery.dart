// [GIN-debug] POST   /deliveries/:user_id/:order_id --> MSA-Project/internal/interfaces/http.DeliveryHandler.CreateDelivery-fm (4 handlers)
// [GIN-debug] PUT    /deliveries/:id           --> MSA-Project/internal/interfaces/http.DeliveryHandler.UpdateDelivery-fm (4 handlers)
// [GIN-debug] DELETE /deliveries/:id           --> MSA-Project/internal/interfaces/http.DeliveryHandler.DeleteDelivery-fm (4 handlers)
// [GIN-debug] GET    /deliveries/:id           --> MSA-Project/internal/interfaces/http.DeliveryHandler.c-fm (4 handlers)
import 'package:dio/dio.dart';
import 'package:doancuoiky/Config/CustomInterceptor.dart';
import 'package:doancuoiky/Config/Storage.dart';
import 'package:doancuoiky/Models/Delivery.dart';
class Delivery {
  static final String url = "http://192.168.1.4:8181";
  final _storage = Storage();
  final _dio = Dio(
      BaseOptions(baseUrl: url, headers: {'Content-Type': 'application/json'}))
    ..interceptors.add(CustomInterceptor());

  Future<DeliveryModel?> createDelivery(DeliveryModel delivery, String userId, String orderId) async {
    try {
      final response = await _dio.post('/deliveries/$userId/$orderId',
          options: Options(
              headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
          data: {
            'status': delivery.status,
            'order_id': delivery.orderId,
            'user_id': delivery.userId,
          });

      if (response.statusCode == 200) {
        final data = DeliveryModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return null;
  }

  Future<DeliveryModel?> updateDelivery(DeliveryModel delivery) async {
    try {
      final response = await _dio.put('/deliveries/${delivery.deliveryId}',
          options: Options(
              headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
          data: {
            'status': delivery.status,
            'order_id': delivery.orderId,
            'user_id': delivery.userId,
          });
      if (response.statusCode == 200) {
        final data = DeliveryModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return null;
  }

  Future<bool> deleteDelivery(String deliveryId) async {
    try {
      final response = await _dio.delete('/deliveries/$deliveryId',
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

  Future<DeliveryModel?> getDeliveryByID(String deliveryId) async {
    try {
      final response = await _dio.get('/deliveries/$deliveryId',
          options: Options(
              headers: {'Authorization': 'Bearer ${_storage.read('token')}'}));
      if (response.statusCode == 200) {
        final data = DeliveryModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return null;
  }
}