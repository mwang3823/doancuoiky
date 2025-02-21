import 'package:doancuoiky/View/Logins/Custom_Scaffold.dart';
import 'package:doancuoiky/View/Logins/Login.dart';
import 'package:doancuoiky/View/Logins/toggle_password.dart';
import 'package:doancuoiky/View/Themes/Theme.dart';
import 'package:flutter/material.dart';
import 'package:simple_icons/simple_icons.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String email = "", password = "";
  late String _email;
  late String _password;
  late String _fName;
  late String _lName;
  late String _phoneNumber;
  late String _address;
  late String _verifyPassword;

  bool isSecurePassword = true;
  bool isComfirmPassword = true;
  final formSignInKey = GlobalKey<FormState>();
  bool rememberPassword = true;

  @override
  Widget build(BuildContext context) {
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
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.only(right: 15, left: 15, bottom: 5),
                child: SingleChildScrollView(
                  child: Form(
                    key: formSignInKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Đăng Ký',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w900,
                            color: lightColorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        // Form Email
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Email';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _email = value;
                          },
                          decoration: InputDecoration(
                            label: const Text('Email'),
                            hintText: 'Enter Email',
                            hintStyle: const TextStyle(color: Colors.black),
                            filled: true, // Cho phép màu nền
                            fillColor: Colors.grey[200], // Chọn màu nền
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black, // Default border color
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
                        const SizedBox(height: 15.0),
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
                          onChanged: (value) {
                            _password = value;
                          },
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
                            filled: true, // Cho phép màu nền
                            fillColor: Colors.grey[200], // Chọn màu nền
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
                        const SizedBox(height: 15.0),
                        // Comfirm PassWord
                        TextFormField(
                          obscureText: isComfirmPassword,
                          // Nhập password ẩn
                          obscuringCharacter: '*',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Password';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _verifyPassword = value;
                          },
                          decoration: InputDecoration(
                            suffixIcon: TogglePassword(
                              isSecurePassword: isComfirmPassword,
                              onPressed: () {
                                setState(() {
                                  isComfirmPassword = !isComfirmPassword;
                                });
                              },
                            ),
                            label: const Text('Xác nhận Password'),
                            hintText: 'Enter Password',
                            hintStyle: const TextStyle(color: Colors.black26),
                            filled: true, // Cho phép màu nền
                            fillColor: Colors.grey[200], // Chọn màu nền
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
                        const SizedBox(height: 15.0),
                        // Họ và tên
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Họ
                            Expanded(
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter name';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  _fName = value;
                                },
                                decoration: InputDecoration(
                                  label: const Text('Họ'),
                                  hintText: 'Nhập họ của bạn',
                                  hintStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  filled: true, // Cho phép màu nền
                                  fillColor: Colors.grey[200], // Chọn màu nền
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color:
                                          Colors.black, // Default border color
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors
                                          .black12, // Default border color
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            // Tên
                            Expanded(
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter name';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  _lName = value;
                                },
                                decoration: InputDecoration(
                                  label: const Text('Tên'),
                                  hintText: 'Nhập tên của bạn',
                                  hintStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  filled: true, // Cho phép màu nền
                                  fillColor: Colors.grey[200], // Chọn màu nền
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color:
                                          Colors.black, // Default border color
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors
                                          .black12, // Default border color
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        // địa chỉ
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter address';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _address = value;
                          },
                          decoration: InputDecoration(
                            label: const Text('Địa chỉ'),
                            hintText: 'Nhập địa chỉ của bạn',
                            hintStyle: const TextStyle(color: Colors.black),
                            filled: true, // Cho phép màu nền
                            fillColor: Colors.grey[200], // Chọn màu nền
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black, // Default border color
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
                        const SizedBox(height: 15.0),
                        // số điện thoại
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter phone';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _phoneNumber = value;
                          },
                          decoration: InputDecoration(
                            label: const Text('Số điện thoại'),
                            hintText: 'Nhập số điện thoại của bạn',
                            hintStyle: const TextStyle(color: Colors.black),
                            filled: true, // Cho phép màu nền
                            fillColor: Colors.grey[200], // Chọn màu nền
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black, // Default border color
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
                                  'I agree to the processing of ',
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                                GestureDetector(
                                  child: Text(
                                    'Personal data',
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
                        const SizedBox(height: 15.0),
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
                            onPressed: () {},
                            child: const Text(
                              'Tạo tài khoản',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              // tạo đường kẻ ngang
                              child: Divider(
                                thickness: 0.7,
                                // ignore: deprecated_member_use
                                color: Colors.black.withOpacity(0.5),
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
                                // ignore: deprecated_member_use
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
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
                        const SizedBox(height: 10.0),
                        // kết nối đến trang đăng nhập
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Bạn đã có tài khoản? ',
                              style: TextStyle(color: Colors.black45),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (e) => Login()),
                                );
                              },
                              child: Text(
                                'Đăng nhập',
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
