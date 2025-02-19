class ProductModel {
  final String productId;
  final String name;
  final num price;
  final String image;
  final num sales;
  final int size;
  final String color;
  final String specification;
  final String description;
  final String expiry;
  final int stockNumber;
  final String stockLevel;
  final String categoryId;
  final String manufacturerId;

  ProductModel(
      {required this.productId,
      required this.name,
      required this.price,
      required this.image,
      required this.sales,
      required this.size,
      required this.color,
      required this.specification,
      required this.description,
      required this.expiry,
      required this.stockNumber,
      required this.stockLevel,
      required this.categoryId,
      required this.manufacturerId});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
        productId: json['product_id'] ?? '',
        name: json['name'] ?? '',
        price: json['price'] ?? '',
        image: json['image'] ?? '',
        sales: json['sales'] ?? '',
        size: json['size'] ?? '',
        color: json['color'] ?? '',
        specification: json['specification'] ?? '',
        description: json['description'] ?? '',
        expiry: json['expiry'] ?? '',
        stockNumber: json['stockNumber'] ?? '',
        stockLevel: json['stockLevel'] ?? '',
        categoryId: json['categoryId'] ?? '',
        manufacturerId: json['manufacturerId'] ?? '');
  }

  static Map<String,ProductModel> fromMapJson(Map<String,dynamic> json){
    return json.map((key, value) => MapEntry(key, ProductModel.fromJson(value)));
  }
}

class CategoryModel {
  final String categoryId;
  final String name;
  final String description;
  Map<String, ProductModel> products;

  CategoryModel(
      {required this.categoryId,
      required this.name,
      required this.description,
      required this.products});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
        categoryId: json['category_id'] ?? '',
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        products: ProductModel.fromMapJson(json['products']??''));
  }
}

class ManufacturerModel {
  final String manufacturerId;
  final String name;
  final String address;
  final String contact;
  final Map<String,ProductModel> products;

  ManufacturerModel(
      {required this.manufacturerId,
      required this.name,
      required this.address,
      required this.contact,
      required this.products});

  factory ManufacturerModel.fromJson(Map<String, dynamic> json) {
    return ManufacturerModel(
        manufacturerId: json['manufacturer_id'] ?? '',
        name: json['name'] ?? '',
        address: json['address'] ?? '',
        contact: json['contact'] ?? '',
        products: ProductModel.fromMapJson(json['products'] ?? ''));
  }
}
