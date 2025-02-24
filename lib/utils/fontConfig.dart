import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
class ConfigImage{
  Future<String?> convertImageToBase64() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    // Đọc ảnh dưới dạng bytes
    List<int> imageBytes = await File(image.path).readAsBytes();
    // Chuyển thành chuỗi Base64
    String base64String = base64Encode(imageBytes);
    return base64String;
  }

  Widget imageAvatar(String base64String, double width, double height) {
    Uint8List bytes = base64Decode(base64String);
    return ClipOval(
      child: Image.memory(
        bytes,
        fit: BoxFit.cover,
        width: width, // Đặt kích thước ảnh
        height: height,
      ),
    );
  }
  Widget imageProduct(String base64String, double width, double height) {
    Uint8List bytes = base64Decode(base64String);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10), // Bo góc 10px
      child: Image.memory(
        bytes,
        fit: BoxFit.cover,
        height: height * 0.2,
      ),
    );
  }
  Widget imageCartItem(String base64String, double width, double height) {
    Uint8List bytes = base64Decode(base64String);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10), // Bo góc 10px
      child: Image.memory(
        bytes,
        fit: BoxFit.cover,
        height: height * 0.08,
      ),
    );
  }
  Widget imageProductDetail(String base64String, double width, double height) {
    Uint8List bytes = base64Decode(base64String);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10), // Bo góc 10px
      child: Image.memory(
        bytes,
        fit: BoxFit.cover,
        width: width*0.98,
      ),
    );
  }
}

class ConfigCurrency{
  String formatCurrency(num price) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return formatCurrency.format(price);
  }
}
