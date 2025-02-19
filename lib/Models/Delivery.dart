class DeliveryModel {
  final String deliveryId;
  final String status;
  final String orderId;
  final String userId;

  DeliveryModel({required this.deliveryId,
    required this.status,
    required this.orderId,
    required this.userId});

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
        deliveryId: json['deliveryId'] ?? '',
        status: json['status'] ?? '',
        orderId: json['orderId'] ?? '',
        userId: json['userId'] ?? '');
  }
}

class DeliveryDetailModel {
  final String deliveryDetailId;
  final String deliveryName;
  final String shipCode;
  final String description;
  final num weight;
  final String deliveryAddress;
  final String deliveryContact;
  final num deliveryFee;
  final String deliveryId;

  DeliveryDetailModel({
    required this.deliveryDetailId,
    required this.deliveryName,
    required this.shipCode,
    required this.description,
    required this.weight,
    required this.deliveryAddress,
    required this.deliveryContact,
    required this.deliveryFee,
    required this.deliveryId
  });

  factory DeliveryDetailModel.fromJson(Map<String, dynamic> json){
    return DeliveryDetailModel(deliveryDetailId: json['deliveryDetailId'] ?? '',
        deliveryName: json['deliveryName'] ?? '',
        shipCode: json['shipCode'] ?? '',
        description: json['description'] ?? '',
        weight: json['weight'] ?? '',
        deliveryAddress: json['deliveryAddress'] ?? '',
        deliveryContact: json['deliveryContact'] ?? '',
        deliveryFee: json['deliveryFee'] ?? '',
        deliveryId: json['deliveryId'] ?? '');
  }
}
