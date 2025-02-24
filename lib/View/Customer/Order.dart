import 'package:doancuoiky/View/Customer/Widget/OrderItem.dart';
import 'package:doancuoiky/utils/fontConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../ViewModels/Service/MockData.dart';

class Order extends StatelessWidget {
  const Order({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final mockUser = MockData.user;
    final mockProduct = MockData.product;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          "Tóm tắt yêu cầu",
          style: TextStyle(fontSize: 20),
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              width: width,
              child: Padding(
                padding: const EdgeInsets.only(top: 10,bottom: 10),
                child: Row(
                  children: [
                    Icon(Icons.location_on_outlined),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                "${mockUser.fullName} - (+84)${mockUser.phoneNumber}"),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Địa chỉ: ${mockUser.address}",
                              style: TextStyle(fontSize: 12),
                              // softWrap: true,
                            ),
                          )
                        ],
                      ),
                    ),
                    // Spacer(),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ))
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              height: height*(0.12*1),
              child: ListView.builder(
                physics:BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: 1  ,
                itemBuilder: (context, index) {
                  return OrderItem(
                    image: ConfigImage()
                        .imageCartItem(mockProduct.image!, width, height),
                    name: mockProduct.name!,
                    size: mockProduct.size.toString(),
                    price: ConfigCurrency()
                        .formatCurrency(mockProduct.price!)
                        .toString(),
                    amount: 10,
                    onPlus: () {},
                    onMinus: () {},
                  );
                },
              ),
            ),
            SizedBox(height: 10,),
            Container(
              color: Colors.white,
              width: width,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tóm tắt chi phí", style: TextStyle(fontWeight:  FontWeight.bold),),
                    Row(
                      children: [
                        Text("Tổng thu ban đầu:"),
                        Spacer(),
                        Text(ConfigCurrency()
                            .formatCurrency(mockProduct.price!)
                            .toString())
                      ],
                    ),
                    Row(
                      children: [
                        Text("Vận chuyển:"),
                        Spacer(),
                        Text(ConfigCurrency()
                            .formatCurrency(mockProduct.price!)
                            .toString())
                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text("Tổng:"),
                        Spacer(),
                        Text(ConfigCurrency()
                            .formatCurrency(mockProduct.price!)
                            .toString())
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              color: Colors.green[300],
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Đảm bảo giao: 11 thg 30",style: TextStyle(fontWeight: FontWeight.bold),),
                        Text("Vận chuyển tiêu chuẩn"),
                      ],
                    ),
                  ),
                  Spacer(),
                  Text("FreeShip", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[900]),)
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              color: Colors.white,
              width: width,
              child: Padding(
                padding: const EdgeInsets.only(left: 15,right: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Phương thức thanh toán", style: TextStyle(fontWeight: FontWeight.bold),),
                    Row(
                      children: [
                        Icon(Icons.currency_exchange_rounded,color: Colors.green, size: 30,),
                        SizedBox(width: 10,),
                        Text("Thanh toán khi nhận hàng"),
                        Spacer(),
                        Checkbox(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          activeColor: Colors.green[900],
                          value: true,
                          onChanged: (value) {

                        },
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.payments_outlined,color: Colors.blue, size: 30,),
                        SizedBox(width: 10,),
                        Text("Thanh toán ZaloPay"),
                        Spacer(),
                        Checkbox(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          activeColor: Colors.blue[900],
                          value: true,
                          onChanged: (value) {

                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: height*.1,)
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          children: [
            Spacer(),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Tổng(1 mặt hàng):",style: TextStyle(color: Colors.black),),
                    Text(ConfigCurrency()
                        .formatCurrency(mockProduct.price!)
                        .toString(),style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)
                  ],
                ),
                SizedBox(width: 10,),
                ElevatedButton(onPressed: () {

                }, child: Text("Đặt hàng",style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.only(top: 0,bottom: 0,left: 10,right: 10),
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                )
                  ,)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
