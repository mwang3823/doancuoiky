class ProductModel {
  final String? name;
  final int? price;
  final int? sales;
  final String? image;
  final int? size;
  final String? color;
  final String? specification;
  final String? description;
  final int? stocknumber;
  final String? stocklevel;
  final int? category_id;
  final int? manufacturer_id;
  final String? expiry;
  final int? ID;
  // final ManufacturerModel? manufacturer;
  // final CategoryModel? category;

  ProductModel(
      {
        required this.name,
        required this.price,
        required this.image,
        required this.size,
        required this.color,
        required this.specification,
        required this.description,
        required this.expiry,
        required this.stocknumber,
        required this.stocklevel,
        required this.category_id,
        required this.manufacturer_id,
        required this.ID,
        // required this.manufacturer,
        // required this.category,
        required this.sales,
      });

  factory ProductModel.fromJson(Map<String, dynamic>json){
    return ProductModel(
      name: json['name'],
      price:int.tryParse(json['price'].toString()),
      image: json['image'],
      size: json['size'],
      color: json['color'],
      specification: json['specification'],
      description: json['description'],
      expiry: json['expiry'],
      stocknumber: json['stocknumber'],
      stocklevel: json['stocklevel'],
      category_id: json['category_id'],
      manufacturer_id: json['manufacturer_id'],
      ID: json['ID'],
      // category: CategoryModel.fromJson(json['Category']),
      // manufacturer: ManufacturerModel.fromJson(json['Manufacturer']),
      sales:json['sales'],
    );
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
        categoryId: json['category_id'],
        name: json['name'],
        description: json['description'],
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
        manufacturerId: json['manufacturer_id'],
        name: json['name'],
        address: json['address'],
        contact: json['contact'],
        products: ProductModel.fromMapJson(json['products']));
  }
}
