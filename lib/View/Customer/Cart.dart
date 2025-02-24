import 'package:doancuoiky/View/Customer/Widget/CartItem.dart';
import 'package:doancuoiky/ViewModels/Controller/UserController.dart';
import 'package:doancuoiky/utils/fontConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ViewModels/Controller/CartController.dart';
import '../../ViewModels/Service/MockData.dart';

class Cart extends ConsumerStatefulWidget {
  const Cart({Key? key}):super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends ConsumerState<Cart> {
  @override
  void initState() {
    super.initState();

    // Future.microtask(() {
    //   // Lấy state user từ userProvider
    //   final userState = ref.read(userProvider);
    //
    //   // Kiểm tra nếu có dữ liệu
    //   if (userState.value != null) {
    //     final user = userState.value!;
    //     ref.read(cartProvider.notifier).getOrCreateCart(user.userId);
    //     print(user.userId);
    //   } else {
    //     print("User chưa được load");
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    bool delete=false;
    bool isChoose=true;

    final mockUser = MockData.user;
    final mockProduct = MockData.product;

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final cartState=ref.read(cartProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Center(
          child: Column(
            children: [
              Text(
                "Giỏ hàng (10)",
                style: TextStyle(fontSize: 15),
              ),
              Text(
                "Địa chỉ",
                style: TextStyle(fontSize: 10),
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
        actions: [
          delete==true?
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: GestureDetector(
              child: GestureDetector(
                child: Text(
                  "Xong",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ):
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: GestureDetector(
              child: GestureDetector(
                child: Text(
                  "Chỉnh sửa",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: cartState.value!.cartItems.length,
        itemBuilder: (context, index) {
          final cart=cartState.value!.cartItems;
          return Padding(
            padding: const EdgeInsets.only(bottom: 5, top: 2),
            child: CartItem(
              isChecked: true,
              image:
                  ConfigImage().imageCartItem(mockProduct.image!, width, height),
              name: mockProduct.name!,
              size: mockProduct.size.toString(),
              price:
                  ConfigCurrency().formatCurrency(mockProduct.price!).toString(),
              amount: 10,
              onPlus: () {},
              onMinus: () {},
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Row(
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                    activeColor: Colors.red,
                    value: true,
                    onChanged: (value) {

                    },
                ),
                Text("Tất cả", style: TextStyle(fontSize: 15, color: Colors.white),)
              ],
            ),
            Spacer(),
            isChoose==false?
            Container():
            Column(
              children: [
                Text("Tổng tiền:", style: TextStyle(color: Colors.white, fontSize: 12),),
                Text(ConfigCurrency().formatCurrency(mockProduct.price!),style: TextStyle(color: Colors.red),),
                Container(
                  decoration:BoxDecoration(
                      color: Colors.green[300],
                      borderRadius: BorderRadius.circular(5)
                  ),
                  padding: EdgeInsets.all(2),
                  child: Row(
                    children: [
                      Icon(Icons.delivery_dining_sharp, color: Colors.green[900],size: 15,),
                      Text(" FreeShip", style: TextStyle(fontSize: 10),)
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 80,
              height: 30,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),

                  ),
                  onPressed: () {

              }, child:
                  delete==false?
              Text("Mua ngay(1)", style: TextStyle(fontSize: 12, color: Colors.red),):
                  Text("Xóa(1)", style: TextStyle(fontSize: 12, color: Colors.red),)

              ),
            )
          ],
        ),
      ),
    );
  }
}
