import 'package:doancuoiky/utils/fontConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ItemProduct extends StatelessWidget {
  final Widget image;
  final String name;
  final String price;
  final int star;
  final int scales;
  final VoidCallback onPress;

  const ItemProduct(
      {super.key,
      required this.name,
      required this.image,
      required this.price,
      required this.star,
      required this.scales,
      required this.onPress});


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black)
          // color: Colors.black
          ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: image,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  name,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  ConfigCurrency().formatCurrency(int.parse(price)),
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Row(
              children: [
                Container(
                  decoration:BoxDecoration(
                    color: Colors.green[300],
                    borderRadius: BorderRadius.circular(5)
                  ),
                  padding: EdgeInsets.all(2),
                  child: Row(
                    children: [
                      Icon(Icons.delivery_dining_sharp, color: Colors.green[900],size: 20,),
                      Text(" FreeShip", style: TextStyle(fontSize: 10),)
                    ],
                  ),
                ),
                SizedBox(width: 5),
                Container(
                  decoration:BoxDecoration(
                      color: Colors.red[200],
                      borderRadius: BorderRadius.circular(5)
                  ),
                  padding: EdgeInsets.all(2),
                  child: Row(
                    children: [
                      SizedBox(height: 21,),
                      Text("Giảm giá %", style: TextStyle(fontSize: 10,color: Colors.red[900]),)
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.yellowAccent,size: 20,),
                Text(star.toString(), style: TextStyle(fontSize: 12),),
                SizedBox(width: 10,),
                Text("Đã bán: $scales", style: TextStyle(fontSize: 10,color: Color.fromRGBO(1, 1, 1, 0.5)),)
              ],
            ),
          )
        ],
      ),
    );
  }
}
