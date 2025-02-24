import 'package:doancuoiky/View/Logins/Custom_Scaffold.dart';
import 'package:doancuoiky/View/Logins/Forget_password.dart';
import 'package:doancuoiky/View/Logins/Register.dart';
import 'package:doancuoiky/View/Logins/toggle_password.dart';
import 'package:doancuoiky/View/Themes/Theme.dart';
import 'package:doancuoiky/ViewModels/Controller/UserController.dart';
import 'package:flutter/material.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  String email = "", password = "";
  final TextEditingController _email=TextEditingController();
  final TextEditingController _password=TextEditingController();

  bool isSecurePassword = true;
  final formSignInKey = GlobalKey<FormState>();
  bool rememberPassword = true;



  @override
  Widget build(BuildContext context) {
    final userState=ref.read(userProvider.notifier);
    // final success=ref.read(isSuccess.notifier);
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Quay về màn hình giới thiệu
        Navigator.of(context).popUntil((route) => route.isFirst);
        return false; // Ngăn không cho hành động mặc định
      },
      child: CustomScaffold(
        child: Column(
          children: [
            const Expanded(child: SizedBox(height: 10)),
            Expanded(
              flex: 6,
              child: Container(
                padding: const EdgeInsets.only(
                  left: 25.0,
                  top: 50.0,
                  right: 25.0,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: formSignInKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Đăng nhập',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w900,
                            color: lightColorScheme.shadow,
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        // Form Email
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Email';
                            }
                            return null;
                          },
                          controller: _email,
                          decoration: InputDecoration(
                            label: const Text('Email'),
                            hintText: 'Enter Email',
                            hintStyle: const TextStyle(color: Colors.black26),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12, // Default border color
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12, // Default border color
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        // Form PassWord
                        TextFormField(
                          obscureText: isSecurePassword,
                          // Nhập password ẩn
                          obscuringCharacter: '*',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Password';
                            }
                            return null;
                          },
                          controller: _password,
                          decoration: InputDecoration(
                            suffixIcon: TogglePassword(
                              isSecurePassword: isSecurePassword,
                              onPressed: () {
                                setState(() {
                                  isSecurePassword = !isSecurePassword;
                                });
                              },
                            ),
                            label: const Text('Password'),
                            hintText: 'Enter Password',
                            hintStyle: const TextStyle(color: Colors.black26),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12, // Default border color
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12, // Default border color
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        // dòng Remember, Forget Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: rememberPassword,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      rememberPassword = value!;
                                    });
                                  },
                                  activeColor: lightColorScheme.primary,
                                ),
                                const Text(
                                  'Remember me',
                                  style: TextStyle(color: Colors.black45),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (e) => ForgetPassword(),
                                  ),
                                );
                              },
                              child: Text(
                                'Quên mật khẩu?',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: lightColorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25.0),
                        // nút Sign In
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xffBDA687),
                              padding: const EdgeInsets.symmetric(
                                vertical: 15.0,
                                horizontal: 0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () async{
                              userState.login(_email.text, _password.text, ref, context);

                            },
                            child: const Text(
                              'Đăng nhập',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              // tạo đường kẻ ngang
                              child: Divider(
                                thickness: 0.7,
                                // ignore: deprecated_member_use
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 10,
                              ),
                              child: Text(
                                'Đăng nhập',
                                style: TextStyle(color: Colors.black45),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 0.7,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25.0),
                        // Các kết nối bên ngoài
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              SimpleIcons.facebook,
                              color: Colors.blue,
                              size: 30.0,
                            ),
                            Icon(
                              SimpleIcons.gmail,
                              color: Colors.red,
                              size: 30.0,
                            ),
                            Icon(
                              SimpleIcons.apple,
                              color: Colors.black,
                              size: 30.0,
                            ),
                          ],
                        ),
                        const SizedBox(height: 25.0),
                        // kết nối đến trang đăng ký
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Bạn không có tài khoản? ',
                              style: TextStyle(color: Colors.black45),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (e) =>  Register(),
                                  ),
                                );
                              },
                              child: Text(
                                'Đăng ký',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: lightColorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
