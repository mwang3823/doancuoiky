// [GIN-debug] GET    /feedbacks/:id            --> MSA-Project/internal/interfaces/http.FeedbackHandler.GetFeedbackByID-fm (3 handlers)
// [GIN-debug] POST   /feedbacks/               --> MSA-Project/internal/interfaces/http.FeedbackHandler.CreateFeedback-fm (4 handlers)
// [GIN-debug] PUT    /feedbacks/:id            --> MSA-Project/internal/interfaces/http.FeedbackHandler.UpdateFeedback-fm (4 handlers)
// [GIN-debug] DELETE /feedbacks/:id            --> MSA-Project/internal/interfaces/http.FeedbackHandler.DeleteFeedback-fm (4 handlers)
// [GIN-debug] GET    /feedbacks/product/:product_id --> MSA-Project/internal/interfaces/http.FeedbackHandler.GetAllFeedbacksByProductID-fm (4 handlers)
import 'package:dio/dio.dart';
import 'package:doancuoiky/Config/CustomInterceptor.dart';
import 'package:doancuoiky/Config/Storage.dart';
import 'package:doancuoiky/Models/Order.dart';

class Feedback {
  static final String url="http://192.168.1.4:8181";
  final _dio = Dio(BaseOptions(
      baseUrl: url,
      headers: {'Content_Type': 'application/json'}))
    ..interceptors.add(CustomInterceptor());
  final _storage = Storage();

  Future<FeedBackModel?> createFeedback(FeedBackModel feedBack) async {
    try {
      final response = await _dio.post(
        '/feedbacks/',
        options: Options(
            headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
        data: {
          'rating': feedBack.rating,
          'comments': feedBack.comment,
          'user_id': feedBack.userId,
          'product_id': feedBack.productId,
        },
      );
      if (response.statusCode == 200) {
        final data = FeedBackModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return null;
  }

  Future<FeedBackModel?> updateFeedback(FeedBackModel feedBack) async {
    try {
      final response = await _dio.put(
        '/feedbacks/${feedBack.feedBackId}',
        options: Options(
            headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
        data: {
          'rating': feedBack.rating,
          'comments': feedBack.comment,
          'user_id': feedBack.userId,
          'product_id': feedBack.productId,
        },
      );
      if (response.statusCode == 200) {
        final data = FeedBackModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return null;
  }

  Future<bool> deleteFeedback(String feedBackId) async {
    try {
      final response = await _dio.delete(
        '/feedbacks/$feedBackId',
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

  Future<FeedBackModel?> getFeedbackByID(String feedBackId) async {
    try {
      final response = await _dio.get(
        '/products/$feedBackId',
        options: Options(
            headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
      );
      if (response.statusCode == 200) {
        final data = FeedBackModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return null;
  }

  Future<List<FeedBackModel>> getAllFeedbacksByProductID(String productId) async {
    try {
      final response = await _dio.get(
        '/feedbacks/product/$productId',
        options: Options(
            headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
      );
      if (response.statusCode == 200) {
        final List<dynamic> list = response.data;
        final data = list
            .map(
              (e) => FeedBackModel.fromJson(e),
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