import 'package:doancuoiky/View/Customer/Widget/FeedBackItem.dart';
import 'package:doancuoiky/View/Customer/Widget/ItemProduct.dart';
import 'package:doancuoiky/utils/fontConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../ViewModels/Service/MockData.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final mockUser = MockData.user;
    final mockProduct = MockData.product;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 20,
            )),
        title: Text(
          "Chi tiết sản phẩm",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
                child: ConfigImage()
                    .imageProductDetail(mockProduct.image!, width, height)),
            SizedBox(
              height: 10,
            ),
            Container(
              width: width,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mockProduct.name!,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      ConfigCurrency().formatCurrency(mockProduct.price!),
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      mockProduct.description!,
                      style: TextStyle(fontSize: 15),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.yellowAccent,
                        ),
                        Text(
                          " 4/5 (100)",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Đã bán: 200",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(1, 1, 1, 0.5)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
                color: Colors.white,
                width: width,
                height: height*(0.1*10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Đánh giá khách hàng (100)",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      child: ListView.builder(
                        itemCount: 10,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return FeedBackItem(
                              name: "name", star: 2, content: "contenteee");
                        },
                      ),
                    )
                  ],
                )),
            SizedBox(height: 10),
            SizedBox(
              height: height*(0.35*5),
              child: Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: 10,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    childAspectRatio: 0.67),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: ItemProduct(
                      name: mockProduct.name!,
                      image: ConfigImage()
                          .imageProduct(mockProduct.image!, width, height),
                      price: mockProduct.price.toString(),
                      star: 3,
                      scales: 300,
                      onPress: () {},
                    ),
                  );
                },
              )),
            ),
            SizedBox(
              // height: height,
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Spacer(),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.only(top: 2, bottom: 2, right: 20, left: 20),
                    backgroundColor: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () {},
                child: Text(
                  "Thêm vào\n giỏ hàng",
                  style: TextStyle(color: Colors.black),
                )),
            SizedBox(
              width: 10,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.only(top: 2, bottom: 2, right: 20, left: 20),
                    backgroundColor: Colors.red[400],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () {},
                child: Text(
                  "Mua ngay",
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
      ),
    );
  }
}
