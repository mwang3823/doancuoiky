import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import '../Service/CartItemService.dart';
import '../../Models/Cart.dart';

// Provider cho CartItemService
final cartItemServiceProvider = Provider<CartItemService>((ref) => CartItemService());

// Provider cho danh sách CartItemModel
final cartItemProvider = StateNotifierProvider<CartController, AsyncValue<List<CartItemModel>>>((ref) {
  final service = ref.read(cartItemServiceProvider);
  return CartController(service);
});

// Controller xử lý giỏ hàng
class CartController extends StateNotifier<AsyncValue<List<CartItemModel>>> {
  final CartItemService service;

  CartController(this.service) : super(const AsyncValue.data([]));

  // Lấy tất cả sản phẩm trong giỏ hàng theo cartId
  Future<void> fetchCartItems(String cartId) async {
    try {
      state = const AsyncLoading();
      final data = await service.getAllCartItemsByCartID(cartId);
      state = AsyncData(data ?? []);
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi lấy danh sách sản phẩm trong giỏ hàng: $e");
      state = AsyncError(e, stackTrace);
    }
  }

  // Thêm sản phẩm vào giỏ hàng
  Future<void> addProductToCart(CartItemModel cartItem, String cartId) async {
    try {
      state = const AsyncLoading();
      final newItem = await service.addProductToCart(cartItem, cartId);
      if (newItem != null) {
        state = AsyncData([...state.value ?? [], newItem]);
      } else {
        state = AsyncError("Không thể thêm sản phẩm vào giỏ hàng", StackTrace.current);
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi thêm sản phẩm vào giỏ hàng: $e");
      state = AsyncError(e, stackTrace);
    }
  }

  // Cập nhật sản phẩm trong giỏ hàng
  Future<void> updateCartItem(CartItemModel cartItem) async {
    try {
      state = const AsyncLoading();
      final updatedItem = await service.updateCartItem(cartItem);
      if (updatedItem != null) {
        state = AsyncData(state.value!.map((c) => c.cartItemId == cartItem.cartItemId ? updatedItem : c).toList());
      } else {
        state = AsyncError("Không thể cập nhật sản phẩm trong giỏ hàng", StackTrace.current);
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi cập nhật sản phẩm trong giỏ hàng: $e");
      state = AsyncError(e, stackTrace);
    }
  }

  // Xóa sản phẩm khỏi giỏ hàng
  Future<void> deleteCartItem(String cartItemId) async {
    try {
      state = const AsyncLoading();
      final success = await service.deleteCartItem(cartItemId);
      if (success == true) {
        state = AsyncData(state.value!.where((c) => c.cartItemId != cartItemId).toList());
      } else {
        state = AsyncError("Không thể xóa sản phẩm khỏi giỏ hàng", StackTrace.current);
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi xóa sản phẩm khỏi giỏ hàng: $e");
      state = AsyncError(e, stackTrace);
    }
  }

  // Xóa toàn bộ giỏ hàng
  Future<void> clearCart() async {
    try {
      state = const AsyncLoading();
      final success = await service.clearCart();
      if (success == true) {
        state = const AsyncData([]);
      } else {
        state = AsyncError("Không thể xóa giỏ hàng", StackTrace.current);
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi khi xóa giỏ hàng: $e");
      state = AsyncError(e, stackTrace);
    }
  }
}
