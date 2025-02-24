import 'package:dio/dio.dart';
import 'package:doancuoiky/Config/CustomInterceptor.dart';
import 'package:doancuoiky/Config/Storage.dart';
import 'package:doancuoiky/Models/User.dart';

class UserService {
  static final String url="http://192.168.1.4:8181";
  final _dio = Dio(BaseOptions(
      baseUrl: url,
      headers: {'Content-Type': 'application/json'}
  ))..interceptors.add(CustomInterceptor());
  final storage = Storage();

  Future<bool> register(UserModel user) async {
    try {
      final response = await _dio.post(
        "/users/register",
        data: {
          'fullname': user.fullName,
          'email': user.email,
          'password': user.password,
          'phonenumber': user.phoneNumber,
          'birthday': user.birthday,
          'address': user.address,
        },
      );
      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return false;
  }

  Future<bool> login(String email, String pass) async {
    try {
      final response = await _dio
          // .post('/users/login', data: {'email': 'mwang38203@gmail.com', 'password': 'wangwang'});
          .post('/users/login', data: {'email': email, 'password': pass});

      if (response.statusCode == 200) return true;
    } catch (e) {
      throw Exception("Error: $e");
    }
    return false;
  }

  Future<UserModel?> verifyOtp(String otp) async {
    try {
      final response = await _dio.post('/users/verify', data: {'otp': otp});
      if (response.statusCode == 200) {
        final token = response.data['token'];
        await storage.write('token', token);
        print("Token: $token");
        final data = UserModel.formJson(response.data['user']);
        return data;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return null;
  }

  Future<bool> deleteUser(String id) async {
    try {
      final response = await _dio.delete('/users/$id',
          options: Options(
              headers: {'Authorization': 'Bearer ${storage.read('token')}'}));
      if (response.statusCode == 200) return true;
    } catch (e) {
      throw Exception("Error: $e");
    }
    return false;
  }

  Future<UserModel?> changePassword(String oldPassword, String newPassword, int userId) async {
    print(storage.read('token'));
    try {
      final response = await _dio.put('/users/$userId/password',
          options: Options(
              headers: {'Authorization': 'Bearer ${storage.read('token')}'}),
          data: {'currentpassword': oldPassword, 'password': newPassword});
      if (response.statusCode == 200) {
        final data = UserModel.formJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return null;
  }

  Future<bool> updateUser(UserModel user) async {
    try {
      final token=await storage.read('token');
      final response = await _dio.put(
          "/users/${user.userId}",
          options: Options(
              headers: {'Authorization': 'Bearer $token'}),
        data: {
          'fullname': user.fullName,
          'phonenumber': user.phoneNumber,
          'email': user.email,
          'password': user.password
        },
      );
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return false;
  }

  Future<UserModel?> getUserById(String id) async {
    try {
      final response = await _dio.get('/users/$id',
          options: Options(
              headers: {'Authorization': 'Bearer ${storage.read('token')}'}));
      if (response.statusCode == 200) {
        final data = UserModel.formJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return null;
  }

  Future<List<UserModel>> getAllUser() async {
    try {
      final token=await storage.read('token');
      final response = await _dio.get('/users/',
          options: Options(
              headers: {
                'Authorization':'Bearer $token}'
              }));
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final list = data
            .map(
              (e) => UserModel.formJson(e),
            )
            .toList();
        return list;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return [];
  }

  Future<UserModel?> getUserByNumberPhone(String numberPhone) async {
    try {
      final response = await _dio.get('/users/phone/$numberPhone',
          options: Options(
              headers: {'Authorization': 'Bearer ${storage.read('token')}'}));
      if (response.statusCode == 200) {
        final data = UserModel.formJson(response.data);
        return data;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return null;
  }

  Future<bool?> getNewPassword(String email)async{
    try{
      final response=await _dio.post("/users/resetpass",
      data: {
        "email":email
      }
      );
      if(response.statusCode==200){
        return true;
      }
      else{
        return false;
      }
    }catch(e){
      throw Exception("Error $e");
    }
  }
}

// [GIN-debug] POST   /users/register           --> MSA-Project/internal/interfaces/http.UserHandler.RegisterUser-fm (3 handlers)
// [GIN-debug] POST   /users/login              --> MSA-Project/internal/interfaces/http.UserHandler.Login-fm (3 handlers)
// [GIN-debug] POST   /users/verify             --> MSA-Project/internal/interfaces/http.UserHandler.VerifyOTP-fm (3 handlers)
// [GIN-debug] POST   /users/login/google       --> MSA-Project/internal/interfaces/http.UserHandler.LoginWithGoogle-fm (3 handlers)
// [GIN-debug] POST   /users/resetpass          --> MSA-Project/internal/interfaces/http.UserHandler.GetNewPassword-fm (3 handlers)
// [GIN-debug] DELETE /users/:id                --> MSA-Project/internal/interfaces/http.UserHandler.DeleteUser-fm (4 handlers)
// [GIN-debug] PUT    /users/:id/password       --> MSA-Project/internal/interfaces/http.UserHandler.UpdateUser-fm (4 handlers)
// [GIN-debug] PUT    /users/:id                --> MSA-Project/internal/interfaces/http.UserHandler.UpdateUserInf-fm (4 handlers)
// [GIN-debug] GET    /users/:id                --> MSA-Project/internal/interfaces/http.UserHandler.GetUserById-fm (4 handlers)
// [GIN-debug] GET    /users/                   --> MSA-Project/internal/interfaces/http.UserHandler.GetAllUsers-fm (4 handlers)
// [GIN-debug] GET    /users/phone/:phone       --> MSA-Project/internal/interfaces/http.UserHandler.GetUserByPhoneNumber-fm (4 handlers)
