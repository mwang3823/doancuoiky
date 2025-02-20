class OrderModel {
  final String orderId;
  final num grandTotal;
  final String userId;
  final String cartId;
  final String status;

  OrderModel({required this.orderId,
    required this.userId,
    required this.cartId,
    required this.status,
    required this.grandTotal});

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
        orderId: json['order_id'] ?? '',
        userId: json['userId'] ?? '',
        cartId: json['cartId'] ?? '',
        status: json['status'] ?? '',
        grandTotal: json['grandTotal'] ?? '');
  }

  static Map<String, OrderModel> fromMapJson(Map<String, dynamic> json) {
    return json.map(
          (key, value) => MapEntry(key, OrderModel.fromJson(value)),
    );
  }
}

class PaymentModel {
  final String paymentId;
  final String paymentMethod;
  final String status;
  final num grandTotal;
  final String userId;
  final String orderId;

  PaymentModel({required this.paymentId,
    required this.paymentMethod,
    required this.status,
    required this.grandTotal,
    required this.userId,
    required this.orderId});

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
        paymentId: json['payment_id'] ?? '',
        paymentMethod: json['paymentMethod'] ?? '',
        status: json['status'] ?? '',
        grandTotal: json['grandtotal'] ?? '',
        userId: json['userId'] ?? '',
        orderId: json['orderId'] ?? '');
  }
}

class OrderDetailModel {
  final String orderDetailId;
  final String status;
  final int quantity;
  final num unitPrice;
  final num totalPrice;
  final String orderId;
  final String productId;

  OrderDetailModel({required this.orderDetailId,
    required this.status,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.productId,
    required this.orderId});

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
        orderDetailId: json['orderDetailId'] ?? '',
        status: json['status'] ?? '',
        productId: json['product_id'] ?? '',
        quantity: json['quantity'] ?? '',
        unitPrice: json['unitPrice'] ?? '',
        totalPrice: json['totalPrice'] ?? '',
        orderId: json['orderId'] ?? '');
  }
}

class OrderPromoCodeModel {
  final String orderPromoCodeId;
  final String orderId;
  final String promoCodeID;

  OrderPromoCodeModel({required this.orderPromoCodeId,
    required this.orderId,
    required this.promoCodeID});

  factory OrderPromoCodeModel.fromJson(Map<String, dynamic> json) {
    return OrderPromoCodeModel(
        orderPromoCodeId: json['orderPromoCodeId'] ?? '',
        orderId: json['orderId'] ?? '',
        promoCodeID: json['promoCodeID'] ?? '');
  }

  static Map<String, OrderPromoCodeModel> fromMapJson(
      Map<String, dynamic> json) {
    return json.map(
          (key, value) => MapEntry(key, OrderPromoCodeModel.fromJson(value)),
    );
  }
}

class PromoCodeModel {
  final String promoCodeId;
  final String name;
  final String code;
  final String description;
  final String startDate;
  final String endDate;
  final String status;
  final String discountType;
  final String discountPercentage;
  final String minimumOrderValue;
  final List<OrderPromoCodeModel> orderPromoCodes;

  PromoCodeModel({required this.promoCodeId,
    required this.name,
    required this.code,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.discountType,
    required this.discountPercentage,
    required this.minimumOrderValue,
    required this.orderPromoCodes});

  factory PromoCodeModel.fromJson(Map<String, dynamic> json){
    return PromoCodeModel(
        promoCodeId: json['promoCodeId'] ?? '',
        name: json['name'] ?? '',
        code: json['code'] ?? '',
        description: json['description'] ?? '',
        startDate: json['startDate'] ?? '',
        endDate: json['endDate'] ?? '',
        status: json['status'] ?? '',
        discountType: json['discountType'] ?? '',
        discountPercentage: json['discountPercentage'] ?? '',
        minimumOrderValue: json['minimumOrderValue'] ?? '',
        orderPromoCodes: json['orderPromoCodes'] ?? '');
  }
}

class ReturnOrderModel {
  final String returnOrderId;
  final String reason;
  final num refundAmount;
  final String orderId;
  final String status;

  ReturnOrderModel({required this.returnOrderId,
    required this.reason,
    required this.status,
    required this.refundAmount,
    required this.orderId});

  factory ReturnOrderModel.fromJson(Map<String, dynamic> json) {
    return ReturnOrderModel(
        returnOrderId: json['returnOrderId'] ?? '',
        reason: json['reason'] ?? '',
        refundAmount: json['refundAmount'] ?? '',
        status: json['status'] ?? '',
        orderId: json['orderId'] ?? '');
  }
}

class FeedBackModel {
  final String feedBackId;
  final int rating;
  final String comment;
  final String userId;
  final String productId;

  FeedBackModel({required this.feedBackId,
    required this.rating,
    required this.comment,
    required this.userId,
    required this.productId});

  factory FeedBackModel.fromJson(Map<String, dynamic> json) {
    return FeedBackModel(
        feedBackId: json['feedBackId'] ?? '',
        rating: json['rating'] ?? '',
        comment: json['comment'] ?? '',
        userId: json['user_id'] ?? '',
        productId: json['product_id'] ?? '');
  }
}
