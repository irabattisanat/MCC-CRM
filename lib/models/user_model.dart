class UserModel {

  final String uid;
  final String name;
  final String email;
  final String role;
  final String phone;
  final bool isActive;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    required this.isActive,
  });

  factory UserModel.fromMap(
      String uid,
      Map<String, dynamic> map,
      ) {

    return UserModel(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      phone: map['phone'] ?? '',
      isActive: map['isActive'] ?? true,
    );
  }

}