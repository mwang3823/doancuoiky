import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import '../Service/CartService.dart';
import '../../Models/Cart.dart';

// Provider cho CartService
final cartServiceProvider = Provider<CartService>((ref) => CartService());

// Provider cho CartModel
final cartProvider = StateNotifierProvider<CartController, AsyncValue<CartModel?>>((ref) {
  final service = ref.read(cartServiceProvider);
  return CartController(service);
});

// Controller xử lý Cart
class CartController extends StateNotifier<AsyncValue<CartModel?>> {
  final CartService service;

  CartController(this.service) : super(const AsyncValue.data(null));

  // Lấy hoặc tạo giỏ hàng cho người dùng
  Future<void> getOrCreateCart(String userId) async {
    try {
      state = const AsyncLoading();
      final cart = await service.getOrCreateCartForUser(userId);
      state = AsyncData(cart);
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi lấy hoặc tạo giỏ hàng: $e");
      state = AsyncError(e, stackTrace);
    }
  }

  // Tạo giỏ hàng mới
  Future<void> createCart(CartModel cart, String userId) async {
    try {
      state = const AsyncLoading();
      final newCart = await service.createCategory(cart, userId);
      state = AsyncData(newCart);
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi tạo giỏ hàng: $e");
      state = AsyncError(e, stackTrace);
    }
  }

  // Xóa giỏ hàng
  Future<void> deleteCart(String cartId) async {
    try {
      state = const AsyncLoading();
      final success = await service.deleteCategory(cartId);
      if (success) {
        state = const AsyncData(null);
      } else {
        state = AsyncError("Không thể xóa giỏ hàng", StackTrace.current);
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi xóa giỏ hàng: $e");
      state = AsyncError(e, stackTrace);
    }
  }
}
