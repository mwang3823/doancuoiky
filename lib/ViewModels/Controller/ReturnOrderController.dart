import 'package:doancuoiky/Models/Order.dart';
import 'package:doancuoiky/ViewModels/Service/ReturnOrderService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final returnOrderService = Provider<ReturnOrderService>((ref) => ReturnOrderService());

final isSuccess = StateProvider<bool>((ref) => false);

final listReturnOrderProvider = StateNotifierProvider<ListReturnOrderController, AsyncValue<List<ReturnOrderModel?>>>((ref) {
  final returnOrder = ref.watch(returnOrderService);
  return ListReturnOrderController(returnOrder);
},);

final returnOrderProvider=StateNotifierProvider<ReturnOrderController, AsyncValue<ReturnOrderModel?>>((ref) {
  final service=ref.watch(returnOrderService);
  return ReturnOrderController(service);
});

class ListReturnOrderController extends StateNotifier<AsyncValue<List<ReturnOrderModel?>>> {
  final ReturnOrderService service;
  ListReturnOrderController(this.service):super(const AsyncValue.data([]));

  Future<void> getAllReturnOrders() async{
    try{
      state=AsyncValue.loading();
      final data=await service.getAllReturnOrders();
      state=AsyncValue.data(data);
    }catch(e, stackTrace){
      debugPrint("Lỗi lấy danh sách đơn hàng trả về: $e");
      state=AsyncValue.error(e, stackTrace);
    }
  }
}

class ReturnOrderController extends StateNotifier<AsyncValue<ReturnOrderModel?>>{
  final ReturnOrderService service;
  ReturnOrderController(this.service):super(AsyncValue.data(null));

  Future<void> createReturnOrder(ReturnOrderModel returnOrder,String orderId)async{
    try{
      state=AsyncValue.loading();
      final data= await service.createReturnOrder(returnOrder, orderId);
      if(data!=null){
        state=AsyncValue.data(data);
      }else{
        state=AsyncValue.error("Không thể trả hàng", StackTrace.current);
      }
    }catch(e, stackTrace){
      state=AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteReturnOrder(String returnOrderId, WidgetRef ref) async{
    try{
      state=AsyncValue.loading();
      ref.read(isSuccess.notifier).state=false;
      final data=await service.deleteReturnOrder(returnOrderId);
      if(data){
        ref.read(listReturnOrderProvider.notifier).getAllReturnOrders();
        ref.read(isSuccess.notifier).state=true;
      }else{
        state=AsyncValue.error("Không thể xóa đơn hàng trả về", StackTrace.current);
      }
    }catch(e,stackTrace){
      state=AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> getReturnOrderByID(String returnOrderId) async{
    try{
      state=AsyncValue.loading();
      final data=await service.getReturnOrderByID(returnOrderId);
      state=AsyncValue.data(data);
    }catch(e, stackTrace){
      debugPrint("Lỗi lấy đơn hàng trả về theo ID sản phẩm");
      state=AsyncValue.error(e, stackTrace);
    }
  }
}