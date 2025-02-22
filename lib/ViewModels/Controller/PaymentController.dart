import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import '../../Models/Order.dart';
import '../Service/PaymentService.dart';

final paymentServiceProvider = Provider<PaymentService>((ref) => PaymentService());

final isSuccessProvider = StateProvider<bool>((ref) => false);

final paymentProvider = StateNotifierProvider<PaymentController, AsyncValue<PaymentModel?>>((ref) {
  final service = ref.read(paymentServiceProvider);
  return PaymentController(service, ref);
});

final listPaymentProvider = StateNotifierProvider<ListPaymentController, AsyncValue<List<PaymentModel>>>((ref) {
  final service = ref.read(paymentServiceProvider);
  return ListPaymentController(service);
});

// Controller xử lý từng PaymentModel
class PaymentController extends StateNotifier<AsyncValue<PaymentModel?>> {
  final PaymentService service;
  final Ref ref;

  PaymentController(this.service, this.ref) : super(const AsyncValue.data(null));

  // Tạo Payment
  Future<void> createPayment(PaymentModel payment, String userId, String orderId) async {
    try {
      state = const AsyncLoading();
      final data = await service.createPayment(payment, userId, orderId);
      if (data != null) {
        state = AsyncData(data);
        ref.read(listPaymentProvider.notifier).getAllPayments(); // Cập nhật danh sách sau khi thêm
      } else {
        state = AsyncError("Không thể tạo thanh toán", StackTrace.current);
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi tạo thanh toán: $e");
      state = AsyncError(e, stackTrace);
    }
  }

  // Cập nhật Payment
  Future<void> updatePayment(PaymentModel payment) async {
    try {
      state = const AsyncLoading();
      final data = await service.updatePayment(payment);
      if (data != null) {
        state = AsyncData(data);
        ref.read(listPaymentProvider.notifier).getAllPayments(); // Cập nhật danh sách sau khi update
      } else {
        state = AsyncError("Không thể cập nhật thanh toán", StackTrace.current);
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi cập nhật thanh toán: $e");
      state = AsyncError(e, stackTrace);
    }
  }

  // Lấy Payment theo ID
  Future<void> getPaymentById(String id) async {
    try {
      state = const AsyncLoading();
      final data = await service.getPaymentByID(id);
      if (data != null) {
        state = AsyncData(data);
      } else {
        state = AsyncError("Không thể lấy thanh toán", StackTrace.current);
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi lấy thanh toán: $e");
      state = AsyncError(e, stackTrace);
    }
  }

  // Xóa Payment
  Future<void> deletePayment(String id) async {
    try {
      state = const AsyncLoading();
      ref.read(isSuccessProvider.notifier).state = false;

      final success = await service.deletePayment(id);
      if (success) {
        ref.read(isSuccessProvider.notifier).state = true;
        ref.read(listPaymentProvider.notifier).getAllPayments(); // Cập nhật danh sách sau khi xóa
      } else {
        state = AsyncError("Không thể xóa thanh toán", StackTrace.current);
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi xóa thanh toán: $e");
      state = AsyncError(e, stackTrace);
    }
  }
}

// Controller quản lý danh sách Payments
class ListPaymentController extends StateNotifier<AsyncValue<List<PaymentModel>>> {
  final PaymentService service;

  ListPaymentController(this.service) : super(const AsyncValue.data([]));

  // Lấy tất cả thanh toán
  Future<void> getAllPayments() async {
    try {
      state = const AsyncLoading();
      final data = await service.getAllPayments();
      state = data != null ? AsyncData(data) : AsyncData([]);
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi lấy danh sách thanh toán: $e");
      state = AsyncError(e, stackTrace);
    }
  }
}
