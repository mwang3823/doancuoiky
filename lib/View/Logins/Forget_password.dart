import 'package:doancuoiky/View/Logins/Custom_Scaffold.dart';
import 'package:doancuoiky/ViewModels/Controller/UserController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgetPassword extends ConsumerWidget {
  late String _email;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final TextEditingController _email=TextEditingController();
    return CustomScaffold(
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: height * 0.05,
              ),
              Image.asset(
                'assets/images/market.png',
                height: height * 0.3,
                width: width * 0.3,
              ),
              const Text(
                "Quên Mật Khẩu",
                style: TextStyle(
                  fontFamily: 'Coiny-Regular-font',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff000000),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    // Email
                    TextField(
                      controller: _email,
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Coiny-Regular-font',
                        fontSize: 16,
                      ),
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
                      onSubmitted: (value) {
                        ref.read(userProvider.notifier).getNewPassword(_email.text, context);
                      },
                    ),
                    SizedBox(
                      height: height * 0.04,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          ref.read(userProvider.notifier).getNewPassword(_email.text, context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(94, 200, 248, 1)),
                        child: const Text(
                          "Gửi mã xác nhận",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Coiny-Regular-font',
                            fontSize: 18,
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
