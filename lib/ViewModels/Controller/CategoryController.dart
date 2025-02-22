import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import '../../Models/Product.dart';
import '../Service/CategoryService.dart';

// Provider cho CategoryService
final categoryServiceProvider = Provider<CategoryService>((ref) => CategoryService());

// Provider cho CategoryModel
final categoryProvider = StateNotifierProvider<CategoryController, AsyncValue<List<CategoryModel>>>((ref) {
  final service = ref.read(categoryServiceProvider);
  return CategoryController(service);
});

// Controller xử lý Category
class CategoryController extends StateNotifier<AsyncValue<List<CategoryModel>>> {
  final CategoryService service;

  CategoryController(this.service) : super(const AsyncValue.data([]));

  // Lấy tất cả danh mục
  Future<void> fetchAllCategories() async {
    try {
      state = const AsyncLoading();
      final data = await service.getAllCategory();
      state = AsyncData(data ?? []);
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi lấy danh sách danh mục: $e");
      state = AsyncError(e, stackTrace);
    }
  }

  // Tạo danh mục mới
  Future<void> createCategory(CategoryModel category) async {
    try {
      state = const AsyncLoading();
      final newCategory = await service.createCategory(category);
      if (newCategory != null) {
        state = AsyncData([...state.value ?? [], newCategory]);
      } else {
        state = AsyncError("Không thể tạo danh mục", StackTrace.current);
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi tạo danh mục: $e");
      state = AsyncError(e, stackTrace);
    }
  }

  // Cập nhật danh mục
  Future<void> updateCategory(CategoryModel category) async {
    try {
      state = const AsyncLoading();
      final updatedCategory = await service.updateCategory(category);
      if (updatedCategory != null) {
        state = AsyncData(state.value!.map((c) => c.categoryId == category.categoryId ? updatedCategory : c).toList());
      } else {
        state = AsyncError("Không thể cập nhật danh mục", StackTrace.current);
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi cập nhật danh mục: $e");
      state = AsyncError(e, stackTrace);
    }
  }

  // Xóa danh mục
  Future<void> deleteCategory(String categoryId) async {
    try {
      state = const AsyncLoading();
      final success = await service.deleteCategory(categoryId);
      if (success) {
        state = AsyncData(state.value!.where((c) => c.categoryId != categoryId).toList());
      } else {
        state = AsyncError("Không thể xóa danh mục", StackTrace.current);
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi xóa danh mục: $e");
      state = AsyncError(e, stackTrace);
    }
  }
}
