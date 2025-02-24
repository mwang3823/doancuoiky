import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderItem extends StatelessWidget {
  final Widget image;
  final String name;
  final String size;
  final String price;
  final int amount;
  final VoidCallback onPlus;
  final VoidCallback onMinus;

  const OrderItem(
      {super.key,
        required this.image,
        required this.name,
        required this.size,
        required this.price,
        required this.amount,
        required this.onPlus,
        required this.onMinus});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 15,bottom: 15),
        child: Row(
          children: [
            image,
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text("Size: $size", style: TextStyle(fontSize: 10)),
                  Text(
                    "Giá: $price",
                    style: TextStyle(
                        fontSize: 10, color: Color.fromRGBO(1, 1, 1, 0.5)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 25,
                      height: 20,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: onMinus,
                        child: Text(
                          "-",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                    SizedBox(width: 25, height: 20, child: Center(child: Text("2"))),
                    SizedBox(
                      width: 25,
                      height: 20,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: onPlus,
                        child: Text(
                          "+",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
