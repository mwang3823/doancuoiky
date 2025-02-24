import 'package:doancuoiky/View/Customer/Cart.dart';
import 'package:doancuoiky/View/Customer/Widget/ItemProduct.dart';
import 'package:doancuoiky/ViewModels/Service/MockData.dart';
import 'package:doancuoiky/ViewModels/Service/ProductService.dart';
import 'package:doancuoiky/utils/fontConfig.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_icons/simple_icons.dart';
import '../../ViewModels/Controller/ProductController.dart';
class ProductListScreen extends ConsumerStatefulWidget {
   ProductListScreen({Key? key}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        ref.read(listProductProvider.notifier).getAllProduct());
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final productState = ref.watch(listProductProvider);
    final a=ProductService();
    return Scaffold(
      appBar: AppBar(
        title: Text("Trang chủ"),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.supervised_user_circle_outlined,
                  color: Colors.blue, size: 30)),
          IconButton(
              onPressed: () async{
                Navigator.push(context, MaterialPageRoute(builder: (context) => Cart(),));
              },
              icon: Icon(Icons.shopping_cart, color: Colors.blue, size: 30)),
        ],
      ),
      drawer: _buildDrawer(width,height),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: productState.when(
              loading: () => Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text("Lỗi: $err")),
              data: (products) {
                if (products.isEmpty) {
                  return Center(child: Text("Không có sản phẩm nào."));
                }
                return GridView.builder(
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                      childAspectRatio: 0.67),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: ItemProduct(
                        name: product?.name ?? "Không có tên",
                        image: ConfigImage().imageProduct(
                            product?.image ?? "", width, height),
                        price: product?.price.toString() ?? "0",
                        star: 3,
                        scales: 300,
                        onPress: () {},
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 10),
      child: SizedBox(
        height: 35,
        child: SearchBar(
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(color: Colors.black, width: 0.8))),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          onSubmitted: (value) {},
          leading: Icon(Icons.search),
          trailing: [
            Text(
              "Tìm kiếm",
              style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.3)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(double width, double height) {
    return Drawer(
      width: width * 0.7,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 50, left: 10, right: 10, bottom: 30),
            color: Color.fromRGBO(45, 51, 107, 1),
            child: Row(
              children: [
                Container(child: ConfigImage().imageAvatar(MockData.image,50,50)),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(MockData.user.fullName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                    Text(MockData.user.email,
                        style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),
          _buildDrawerItem(SimpleIcons.homeassistantcommunitystore, "Trang chủ"),
          _buildDrawerItem(SimpleIcons.informatica, "Thông tin tài khoản"),
          _buildDrawerItem(SimpleIcons.wikibooks, "Danh sách đơn hàng"),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Text("Đăng xuất", style: TextStyle(color: Colors.black)),
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget _buildDrawerItem(IconData icon, String title) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.blue),
            SizedBox(width: 10),
            Text(title,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
      onTap: () {},
    );
  }
}
