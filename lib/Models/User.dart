class UserModel {
  final String userId;
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
        fullName: json['fullName'] ?? '',
        email: json['email'] ?? '',
        phoneNumber: json['phoneNumber'] ?? '',
        birthday: json['birthday'] ?? '',
        password: json['password'] ?? '',
        address: json['address'] ?? '',
        userId: json['user_id'] ?? ''
    );
  }
}