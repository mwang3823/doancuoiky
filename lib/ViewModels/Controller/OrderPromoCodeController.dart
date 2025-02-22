import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';

import '../../Models/Order.dart';
import '../Service/OrderPromoCode.dart';

// Provider cho OrderPromoCodeService
final orderPromoCodeServiceProvider = Provider<OrderPromoCodeService>((ref) => OrderPromoCodeService());

// Provider cho OrderPromoCodeModel
final orderPromoCodeProvider = StateNotifierProvider<OrderPromoCodeController, AsyncValue<OrderPromoCodeModel?>>((ref) {
  final service = ref.read(orderPromoCodeServiceProvider);
  return OrderPromoCodeController(service);
});

// StateProvider kiểm tra thành công hay thất bại
final isSuccessProvider = StateProvider<bool>((ref) => false);

// Controller xử lý OrderPromoCodeModel
class OrderPromoCodeController extends StateNotifier<AsyncValue<OrderPromoCodeModel?>> {
  final OrderPromoCodeService service;

  OrderPromoCodeController(this.service) : super(const AsyncValue.data(null));

  // Tạo OrderPromoCode
  Future<void> createOrderPromoCode(OrderPromoCodeModel orderPromoCode) async {
    try {
      state = const AsyncLoading();
      final data = await service.createOrderPromoCode(orderPromoCode);
      if (data != null) {
        state = AsyncData(data);
      } else {
        state = AsyncError("Không thể tạo mã khuyến mãi cho đơn hàng", StackTrace.current);
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi tạo mã khuyến mãi: $e");
      state = AsyncError(e, stackTrace);
    }
  }

  // Xóa OrderPromoCode
  Future<void> deleteOrderPromoCode(String orderPromoCodeId, WidgetRef ref) async {
    try {
      state = const AsyncLoading();
      ref.read(isSuccessProvider.notifier).state = false;

      final success = await service.deleteOrderPromoCode(orderPromoCodeId);
      if (success) {
        ref.read(isSuccessProvider.notifier).state = true;
      } else {
        state = AsyncError("Không thể xóa mã khuyến mãi", StackTrace.current);
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi xóa mã khuyến mãi: $e");
      state = AsyncError(e, stackTrace);
    }
  }

  // Lấy OrderPromoCode theo ID
  Future<void> getOrderPromoCodeByID(String orderPromoCodeId) async {
    try {
      state = const AsyncLoading();
      final data = await service.getOrderPromoCodeByID(orderPromoCodeId);
      if (data != null) {
        state = AsyncData(data);
      } else {
        state = AsyncError("Không thể lấy mã khuyến mãi", StackTrace.current);
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi lấy mã khuyến mãi: $e");
      state = AsyncError(e, stackTrace);
    }
  }
}
