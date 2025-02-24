import 'package:doancuoiky/View/Logins/Custom_Scaffold.dart';
import 'package:doancuoiky/View/Logins/Login.dart';
import 'package:doancuoiky/ViewModels/Controller/UserController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class UpdatePassword extends ConsumerStatefulWidget {
  const UpdatePassword({super.key});

  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends ConsumerState<UpdatePassword> {
  final TextEditingController _newPassword=TextEditingController();
  final TextEditingController _verifyPassword=TextEditingController();

  bool flagShow2 = true;
  bool flagShow3 = true;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return CustomScaffold(
      child: Stack(
        children: [
          Center(
            child: Center(
              child: SizedBox(
                  width: width * 0.9,
                  height: height * 0.9,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.1),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30)),
                          child: Image.asset(
                            'assets/images/market.png',
                            height: height * 0.2,
                            width: width * 0.3,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        //Mật khẩu mới
                        TextField(
                          obscureText: flagShow2,
                          controller: _newPassword,
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Coiny-Regular-font',
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                              filled: true,
                              hintText: "Mật khẩu mới",
                              hintStyle: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Coiny-Regular-font',
                                fontSize: 16,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      width: 3.0,
                                      color: Color.fromRGBO(94, 200, 248, 1))),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    showNewPassword();
                                  },
                                  icon: Icon(flagShow2
                                      ? Icons.visibility_off
                                      : Icons.visibility))),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        //Nhập lại mật khẩu mới
                        TextField(
                          obscureText: flagShow3,
                          controller: _verifyPassword,
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Coiny-Regular-font',
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                              filled: true,
                              hintText: "Nhập lại mật khẩu mới",
                              hintStyle: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Coiny-Regular-font',
                                fontSize: 16,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    showVerifyPassword();
                                  },
                                  icon: Icon(flagShow3
                                      ? Icons.visibility_off
                                      : Icons.visibility))),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(94, 200, 248, 1)),
                            onPressed: () {
                              ref.read(userProvider.notifier).changePassword( _verifyPassword.text, context);
                            },
                            child: const Text(
                              "Tiếp theo",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Coiny-Regular-font'),
                            ))
                      ],
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }

  void ShowErrorUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lỗi tạo mật khẩu'),
          content: const Text("Không hợp lệ"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  void showNewPassword() {
    setState(() {
      if (flagShow2) {
        flagShow2 = false;
      } else {
        flagShow2 = true;
      }
    });
  }

  void showVerifyPassword() {
    setState(() {
      if (flagShow3) {
        flagShow3 = false;
      } else {
        flagShow3 = true;
      }
    });
  }

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
