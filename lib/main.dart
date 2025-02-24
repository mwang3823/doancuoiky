import 'package:doancuoiky/View/Logins/Forget_password.dart';
import 'package:doancuoiky/View/Logins/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'View/Customer/Cart.dart';
import 'View/Customer/ProductDetail.dart';
import 'View/Customer/ProductList.dart';
import 'View/Customer/Order.dart';
import 'View/Customer/UserInfo.dart';
import 'View/Logins/Register.dart';

void main() {
  runApp(
    ProviderScope( // Bọc toàn bộ ứng dụng bằng ProviderScope
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        bottomAppBarTheme: BottomAppBarTheme(
          color: Color.fromRGBO(45, 51, 107, 1),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromRGBO(45, 51, 107, 1),
          titleTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
          iconTheme: IconThemeData(color: Colors.white)
        ),
        drawerTheme: DrawerThemeData(
          backgroundColor: Color.fromRGBO(45, 51, 107, 1),
        ),
        scaffoldBackgroundColor: Color.fromRGBO(233, 233, 233, 1),
        canvasColor: Color.fromRGBO(45, 51, 107, 1)
      ),
      home: UserInfo(),
    );
  }
}
