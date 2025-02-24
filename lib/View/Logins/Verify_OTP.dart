import 'package:doancuoiky/View/Customer/ProductList.dart';
import 'package:doancuoiky/View/Logins/Custom_Scaffold.dart';
import 'package:doancuoiky/View/Logins/Update_password.dart';
import 'package:doancuoiky/View/Widget/ShowEvent.dart';
import 'package:doancuoiky/ViewModels/Controller/UserController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class VerifyOtp extends ConsumerStatefulWidget {
  const VerifyOtp({super.key});

  @override
  _VerifyOtpState createState() => _VerifyOtpState();
}

class _VerifyOtpState extends ConsumerState<VerifyOtp> {
  @override
  Widget build(BuildContext context) {
    final userState=ref.watch(userProvider.notifier);
    final isLoading = userState is AsyncLoading;

    final TextEditingController _otp=TextEditingController();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return CustomScaffold(
      child: Stack(
        children: [
          Center(
            child: Positioned(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: Image.asset(
                      'assets/images/market.png',
                      height: height * 0.2,
                      width: width * 0.3,
                    ),
                  ),
                  const Text(
                    "Nhập Mã OTP",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  TextField(
                    onSubmitted: (value) {
                      final otpViewModel = ref.read(userProvider.notifier);
                      otpViewModel.verifyOtp(_otp.text, context);
                    },
                    keyboardType: TextInputType.number,
                    controller: _otp,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                        hintText: "OTP Code",
                        hintStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(94, 200, 248, 1),
                              width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                width: 3.0,
                                color: Color.fromRGBO(94, 200, 248, 1)))),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  //Gửi lại mã
                  const Text(
                    "Gửi lại mã",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        decoration: TextDecoration.underline),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(94, 200, 248, 1)),
                      onPressed: () {
                        final otpViewModel = ref.read(userProvider.notifier);
                        otpViewModel.verifyOtp(_otp.text, context);
                      },

                      child: const Text(
                        "Tiếp theo",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      )),
                ],
              ),
            )),
          ),
        ],
      ),
    );
  }
}
