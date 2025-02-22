import 'package:doancuoiky/Models/Product.dart';
import 'package:doancuoiky/ViewModels/Service/ProductService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productService=Provider<ProductService>((ref) => ProductService());

final isSuccess=StateProvider<bool>((ref) => false);

final productProvider=StateNotifierProvider<ProductController,AsyncValue<ProductModel?>>((ref) {
  final service=ref.watch(productService);
  return ProductController(service);
});

final listProductProvider=StateNotifierProvider<ListProductController, AsyncValue<List<ProductModel?>>>((ref) {
  final service=ref.watch(productService);
  return ListProductController(service);
});

class ProductController extends StateNotifier<AsyncValue<ProductModel?>>{
  final ProductService service;
  ProductController(this.service):super(AsyncValue.data(null));

  Future<void> createProduct(ProductModel product, WidgetRef ref)async{
    try{
      state=AsyncValue.loading();
      final data= await service.createProduct(product);
      if(data!=null){
        ref.read(listProductProvider.notifier).getAllProduct();
        state=AsyncValue.data(data);
      }else{
        state=AsyncValue.error("Không thể tạo sản phẩm", StackTrace.current);
      }
    }catch(e, stackTrace){
      debugPrint("Không thể tạo sản phẩm: $e");
      state=AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateProduct(ProductModel product, WidgetRef ref) async {
    try{
      state=AsyncLoading();
      final data=await service.updateProduct(product);
      if(data!=null){
        state=AsyncData(data);
      }
      else{
        ref.read(listProductProvider.notifier).getAllProduct();
        state=AsyncError("Không thể cập nhật sản phẩm", StackTrace.current);
      }
    }catch(e, stackTrace){
      debugPrint("Không thể cập nhật sản phẩm: $e");
      state=AsyncError(e, stackTrace);
    }
  }

  Future<void> getProductById(String id)async{
    try{
      state=AsyncLoading();
      final data=await service.getProductById(id);
      if(data!=null){
        state=AsyncData(data);
      }
      else{
        state=AsyncError("Không thể lấy sản phẩm", StackTrace.current);
      }
    }catch(e, stackTrace){
      debugPrint("Không thể lấy sản phẩm: $e");
      state=AsyncError(e, stackTrace);
    }
  }

  Future<void> deleteProduct(String id, WidgetRef ref) async {
    try {
      state = const AsyncLoading();
      ref.read(isSuccess.notifier).state = false;

      final data = await service.deleteProduct(id);
      if (data) {
        ref.read(isSuccess.notifier).state = true;

        ref.read(listProductProvider.notifier).getAllProduct();
      } else {
        state = AsyncError("Không thể xóa sản phẩm", StackTrace.current);
      }
    } catch (e, stackTrace) {
      debugPrint("Không thể xóa sản phẩm: $e");
      state = AsyncError(e, stackTrace);
    }
  }

}

class ListProductController extends StateNotifier<AsyncValue<List<ProductModel?>>>{
  final ProductService service;
  ListProductController(this.service):super(AsyncValue.data([]));

  Future<void> getAllProduct()async{
    try{
      state=AsyncLoading();
      final data=await service.getAllProduct();
      if(data.isNotEmpty){
        state=AsyncData(data);
      }
      else{
        state=AsyncError("Không thể lấy tất cả sản phẩm", StackTrace.current);
      }
    }catch(e, stackTrace){
      debugPrint("Không thể lấy tất cả sản phẩm: $e");
      state=AsyncError(e, stackTrace);
    }
  }

  Future<void> searchProduct(String name) async{
    try{
      state=AsyncLoading();
      final data=await service.searchProduct(name);
      if(data.isNotEmpty){
        state=AsyncData(data);
      }
      else{
        state=AsyncError("Không thể lấy tất cả sản phẩm", StackTrace.current);
      }
    }catch(e, stackTrace){
      debugPrint("Không thể lấy tất cả sản phẩm: $e");
      state=AsyncError(e, stackTrace);
    }
  }
}