import 'package:doancuoiky/Models/Order.dart';

class CartModel {
  final String cartId;
  final String userId;
  final String status;
  List<CartItemModel> cartItems;
  // Map<String,OrderModel> orders;

  CartModel({required this.cartId,
    required this.userId,
    required this.status,
    required this.cartItems,
    // required this.orders}
  }
      );

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      cartId: json['cartId'] ?? '',
      userId: json['userId'] ?? '',
      status: json['status'] ?? '',
      cartItems: (json['items'] as List<dynamic>?)?.map((item) => CartItemModel.fromJson(item)).toList() ?? [],
    );
  }

}

class CartItemModel {
  final String cartItemId;
  final String status;
  final num price;
  final int quantity;
  final String cartId;
  final String productId;

  CartItemModel(
      {required this.cartItemId,
      required this.status,
      required this.price,
      required this.quantity,
      required this.cartId,
      required this.productId});

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
        cartItemId: json['cartItemId'] ?? '',
        status: json['status'] ?? '',
        price: json['price'] ?? '',
        quantity: json['quantity'] ?? '',
        cartId: json['cartId'] ?? '',
        productId: json['productId'] ?? '');
  }

  static Map<String, CartItemModel> fromMapJson(Map<String,dynamic> json){
    return json.map((key, value) => MapEntry(key, CartItemModel.fromJson(value)));
  }
}
