import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/call_history_model.dart';

class CallHistoryService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> addCallHistory({
    required String customerId,
    required String employeeId,
    required String employeeName,
    required String status,
    required String feedback,
    required String remarks,
    DateTime? followUpDate,
  }) async {
    await _firestore.collection("call_history").add({
      "customerId": customerId,
      "employeeId": employeeId,
      "employeeName": employeeName,
      "status": status,
      "feedback": feedback,
      "remarks": remarks,
      "createdAt": FieldValue.serverTimestamp(),
      "followUpDate": followUpDate == null
          ? null
          : Timestamp.fromDate(followUpDate),
    });
  }
  Future<List<CallHistoryModel>> getCustomerHistory(
      String customerId,
      ) async {

    final snapshot = await _firestore
        .collection("call_history")
        .where(
      "customerId",
      isEqualTo: customerId,
    )
        .orderBy(
      "createdAt",
      descending: true,
    )
        .get();

    return snapshot.docs
        .map(
          (doc) => CallHistoryModel.fromMap(
        doc.id,
        doc.data(),
      ),
    )
        .toList();
  }
}