import 'package:doancuoiky/View/Logins/Custom_Scaffold.dart';
import 'package:doancuoiky/View/Logins/Custom_WelcomeButton.dart';
import 'package:doancuoiky/View/Logins/Login.dart';
import 'package:doancuoiky/View/Logins/Register.dart';
import 'package:doancuoiky/View/Themes/Theme.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 40.0,
              ),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Chào mừng bạn đến với \n SuperMarket \n',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text:
                            '\n Hãy tạo tài khoản cho riêng mình nào!!!',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  Expanded(
                    child: CustomWelcomeButton(
                      buttonText: 'Đăng nhập',
                      onTap: const Login(),
                      color: Colors.transparent,
                      textColor: lightColorScheme.shadow,
                    ),
                  ),
                  Expanded(
                    child: CustomWelcomeButton(
                      buttonText: 'Đăng ký',
                      onTap: Register(),
                      color: Colors.white,
                      textColor: lightColorScheme.shadow,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
