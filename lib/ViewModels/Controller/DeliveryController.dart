import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import '../../Models/Order.dart';
import '../Service/FeedBackService.dart';


// Provider cho FeedbackService
final feedbackServiceProvider = Provider<FeedbackService>((ref) => FeedbackService());

// Provider cho FeedBackModel
final feedbackProvider = StateNotifierProvider<FeedbackController, AsyncValue<List<FeedBackModel>>>((ref) {
  final service = ref.read(feedbackServiceProvider);
  return FeedbackController(service);
});

// Controller xử lý Feedback
class FeedbackController extends StateNotifier<AsyncValue<List<FeedBackModel>>> {
  final FeedbackService service;

  FeedbackController(this.service) : super(const AsyncValue.data([]));

  // Lấy tất cả feedbacks theo productId
  Future<void> fetchFeedbacks(String productId) async {
    try {
      state = const AsyncLoading();
      final data = await service.getAllFeedbacksByProductID(productId);
      state = AsyncData(data);
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi lấy danh sách phản hồi: $e");
      state = AsyncError(e, stackTrace);
    }
  }

  // Tạo feedback
  Future<void> createFeedback(FeedBackModel feedback) async {
    try {
      state = const AsyncLoading();
      final newFeedback = await service.createFeedback(feedback);
      if (newFeedback != null) {
        state = AsyncData([...state.value ?? [], newFeedback]);
      } else {
        state = AsyncError("Không thể tạo phản hồi", StackTrace.current);
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi tạo phản hồi: $e");
      state = AsyncError(e, stackTrace);
    }
  }

  // Cập nhật feedback
  Future<void> updateFeedback(FeedBackModel feedback) async {
    try {
      state = const AsyncLoading();
      final updatedFeedback = await service.updateFeedback(feedback);
      if (updatedFeedback != null) {
        state = AsyncData(state.value!.map((f) => f.feedBackId == feedback.feedBackId ? updatedFeedback : f).toList());
      } else {
        state = AsyncError("Không thể cập nhật phản hồi", StackTrace.current);
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi cập nhật phản hồi: $e");
      state = AsyncError(e, stackTrace);
    }
  }

  // Xóa feedback
  Future<void> deleteFeedback(String feedbackId) async {
    try {
      state = const AsyncLoading();
      final success = await service.deleteFeedback(feedbackId);
      if (success) {
        state = AsyncData(state.value!.where((f) => f.feedBackId != feedbackId).toList());
      } else {
        state = AsyncError("Không thể xóa phản hồi", StackTrace.current);
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi xóa phản hồi: $e");
      state = AsyncError(e, stackTrace);
    }
  }
}
