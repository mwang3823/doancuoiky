// [GIN-debug] GET    /promocodes/:id           --> MSA-Project/internal/interfaces/http.PromoCodeHandler.GetPromoCodeByID-fm (3 handlers)
// [GIN-debug] POST   /promocodes/              --> MSA-Project/internal/interfaces/http.PromoCodeHandler.CreatePromoCode-fm (4 handlers)
// [GIN-debug] PUT    /promocodes/:id           --> MSA-Project/internal/interfaces/http.PromoCodeHandler.UpdatePromoCode-fm (4 handlers)
// [GIN-debug] DELETE /promocodes/:id           --> MSA-Project/internal/interfaces/http.PromoCodeHandler.DeletePromoCode-fm (4 handlers)
// [GIN-debug] GET    /promocodes/code/:code    --> MSA-Project/internal/interfaces/http.PromoCodeHandler.GetPromoCodeByCode-fm (4 handlers)
// [GIN-debug] GET    /promocodes/              --> MSA-Project/internal/interfaces/http.PromoCodeHandler.GetAllPromocodes-fm (4 handlers)
import 'package:dio/dio.dart';
import 'package:doancuoiky/Config/CustomInterceptor.dart';
import 'package:doancuoiky/Config/Storage.dart';
import 'package:doancuoiky/Models/Order.dart';

class PromoCodeService {
  static final String url="http://192.168.1.4:8181";
  final _dio = Dio(BaseOptions(
      baseUrl: url,
      headers: {'Content_Type': 'application/json'}))
    ..interceptors.add(CustomInterceptor());
  final _storage = Storage();

  Future<PromoCodeModel?> createPromoCode(PromoCodeModel promoCode) async {
    try {
      final response = await _dio.post(
        '/promocodes/',
        options: Options(
            headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
        data: {
          'name': promoCode.name,
          'code': promoCode.code,
          'description': promoCode.description,
          'startdate': promoCode.startDate,
          'enddate': promoCode.endDate,
          'status': promoCode.status,
          'discounttype': promoCode.discountType,
          'discountpercentage': promoCode.discountPercentage,
          'minimumordervalue': promoCode.minimumOrderValue,
        },
      );
      if (response.statusCode == 200) {
        final data = PromoCodeModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return null;
  }

  Future<PromoCodeModel?> updatePromoCode(PromoCodeModel promoCode) async {
    try {
      final response = await _dio.put(
        '/promocodes/${promoCode.promoCodeId}',
        options: Options(
            headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
        data: {
          'name': promoCode.name,
          'code': promoCode.code,
          'description': promoCode.description,
          'startdate': promoCode.startDate,
          'enddate': promoCode.endDate,
          'status': promoCode.status,
          'discounttype': promoCode.discountType,
          'discountpercentage': promoCode.discountPercentage,
          'minimumordervalue': promoCode.minimumOrderValue,
        },
      );
      if (response.statusCode == 200) {
        final data = PromoCodeModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return null;
  }

  Future<bool> deletePromoCode(String id) async {
    try {
      final response = await _dio.delete(
        '/promocodes/$id',
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

  Future<PromoCodeModel?> getPromoCodeByCode(String code) async {
    try {
      final response = await _dio.get(
        '/promocodes/code/$code',
        options: Options(
            headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
      );
      if (response.statusCode == 200) {
        final data = PromoCodeModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return null;
  }

  Future<List<PromoCodeModel>> getAllPromocodes() async {
    try {
      final response = await _dio.get(
        '/promocodes/',
        options: Options(
            headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
      );
      if (response.statusCode == 200) {
        final List<dynamic> list = response.data;
        final data = list
            .map(
              (e) => PromoCodeModel.fromJson(e),
        )
            .toList();
        return data;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return [];
  }

  Future<PromoCodeModel?> getPromoCodeByID(String promoCodeId) async {
    try {
      final response =
      await _dio.get('/promocodes/$promoCodeId',
        options: Options(
            headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),);
      if (response.statusCode == 200) {
        final data = PromoCodeModel.fromJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return null;
  }
}