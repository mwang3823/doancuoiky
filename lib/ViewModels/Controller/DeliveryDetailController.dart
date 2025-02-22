import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import '../../Models/Delivery.dart';
import '../Service/DeliveryDetail.dart';

// Provider cho DeliveryDetailService
final deliveryDetailServiceProvider = Provider<DeliveryDetailService>((ref) => DeliveryDetailService());

// Provider cho DeliveryDetailModel
final deliveryDetailProvider = StateNotifierProvider<DeliveryDetailController, AsyncValue<List<DeliveryDetailModel>>>((ref) {
  final service = ref.read(deliveryDetailServiceProvider);
  return DeliveryDetailController(service);
});

// Controller xử lý DeliveryDetail
class DeliveryDetailController extends StateNotifier<AsyncValue<List<DeliveryDetailModel>>> {
  final DeliveryDetailService service;

  DeliveryDetailController(this.service) : super(const AsyncValue.data([]));

  // Lấy tất cả chi tiết giao hàng
  Future<void> fetchAllDeliveryDetails() async {
    try {
      state = const AsyncLoading();
      final data = await service.GetAllDeliveryDetails();
      state = AsyncData(data ?? []);
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi lấy danh sách chi tiết giao hàng: $e");
      state = AsyncError(e, stackTrace);
    }
  }

  // Lấy chi tiết giao hàng theo deliveryId
  Future<void> fetchDeliveryDetailsByDeliveryID(String deliveryId) async {
    try {
      state = const AsyncLoading();
      final data = await service.getAllDeliveryDetailsByDeliveryID(deliveryId);
      state = AsyncData(data ?? []);
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi lấy chi tiết giao hàng theo deliveryId: $e");
      state = AsyncError(e, stackTrace);
    }
  }

  // Tạo chi tiết giao hàng
  Future<void> createDeliveryDetail(DeliveryDetailModel deliveryDetail) async {
    try {
      state = const AsyncLoading();
      final newDetail = await service.createDeliveryDetail(deliveryDetail);
      if (newDetail != null) {
        state = AsyncData([...state.value ?? [], newDetail]);
      } else {
        state = AsyncError("Không thể tạo chi tiết giao hàng", StackTrace.current);
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi tạo chi tiết giao hàng: $e");
      state = AsyncError(e, stackTrace);
    }
  }

  // Cập nhật chi tiết giao hàng
  Future<void> updateDeliveryDetail(DeliveryDetailModel deliveryDetail) async {
    try {
      state = const AsyncLoading();
      final updatedDetail = await service.updateDeliveryDetail(deliveryDetail);
      if (updatedDetail != null) {
        state = AsyncData(state.value!.map((d) => d.deliveryDetailId == deliveryDetail.deliveryDetailId ? updatedDetail : d).toList());
      } else {
        state = AsyncError("Không thể cập nhật chi tiết giao hàng", StackTrace.current);
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi cập nhật chi tiết giao hàng: $e");
      state = AsyncError(e, stackTrace);
    }
  }

  // Xóa chi tiết giao hàng
  Future<void> deleteDeliveryDetail(String deliveryDetailId) async {
    try {
      state = const AsyncLoading();
      final success = await service.deleteDeliveryDetail(deliveryDetailId);
      if (success) {
        state = AsyncData(state.value!.where((d) => d.deliveryDetailId != deliveryDetailId).toList());
      } else {
        state = AsyncError("Không thể xóa chi tiết giao hàng", StackTrace.current);
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi xóa chi tiết giao hàng: $e");
      state = AsyncError(e, stackTrace);
    }
  }
}
