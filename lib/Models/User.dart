class UserModel {
  final int userId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String birthday;
  final String password;
  final String address;

  UserModel({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.birthday,
    required this.password,
    required this.address,
    required this.userId
  });


  factory UserModel.formJson(Map<String, dynamic> json){
    return UserModel(
        fullName: json['fullname'] ?? '',
        email: json['email'] ?? '',
        phoneNumber: json['phonenumber'] ?? '',
        birthday: json['birthday'] ?? '',
        password: json['password'] ?? '',
        address: json['address'] ?? '',
        userId: json['ID']
    );
  }
}