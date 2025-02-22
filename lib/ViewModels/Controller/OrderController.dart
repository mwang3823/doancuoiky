import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import '../../Models/Order.dart';
import '../Service/OrderService.dart';

// Provider cho OrderService
final orderServiceProvider = Provider<OrderService>((ref) => OrderService());

// StateProvider kiểm tra thành công hay thất bại
final isSuccessProvider = StateProvider<bool>((ref) => false);

// Provider cho OrderModel
final orderProvider = StateNotifierProvider<OrderController, AsyncValue<OrderModel?>>((ref) {
  final service = ref.read(orderServiceProvider);
  return OrderController(service, ref);
});

// Provider cho danh sách OrderModel
final listOrderProvider = StateNotifierProvider<ListOrderController, AsyncValue<List<OrderModel>>>((ref) {
  final service = ref.read(orderServiceProvider);
  return ListOrderController(service);
});

// Controller xử lý từng OrderModel
class OrderController extends StateNotifier<AsyncValue<OrderModel?>> {
  final OrderService service;
  final Ref ref;

  OrderController(this.service, this.ref) : super(const AsyncValue.data(null));

  // Tạo Order
  Future<void> createOrder(OrderModel order, String userId, String cartId, String promoCode) async {
    try {
      state = const AsyncLoading();
      final data = await service.createOrder(order, userId, cartId, promoCode);
      if (data != null) {
        state = AsyncData(data);
        ref.read(listOrderProvider.notifier).getOrdersByStatus(userId, "all"); // Cập nhật danh sách
      } else {
        state = AsyncError("Không thể tạo đơn hàng", StackTrace.current);
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi tạo đơn hàng: $e");
      state = AsyncError(e, stackTrace);
    }
  }

  // Cập nhật Order
  Future<void> updateOrder(OrderModel order) async {
    try {
      state = const AsyncLoading();
      final data = await service.updateOrder(order);
      if (data != null) {
        state = AsyncData(data);
        ref.read(listOrderProvider.notifier).getOrdersByStatus(order.userId, "all"); // Cập nhật danh sách
      } else {
        state = AsyncError("Không thể cập nhật đơn hàng", StackTrace.current);
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi cập nhật đơn hàng: $e");
      state = AsyncError(e, stackTrace);
    }
  }

  // Lấy Order theo ID
  Future<void> getOrderById(String id) async {
    try {
      state = const AsyncLoading();
      final data = await service.getOrderById(id);
      if (data != null) {
        state = AsyncData(data);
      } else {
        state = AsyncError("Không thể lấy đơn hàng", StackTrace.current);
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi lấy đơn hàng: $e");
      state = AsyncError(e, stackTrace);
    }
  }

  // Xóa Order
  Future<void> deleteOrder(String id) async {
    try {
      state = const AsyncLoading();
      ref.read(isSuccessProvider.notifier).state = false;

      final success = await service.deleteOrder(id);
      if (success) {
        ref.read(isSuccessProvider.notifier).state = true;
        ref.read(listOrderProvider.notifier).getOrdersByStatus("all", "all"); // Cập nhật danh sách
      } else {
        state = AsyncError("Không thể xóa đơn hàng", StackTrace.current);
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi xóa đơn hàng: $e");
      state = AsyncError(e, stackTrace);
    }
  }
}

// Controller quản lý danh sách Orders
class ListOrderController extends StateNotifier<AsyncValue<List<OrderModel>>> {
  final OrderService service;

  ListOrderController(this.service) : super(const AsyncValue.data([]));

  // Lấy danh sách đơn hàng theo trạng thái
  Future<void> getOrdersByStatus(String userId, String status) async {
    try {
      state = const AsyncLoading();
      final data = await service.getOrdersByStatus(userId, status);
      state = AsyncData(data);
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi lấy danh sách đơn hàng: $e");
      state = AsyncError(e, stackTrace);
    }
  }

  // Tìm kiếm đơn hàng theo số điện thoại
  Future<void> searchOrderByPhoneNumber(String numberPhone) async {
    try {
      state = const AsyncLoading();
      final data = await service.searchOrderByPhoneNumber(numberPhone);
      state = AsyncData(data);
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi tìm kiếm đơn hàng: $e");
      state = AsyncError(e, stackTrace);
    }
  }
}
