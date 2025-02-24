import 'package:doancuoiky/View/Logins/Login.dart';
import 'package:doancuoiky/View/Logins/Update_password.dart';
import 'package:doancuoiky/View/Logins/Verify_OTP.dart';
import 'package:doancuoiky/View/Logins/Verify_OTP_Change_Password.dart';
import 'package:doancuoiky/View/Widget/ShowEvent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Models/User.dart';
import '../../View/Customer/ProductList.dart';
import '../Service/UserService.dart';

// Provider
final userService = Provider<UserService>((ref) => UserService());

final isSuccess = StateProvider<bool>((ref) => false);

final userProvider =
    StateNotifierProvider<CurrentUserController, AsyncValue<UserModel?>>((ref) {
  final apiService = ref.watch(userService);
  return CurrentUserController(apiService);
});

final _showEvent = showEvent();

// Controller chính
class CurrentUserController extends StateNotifier<AsyncValue<UserModel?>> {
  final UserService user;

  CurrentUserController(this.user) : super(const AsyncValue.data(null));

  Future<void> login(
      String email, String pass, WidgetRef ref, BuildContext context) async {
    // if(email.isEmpty){
    //   _showMessage.showCustomSnackbar(context, "Bạn chưa nhập Email");
    // }
    // if(pass.isEmpty){
    //   _showMessage.showCustomSnackbar(context, "Bạn chưa nhập Password");
    // }
    try {
      state = AsyncValue.loading();
      _showEvent.showLoadingDialog(context);
      // final data = await user.login(email, pass);
      final data = await user.login("mwang38203@gmail.com", "123123123");
      if (!data) {
        state = AsyncValue.error(
            "Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin.",
            StackTrace.current);
        return;
      } else {
        state = AsyncValue.error(
            "Đăng nhập thành công. Vui lòng kiểm tra lại thông tin.",
            StackTrace.current);
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyOtp(),
          ),
          (route) => false,
        );
      }

