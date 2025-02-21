import 'package:doancuoiky/View/Logins/Custom_Scaffold.dart';
import 'package:doancuoiky/View/Logins/Update_password.dart';
import 'package:flutter/material.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({super.key});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  @override
  Widget build(BuildContext context) {
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
                    keyboardType: TextInputType.number,
                    onChanged: (value) {},
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
                        // if (_otp.isEmpty) {
                        //   showMessage(context, "Chưa nhập mã OTP");
                        // } else {
                        //   // userProvider.verifyOTP(_otp).then((_){
                        //   //   if(userProvider.user!=null){
                        //   //     cartProvider.getOrCreateCartForUser(userProvider.user!.ID);
                        //   //     Navigator.pushAndRemoveUntil(
                        //   //         context,
                        //   //         MaterialPageRoute(builder: (context) => UpdatePassword(),),
                        //   //         (Route<dynamic> route) => false
                        //   //     );
                        //   //   }
                        //   // });
                        //   Navigator.pushAndRemoveUntil(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => UpdatePassword(),
                        //       ),
                        //       (Route<dynamic> route) => false,);
                        // }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdatePassword(),
                          ),
                        );
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

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
