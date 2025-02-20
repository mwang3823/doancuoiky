// [GIN-debug] POST   /deliverydetails/         --> MSA-Project/internal/interfaces/http.DeliveryDetailHandler.CreateDeliveryDetail-fm (4 handlers)
// [GIN-debug] PUT    /deliverydetails/:id      --> MSA-Project/internal/interfaces/http.DeliveryDetailHandler.UpdateDeliveryDetail-fm (4 handlers)
// [GIN-debug] DELETE /deliverydetails/:id      --> MSA-Project/internal/interfaces/http.DeliveryDetailHandler.DeleteDeliveryDetail-fm (4 handlers)
// [GIN-debug] GET    /deliverydetails/:id      --> MSA-Project/internal/interfaces/http.DeliveryDetailHandler.GetDeliveryDetailByID-fm (4 handlers)
// [GIN-debug] GET    /deliverydetails/         --> MSA-Project/internal/interfaces/http.DeliveryDetailHandler.GetAllDeliveryDetails-fm (4 handlers)
// [GIN-debug] GET    /deliverydetails/delivery/:delivery_id --> MSA-Project/internal/interfaces/http.DeliveryDetailHandler.GetAllDeliveryDetailsByDeliveryID-fm (4 handlers)
import 'package:dio/dio.dart';
import 'package:doancuoiky/Config/CustomInterceptor.dart';
import 'package:doancuoiky/Config/Storage.dart';
import 'package:doancuoiky/Models/Delivery.dart';
class Payment {
  static final String url = "http://192.168.1.4:8181";
  final _storage = Storage();
  final _dio = Dio(
      BaseOptions(baseUrl: url, headers: {'Content-Type': 'application/json'}))
    ..interceptors.add(CustomInterceptor());

  Future<DeliveryDetailModel?> createDeliveryDetail(DeliveryDetailModel deliveryDetail) async {
    try {
      final response = await _dio.post('/deliverydetails/',
          options: Options(
              headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
          data: {
            'deliveryname': deliveryDetail.deliveryName,
            'shipcode': deliveryDetail.shipCode,
            'description': deliveryDetail.description,
            'weight': deliveryDetail.weight,
            'deliveryaddress': deliveryDetail.deliveryAddress,
            'deliverycontact': deliveryDetail.deliveryContact,
            'deliveryfee': deliveryDetail.deliveryFee,
            'delivery_id': deliveryDetail.deliveryId,
          });

      if (response.statusCode == 200) {
        final data = DeliveryDetailModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return null;
  }

  Future<DeliveryDetailModel?> updateDeliveryDetail(DeliveryDetailModel deliveryDetail) async {
    try {
      final response = await _dio.put('/deliverydetails/${deliveryDetail.deliveryDetailId}',
          options: Options(
              headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
          data: {
            'deliveryname': deliveryDetail.deliveryName,
            'shipcode': deliveryDetail.shipCode,
            'description': deliveryDetail.description,
            'weight': deliveryDetail.weight,
            'deliveryaddress': deliveryDetail.deliveryAddress,
            'deliverycontact': deliveryDetail.deliveryContact,
            'deliveryfee': deliveryDetail.deliveryFee,
            'delivery_id': deliveryDetail.deliveryId,
          });
      if (response.statusCode == 200) {
        final data = DeliveryDetailModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return null;
  }

  Future<bool> deleteDeliveryDetail(String deliveryDetailId) async {
    try {
      final response = await _dio.delete('/deliverydetails/$deliveryDetailId',
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

  Future<DeliveryDetailModel?> getDeliveryDetailByID(String deliveryDetailId) async {
    try {
      final response = await _dio.get('/deliverydetails/$deliveryDetailId',
          options: Options(
              headers: {'Authorization': 'Bearer ${_storage.read('token')}'}));
      if (response.statusCode == 200) {
        final data = DeliveryDetailModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return null;
  }

  Future<List<DeliveryDetailModel>?> GetAllDeliveryDetails() async {
    try {
      final response = await _dio.get('/deliverydetails/',
          options: Options(
              headers: {'Authorization': 'Bearer ${_storage.read('token')}'}));
      if (response.statusCode == 200) {
        final List<dynamic> list = response.data;
        final data = list
            .map(
              (e) => DeliveryDetailModel.fromJson(e),
        )
            .toList();
        return data;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return null;
  }

  Future<List<DeliveryDetailModel>?> getAllDeliveryDetailsByDeliveryID(String deliveryDetailId) async {
    try {
      final response = await _dio.get('/deliverydetails/delivery/$deliveryDetailId',
          options: Options(
              headers: {'Authorization': 'Bearer ${_storage.read('token')}'}));
      if (response.statusCode == 200) {
        final List<dynamic> list = response.data;
        final data = list
            .map(
              (e) => DeliveryDetailModel.fromJson(e),
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