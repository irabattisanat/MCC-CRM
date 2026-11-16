import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/customer_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CustomerModel>> getCustomers() async {
    final snapshot = await _firestore.collection('customers').get();

    return snapshot.docs
        .map((doc) => CustomerModel.fromMap(doc.id, doc.data()))
        .toList();
  }
  Stream<List<CustomerModel>> getCustomersStream() {
    return _firestore
        .collection('customers')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => CustomerModel.fromMap(
          doc.id,
          doc.data(),
        ),
      )
          .toList(),
    );
  }

  // Stream<List<CustomerModel>> getCustomersStream() {
  //   return _firestore
  //       .collection('customers')
  //       .orderBy('createdAt', descending: true)
  //       .snapshots()
  //       .map(
  //         (snapshot) => snapshot.docs
  //         .map(
  //           (doc) => CustomerModel.fromMap(
  //         doc.id,
  //         doc.data(),
  //       ),
  //     )
  //         .toList(),
  //   );
  // }

Future<void> addCustomer({
required String name,
required String phone,
required String schoolName,
required String gender,
required String city,
})  async {
    await _firestore.collection('customers').add({
      "name": name,
      "phone": phone,
      "schoolName": schoolName,
      "gender": gender,
      "city": city,
      "assignedTo": "",
      "assignedEmployeeName": "",
      "status": "Pending",
      "feedback": "",
      "remarks": "",
      "createdAt": Timestamp.now(),
    });
  }

  Future<void> updateCustomer({
    required String documentId,
    required String name,
    required String phone,
    required String schoolName,
    required String gender,
    required String city,
  }) async {
    await _firestore.collection("customers").doc(documentId).update({
      "name": name,
      "phone": phone,
      "schoolName": schoolName,
      "gender": gender,
      "city": city,
    });
  }

  Future<void> deleteCustomer(String documentId) async {
    await _firestore.collection("customers").doc(documentId).delete();
  }

  Future<void> updateCustomerCallDetails({
    required String customerId,
    required String status,
    required String feedback,
    required String remarks,
  }) async {
    await _firestore
        .collection('customers')
        .doc(customerId)
        .update({
      'status': status,
      'feedback': feedback,
      'remarks': remarks,
    });
  }
  Future<void> bulkAssignCustomers({
    required List<String> customerIds,
    required String employeeId,
    required String employeeName,
  }) async {

    final batch = _firestore.batch();

    for (final customerId in customerIds) {

      final docRef = _firestore
          .collection("customers")
          .doc(customerId);

      batch.update(docRef, {
        "assignedTo": employeeId,
        "assignedEmployeeName": employeeName,
      });

    }

    await batch.commit();
  }
  Future<void> deleteCustomers(List<String> ids) async {

    final batch = FirebaseFirestore.instance.batch();

    for (final id in ids) {
      batch.delete(
        FirebaseFirestore.instance
            .collection("customers")
            .doc(id),
      );
    }

    await batch.commit();
  }
}