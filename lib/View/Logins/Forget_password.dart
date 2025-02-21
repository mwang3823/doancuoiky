import 'package:doancuoiky/View/Logins/Custom_Scaffold.dart';
import 'package:doancuoiky/View/Logins/Verify_OTP.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  late String _email;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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
                      onChanged: (value) {
                        _email = value.toString();
                      },
                    ),
                    SizedBox(
                      height: height * 0.04,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VerifyOtp(),
                            ),
                          );
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
