class EmployeeModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final bool isActive;

  EmployeeModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.isActive,
  });

  factory EmployeeModel.fromMap(
      String uid,
      Map<String, dynamic> map,
      ) {
    return EmployeeModel(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'isActive': isActive,
    };
  }
}