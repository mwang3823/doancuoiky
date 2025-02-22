import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import '../../Models/Order.dart';
import '../Service/OrderDetail.dart';

// Provider cho OrderDetailService
final orderDetailServiceProvider = Provider<OrderDetailService>((ref) => OrderDetailService());

// Provider cho OrderDetailModel
final orderDetailProvider = StateNotifierProvider<OrderDetailController, AsyncValue<OrderDetailModel?>>((ref) {
  final service = ref.read(orderDetailServiceProvider);
  return OrderDetailController(service);
});

// StateProvider kiểm tra trạng thái thành công
final isSuccessProvider = StateProvider<bool>((ref) => false);

// Controller xử lý OrderDetailModel
class OrderDetailController extends StateNotifier<AsyncValue<OrderDetailModel?>> {
  final OrderDetailService service;

  OrderDetailController(this.service) : super(const AsyncValue.data(null));

  // Tạo OrderDetail
  Future<void> createOrderDetail(OrderDetailModel orderDetail) async {
    try {
      state = const AsyncLoading();
      final data = await service.createOrderDetail(orderDetail);
      if (data != null) {
        state = AsyncData(data);
      } else {
        state = AsyncError("Không thể tạo chi tiết đơn hàng", StackTrace.current);
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi tạo chi tiết đơn hàng: $e");
      state = AsyncError(e, stackTrace);
    }
  }

  // Xóa OrderDetail
  Future<void> deleteOrderDetail(String orderDetailId, WidgetRef ref) async {
    try {
      state = const AsyncLoading();
      ref.read(isSuccessProvider.notifier).state = false;

      final success = await service.deleteCategory(orderDetailId);
      if (success) {
        ref.read(isSuccessProvider.notifier).state = true;
      } else {
        state = AsyncError("Không thể xóa chi tiết đơn hàng", StackTrace.current);
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi xóa chi tiết đơn hàng: $e");
      state = AsyncError(e, stackTrace);
    }
  }

  // Lấy OrderDetail theo ID
  Future<void> getOrderDetailByID(String orderDetailId) async {
    try {
      state = const AsyncLoading();
      final data = await service.getOrderDetailByID(orderDetailId);
      if (data != null) {
        state = AsyncData(data);
      } else {
        state = AsyncError("Không thể lấy chi tiết đơn hàng", StackTrace.current);
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi lấy chi tiết đơn hàng: $e");
      state = AsyncError(e, stackTrace);
    }
  }
}
