import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Models/User.dart';
import '../Service/UserService.dart';

// Provider
final userService = Provider<UserService>((ref) => UserService());

//Kiểm tra trạng thái được thực hiện thành công hay không
final isSuccess = StateProvider<bool>((ref) => false);

final userProvider = StateNotifierProvider<CurrentUserController, AsyncValue<UserModel?>>((ref) {
  final apiService = ref.watch(userService);
  return CurrentUserController(apiService);
});

// Controller chính
class CurrentUserController extends StateNotifier<AsyncValue<UserModel?>> {
  final UserService user;
  CurrentUserController(this.user) : super(const AsyncValue.data(null));

  Future<void> login(String email, String pass, WidgetRef ref) async {
    try {
      state = AsyncValue.loading();
      final data = await user.login(email, pass);
      if (!data)  state = AsyncValue.error("Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin.", StackTrace.current);
      state = const AsyncValue.data(null);
      // ref.read(isSuccess.notifier).state = true;
    } catch (e, stackTrace) {
      debugPrint("Lỗi đăng nhập: $e");
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> register(UserModel userModel, WidgetRef ref) async {
    try {
      state = AsyncValue.loading();
      final data = await user.register(userModel);
      if (!data) AsyncValue.error("Đăng ký không thành công.", StackTrace.current);

      state = const AsyncValue.data(null);
      ref.read(isSuccess.notifier).state = true;
    } catch (e, stackTrace) {
      debugPrint("Lỗi đăng ký: $e");
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> verifyOtp(String otp) async {
    try {
      state = AsyncValue.loading();
      final data = await user.verifyOtp(otp);
      state = data != null ? AsyncValue.data(data) : AsyncValue.error("Không đúng OTP", StackTrace.current);
    } catch (e, stackTrace) {
      debugPrint("Lỗi OTP: $e");
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> changePassword(String oldPass, String newPass, String userId) async {
    try {
      state = AsyncValue.loading();
      final data = await user.changePassword(oldPass, newPass, userId);
      state = data != null ? AsyncValue.data(data) : AsyncValue.error("Không thể đổi Password", StackTrace.current);
    } catch (e, stackTrace) {
      debugPrint("Lỗi đổi mật khẩu: $e");
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateUser(UserModel userModel, WidgetRef ref) async {
    try {
      state = AsyncValue.loading();
      final data = await user.updateUser(userModel);
      if (!data) {
        state=AsyncValue.error("Không thể cập nhật thông tin.", StackTrace.current);
        return;
      }else{
        state=state.whenData((value) => value,);
        ref.read(isSuccess.notifier).state = true;
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi cập nhật user: $e");
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

// Controller danh sách user (admin)
final listUserProvider = StateNotifierProvider<ListUserController, AsyncValue<List<UserModel>>>((ref) {
  final apiService = ref.watch(userService);
  return ListUserController(apiService);
});

class ListUserController extends StateNotifier<AsyncValue<List<UserModel>>> {
  final UserService service;
  ListUserController(this.service) : super(const AsyncValue.data([]));

  Future<void> getAllUser() async {
    try {
      state = AsyncValue.loading();
      final data = await service.getAllUser();
      if(data.isEmpty){
        state=AsyncValue.error("Không tìm thấy người dùng", StackTrace.current);
        return;
      }
      state = AsyncValue.data(data);
    } catch (e, stackTrace) {
      debugPrint("Lỗi lấy danh sách user: $e");
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteUser(String id, WidgetRef ref) async {
    try {
      state = AsyncValue.loading();
      ref.read(isSuccess.notifier).state = false;
      final data = await service.deleteUser(id);
      if (!data){
        state=AsyncValue.error("Không thể xóa người dùng.", StackTrace.current);
        return;
      }
      else{
        getAllUser();
        ref.read(isSuccess.notifier).state = true;
      }

    } catch (e, stackTrace) {
      debugPrint("Lỗi xóa user: $e");
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

//Controller dữ liệu khác (admin)
final otherUserProvider=StateNotifierProvider<otherUserController, AsyncValue<UserModel?>>((ref) {
  final apiService=ref.watch(userService);
  return otherUserController(apiService);
});

class otherUserController extends StateNotifier<AsyncValue<UserModel?>>{
  final UserService service;
  otherUserController(this.service):super(const AsyncValue.data(null));

  Future<void> getUserById(String id) async{
    try{
      state=AsyncValue.loading();
      final data=await service.getUserById(id);
      data!=null ? state=AsyncValue.data(data): AsyncValue.data(null);
    }catch(e, stackTrace){
      debugPrint("Lỗi lấy dữ liệu người dùng bằng ID: $e");
      state=AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> getUserByNumberPhone(String phoneNumber) async{
    try{
      state=AsyncValue.loading();
      final data=await service.getUserByNumberPhone(phoneNumber);
      data!=null? state=AsyncValue.data(data):state=AsyncValue.data(null);
    }catch(e, stackTrace){
      debugPrint("Lỗi lấy dữ liệu người dùng bằng số điện thoại: $e");
      state=AsyncValue.error(e, stackTrace);
    }
  }

}