      // ref.read(isSuccess.notifier).state = true;
    } catch (e, stackTrace) {
      debugPrint("Lỗi đăng nhập: $e");
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> register(UserModel userModel, BuildContext context) async {
    try {
      state = AsyncValue.loading();
      final data = await user.register(userModel);
      if (!data) {
        _showEvent.showCustomSnackbar(context, "Đăng ký không thành công");
      } else {
        _showEvent.showCustomSnackbar(context, "Đăng ký thành công");
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Login(),
            ));
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi đăng ký: $e");
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> verifyOtp(String otp, BuildContext context) async {
    if (otp.isEmpty) {
      _showEvent.showCustomSnackbar(context, "Bạn chưa nhập OTP",
          isError: true);
      return;
    }
    state = const AsyncValue.loading();
    try {
      final data = await user.verifyOtp(otp);

      if (data != null) {
        state = AsyncValue.data(data);
        _showEvent.showCustomSnackbar(context, "Xác thực OTP thành công!",
            isError: false);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ProductListScreen()),
          (route) => false,
        );
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      debugPrint("Lỗi OTP: $e");
      _showEvent.showCustomSnackbar(context, "Xác thực OTP không thành công!.",
          isError: true);
    }
  }

  Future<void> verifyOtpChangPassword(String otp, BuildContext context) async {
    if (otp.isEmpty) {
      _showEvent.showCustomSnackbar(context, "Bạn chưa nhập OTP",
          isError: true);
      return;
    }
    state = const AsyncValue.loading();
    _showEvent.showLoadingDialog(context);
    try {
      final data = await user.verifyOtp(otp);
      state = AsyncValue.data(data);
      if (state.value != null) {
        print("password: ${state.value!.password}");
        print("email: ${state.value!.email}");
        print("address: ${state.value!.address}");
        print("phoneNumber: ${state.value!.phoneNumber}");
        print("fullName: ${state.value!.fullName}");
        print("birthday: ${state.value!.birthday}");
        Navigator.pop(context);
        _showEvent.showCustomSnackbar(context, "Xác thực OTP thành công!",
            isError: false);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => UpdatePassword()),
          (route) => false,
        );
      } else {
        Navigator.pop(context);
        throw Exception("Xác thực OTP không thành công!");
      }
    } catch (e, stackTrace) {
      Navigator.pop(context);
      debugPrint("Lỗi OTP: $e");
      state = AsyncValue.error(e, stackTrace);
      _showEvent.showCustomSnackbar(
          context, "Mã OTP không đúng, vui lòng thử lại!",
          isError: true);
    }
  }

  Future<void> changePassword(String newPass, BuildContext context) async {
    print("userId: ${state.value!.userId}");
    print("password: ${state.value!.password}");
    print("email: ${state.value!.email}");
    print("address: ${state.value!.address}");
    print("phoneNumber: ${state.value!.phoneNumber}");
    print("fullName: ${state.value!.fullName}");
    print("birthday: ${state.value!.birthday}");
    // if(newPass.isEmpty){
    //
    //   _showEvent.showCustomSnackbar(context, "Không được để trống mật khẩu");
    // }
    try {
      // state = AsyncValue.loading();
      print("userID: ${state.value!.userId}");
      final data = await user.updateUser(new UserModel(
          fullName: state.value!.fullName,
          email: state.value!.email,
          phoneNumber: state.value!.phoneNumber,
          birthday: state.value!.birthday,
          password: newPass,
          address: state.value!.address,
          userId: state.value!.userId));
      if (data) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Login(),
            ));
      } else {
        _showEvent.showCustomSnackbar(context, "không thể đổi Password");
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi đổi mật khẩu: $e");
      state = AsyncValue.error(e, stackTrace);
      _showEvent.showCustomSnackbar(context, "không thể đổi Password: $e");
    }
  }

  Future<void> updateUser(UserModel userModel, WidgetRef ref) async {
    try {
      state = AsyncValue.loading();
      final data = await user.updateUser(userModel);
      if (!data) {
        state = AsyncValue.error(
            "Không thể cập nhật thông tin.", StackTrace.current);
        return;
      } else {
        state = state.whenData(
          (value) => value,
        );
        ref.read(isSuccess.notifier).state = true;
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi cập nhật user: $e");
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> getNewPassword(String email, BuildContext context) async {
    // if(email.isEmpty){
    //   _showEvent.showCustomSnackbar(context, "Bạn chưa nhập email",isError: true);
    // }
    try {
      final data = await user.getNewPassword("mwang38203@gmail.com");

      if (data == true) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyOtpChangePassword(),
            ));
      } else {
        _showEvent.showCustomSnackbar(context, "Lỗi hệ thống", isError: true);
      }
    } catch (e, stackTrace) {
      debugPrint("Lỗi getNewPassword: $e");
      _showEvent.showCustomSnackbar(context, "Lỗi hệ thống", isError: true);
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

// Controller danh sách user (admin)
final listUserProvider =
    StateNotifierProvider<ListUserController, AsyncValue<List<UserModel>>>(
        (ref) {
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
      if (data.isEmpty) {
        state =
            AsyncValue.error("Không tìm thấy người dùng", StackTrace.current);
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
      if (!data) {
        state =
            AsyncValue.error("Không thể xóa người dùng.", StackTrace.current);
        return;
      } else {
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
final otherUserProvider =
    StateNotifierProvider<otherUserController, AsyncValue<UserModel?>>((ref) {
  final apiService = ref.watch(userService);
  return otherUserController(apiService);
});

class otherUserController extends StateNotifier<AsyncValue<UserModel?>> {
  final UserService service;

  otherUserController(this.service) : super(const AsyncValue.data(null));

  Future<void> getUserById(String id) async {
    try {
      state = AsyncValue.loading();
      final data = await service.getUserById(id);
      data != null ? state = AsyncValue.data(data) : AsyncValue.data(null);
    } catch (e, stackTrace) {
      debugPrint("Lỗi lấy dữ liệu người dùng bằng ID: $e");
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> getUserByNumberPhone(String phoneNumber) async {
    try {
      state = AsyncValue.loading();
      final data = await service.getUserByNumberPhone(phoneNumber);
      data != null
          ? state = AsyncValue.data(data)
          : state = AsyncValue.data(null);
    } catch (e, stackTrace) {
      debugPrint("Lỗi lấy dữ liệu người dùng bằng số điện thoại: $e");
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
