import 'package:doancuoiky/Models/Order.dart';
import 'package:doancuoiky/ViewModels/Service/PromoCodeService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final promoCodeServce = Provider<PromoCodeService>((ref) => PromoCodeService());

final isSuccess = StateProvider<bool>((ref) => false);

final promoCodeProvider =
    StateNotifierProvider<PromoCodeController, AsyncValue<PromoCodeModel?>>(
        (ref) {
  final service = ref.watch(promoCodeServce);
  return PromoCodeController(service);
});

final listPromoCodeProvider = StateNotifierProvider<ListPromoCodeController,
    AsyncValue<List<PromoCodeModel?>>>((ref) {
  final service = ref.watch(promoCodeServce);
  return ListPromoCodeController(service);
});

class PromoCodeController extends StateNotifier<AsyncValue<PromoCodeModel?>> {
  final PromoCodeService service;

  PromoCodeController(this.service) : super(AsyncValue.data(null));

  Future<void> createPromoCode(PromoCodeModel promoCode,WidgetRef ref) async {
    try {
      state = AsyncValue.loading();
      final data = await service.createPromoCode(promoCode);
      if (data != null) {
        state = AsyncValue.data(data);
        ref.read(listPromoCodeProvider.notifier).getAllPromocodes();
      } else {
        state =
            AsyncValue.error("Không thể tạo mã giảm giá", StackTrace.current);
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi tạo mã giảm giá $e");
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updatePromoCode(PromoCodeModel promoCode, WidgetRef ref) async {
    try {
      state = AsyncValue.loading();
      final data = await service.updatePromoCode(promoCode);
      if (data == null) {
        state = AsyncValue.error(
            "Không thể cập nhật mã giảm giá", StackTrace.current);
      } else {
        ref.read(listPromoCodeProvider.notifier).getAllPromocodes();
        state = AsyncValue.data(data);
      }
    } catch (e, stackTrace) {
      debugPrint("Không thể cập nhật mã giảm giá $e");
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deletePromocode(String promoCodeId, WidgetRef ref) async {
    try {
      state = AsyncValue.loading();
      ref.read(isSuccess.notifier).state = false;
      final data = await service.deletePromoCode(promoCodeId);
      if (data) {
        ref.read(listPromoCodeProvider.notifier).getAllPromocodes();
        ref.read(isSuccess.notifier).state = true;
      } else {
        state =
            AsyncValue.error("Không thể xóa mã giảm giá", StackTrace.current);
      }
    } catch (e, stackTrace) {
      debugPrint("Không thể xóa mã giảm giá $e");
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> getPromoCodeByCode(String code) async {
    try {
      state = AsyncValue.loading();
      final data = await service.getPromoCodeByCode(code);
      state = AsyncValue.data(data);
    } catch (e, stackTrace) {
      debugPrint("Không thể lấy mã giảm giá theo code $e");
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> getPromoCodeByID(String promoCodeId) async {
    try {
      state = AsyncValue.loading();
      final data = await service.getPromoCodeByID(promoCodeId);
      state = AsyncValue.data(data);
    } catch (e, stackTrace) {
      debugPrint("Không thể lấy mã giảm giá theo ID $e");
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

class ListPromoCodeController
    extends StateNotifier<AsyncValue<List<PromoCodeModel?>>> {
  final PromoCodeService service;

  ListPromoCodeController(this.service) : super(AsyncValue.data([]));

  Future<void> getAllPromocodes() async {
    try {
      state = AsyncValue.loading();
      final data = await service.getAllPromocodes();
      state = AsyncValue.data(data);
    } catch (e, stackTrace) {
      debugPrint("Không thể lấy mã giảm giá");
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
