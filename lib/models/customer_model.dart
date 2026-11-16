class CustomerModel {
  final String id;
  final String name;
  final String phone;
  final String city;

  final String assignedTo;
  final String assignedEmployeeName;

  final String status;
  final String feedback;
  final String remarks;

  final String schoolName;
  final String gender;

  CustomerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.schoolName,
    required this.gender,
    required this.city,
    required this.assignedTo,
    required this.assignedEmployeeName,
    required this.status,
    required this.feedback,
    required this.remarks,
  });

  factory CustomerModel.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return CustomerModel(
      id: id,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      schoolName: map['schoolName'] ?? '',
      gender: map['gender'] ?? '',
      city: map['city'] ?? '',
      assignedTo: map['assignedTo'] ?? '',
      assignedEmployeeName: map['assignedEmployeeName'] ?? '',
      status: map['status'] ?? 'Pending',
      feedback: map['feedback'] ?? '',
      remarks: map['remarks'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      "schoolName": schoolName,
      "gender": gender,
      'city': city,
      'assignedTo': assignedTo,
      'assignedEmployeeName': assignedEmployeeName,
      'status': status,
      'feedback': feedback,
      'remarks': remarks,
    };
  }
}