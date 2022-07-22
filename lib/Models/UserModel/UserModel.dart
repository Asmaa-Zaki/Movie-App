class UserModel {
   String? name, email, password, phone;
   late String userId;

  UserModel(
      {required this.userId,
      this.name,
      this.email,
      this.password,
      this.phone,
      });

  UserModel.fromJson(Map<String, dynamic> map) {
    userId = map['userId'];
    name = map['name'];
    email = map['email'];
    password = map['password'];
    phone = map['phone'];
  }

  toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
    };
  }
}
