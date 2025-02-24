import 'package:doancuoiky/ViewModels/Service/MockData.dart';
import 'package:doancuoiky/utils/fontConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
class UserInfo extends ConsumerStatefulWidget {
  const UserInfo({super.key});

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends ConsumerState<UserInfo> {
  final mockProduct=MockData.image;
  final TextEditingController _name=TextEditingController();
  final TextEditingController _email=TextEditingController();
  final TextEditingController _phoneNumber=TextEditingController();
  final TextEditingController _birthDay=TextEditingController();
  final TextEditingController _address=TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
    final height=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar:AppBar(
        title: Text("Thông tin tài khoản",style: TextStyle(fontSize: 20),),
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new, color: Colors.white,size: 20,)),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: width,
          height: height,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(
                  height: height*0.2,
                  child: ConfigImage().imageAvatar(MockData.image,width*0.4, height*0.2),
                ),
                SizedBox(height: height*0.03,),
                _CustomTextField(controller: _name, label: "Họ và Tên", hintText: "Nguyen Van A", icon: Icons.auto_fix_high_outlined,isCalendar: false,),
                SizedBox(height: 10,),
                _CustomTextField(controller: _email, label: "Email", hintText: "nguyenvana@gmail.com", icon: Icons.auto_fix_high_outlined,isCalendar: false,),
                SizedBox(height: 10,),
                _CustomTextField(controller: _name, label: "Số điện thoại", hintText: "0123456789", icon: Icons.auto_fix_high_outlined,isCalendar: false,),
                SizedBox(height: 10,),
                _CustomTextField(controller: _name, label: "Ngày sinh", hintText: "01/02/2025", icon: Icons.calendar_month_outlined,isCalendar: true,),
                SizedBox(height: 10,),
                _CustomTextField(controller: _name, label: "Địa chỉ", hintText: "123/45 A BV", icon: Icons.auto_fix_high_outlined,isCalendar: false,),
                SizedBox(height: 10,),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(45, 51, 107, 1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                    ),
                    onPressed: () {

                }, child: Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 3, left: 20,right: 20),
                  child: Text("Xác nhận", style: TextStyle(color: Colors.white, fontSize: 15),),
                ))

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData? icon;
  final bool isCalendar;

  const _CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.icon,
    required this.isCalendar
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () {
        if(isCalendar==true){
          selectDate(context);
        }
      },
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(width: 1),
        ),
        suffixIcon: icon != null
            ? Icon(icon, color: Colors.black) // Hiển thị icon nếu có
            : null,
      ),
    );
  }
  Future<String?> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Ngày mặc định
      firstDate: DateTime(1900), // Ngày sớm nhất
      lastDate: DateTime(2100), // Ngày muộn nhất
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(
          pickedDate); // Format ngày
      return formattedDate;
    }
    return null;
  }
}



