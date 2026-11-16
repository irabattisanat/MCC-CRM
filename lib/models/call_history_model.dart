import 'package:cloud_firestore/cloud_firestore.dart';

class CallHistoryModel {
  final String id;
  final String customerId;
  final String employeeId;
  final String employeeName;
  final String status;
  final String feedback;
  final String remarks;
  final DateTime createdAt;
  final DateTime? followUpDate;

  CallHistoryModel({
    required this.id,
    required this.customerId,
    required this.employeeId,
    required this.employeeName,
    required this.status,
    required this.feedback,
    required this.remarks,
    required this.createdAt,
    this.followUpDate,
  });

  factory CallHistoryModel.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return CallHistoryModel(
      id: id,
      customerId: map['customerId'] ?? '',
      employeeId: map['employeeId'] ?? '',
      employeeName: map['employeeName'] ?? '',
      status: map['status'] ?? '',
      feedback: map['feedback'] ?? '',
      remarks: map['remarks'] ?? '',
      createdAt:
      (map['createdAt'] as Timestamp?)?.toDate() ??
          DateTime.now(),
      followUpDate:
      (map['followUpDate'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "customerId": customerId,
      "employeeId": employeeId,
      "employeeName": employeeName,
      "status": status,
      "feedback": feedback,
      "remarks": remarks,
      "createdAt": Timestamp.fromDate(createdAt),
      "followUpDate": followUpDate == null
          ? null
          : Timestamp.fromDate(followUpDate!),
    };
  }
}