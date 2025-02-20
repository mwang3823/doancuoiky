// [GIN-debug] POST   /payments/:user_id/:order_id --> MSA-Project/internal/interfaces/http.PaymentHandler.CreatePayment-fm (4 handlers)
// [GIN-debug] PUT    /payments/:id             --> MSA-Project/internal/interfaces/http.PaymentHandler.UpdatePayment-fm (4 handlers)
// [GIN-debug] DELETE /payments/:id             --> MSA-Project/internal/interfaces/http.PaymentHandler.DeletePayment-fm (4 handlers)
// [GIN-debug] GET    /payments/all             --> MSA-Project/internal/interfaces/http.PaymentHandler.GetAllPayments-fm (4 handlers)
// [GIN-debug] GET    /payments/:id             --> MSA-Project/internal/interfaces/http.PaymentHandler.GetPaymentByID-fm (4 handlers)
import 'package:dio/dio.dart';
import 'package:doancuoiky/Config/CustomInterceptor.dart';
import 'package:doancuoiky/Config/Storage.dart';
import 'package:doancuoiky/Models/Order.dart';
class Payment {
  static final String url = "http://192.168.1.4:8181";
  final _storage = Storage();
  final _dio = Dio(
      BaseOptions(baseUrl: url, headers: {'Content-Type': 'application/json'}))
    ..interceptors.add(CustomInterceptor());

  Future<PaymentModel?> createPayment(PaymentModel payment, String userId, String orderId) async {
    try {
      final response = await _dio.post('/payments/$userId/$orderId',
          options: Options(
              headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
          data: {
        'paymentmethod': payment.paymentMethod,
            'status': payment.status,
            'grandtotal': payment.grandTotal,
            'user_id': payment.userId,
            'order_id': payment.orderId,
      });

      if (response.statusCode == 200) {
        final data = PaymentModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return null;
  }

  Future<PaymentModel?> updatePayment(PaymentModel payment) async {
    try {
      final response = await _dio.put('/payments/${payment.paymentId}',
          options: Options(
              headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
          data: {
            'paymentmethod': payment.paymentMethod,
            'status': payment.status,
            'grandtotal': payment.grandTotal,
          });
      if (response.statusCode == 200) {
        final data = PaymentModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return null;
  }

  Future<bool> deletePayment(String paymentId) async {
    try {
      final response = await _dio.delete('/payments/$paymentId',
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

  Future<PaymentModel?> getPaymentByID(String paymentId) async {
    try {
      final response = await _dio.get('/payments/$paymentId',
          options: Options(
              headers: {'Authorization': 'Bearer ${_storage.read('token')}'}));
      if (response.statusCode == 200) {
        final data = PaymentModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return null;
  }

  Future<List<PaymentModel>?> getAllPayments() async {
    try {
      final response = await _dio.get('/payments/all',
          options: Options(
              headers: {'Authorization': 'Bearer ${_storage.read('token')}'}));
      if (response.statusCode == 200) {
        final List<dynamic> list = response.data;
        final data = list
            .map(
              (e) => PaymentModel.fromJson(e),
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
