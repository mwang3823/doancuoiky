import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedBackItem extends StatelessWidget {
  final String name;
  final int star;
  final String content;

  const FeedBackItem(
      {super.key,
      required this.name,
      required this.star,
      required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10,left: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("name",style: TextStyle(fontWeight: FontWeight.bold),),
            Row(
              children:
                List.generate(
                  star,
                  (index) => Icon(
                    Icons.star,
                    color: Colors.yellowAccent,
                    size: 20,
                  ),
                )
            ),
            Text(content,maxLines: 5,softWrap: true,)
          ],
        ),
      ),
    );
  }
}
