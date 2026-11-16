import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/employee_model.dart';
import '../models/customer_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUser(String uid) async {
    print("Trying to read user: $uid");

    final doc = await _firestore.collection('users').doc(uid).get();

    print("Document exists: ${doc.exists}");

    print("Document data: ${doc.data()}");

    return doc.data();
  }
  Future<int> getEmployeeCount() async {

    final snapshot = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'employee')
        .get();

    return snapshot.docs.length;
  }

  Future<int> getCustomerCount() async {

    final snapshot = await _firestore
        .collection('customers')
        .get();

    return snapshot.docs.length;
  }
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getEmployees() async {
    final snapshot = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'employee')
        .orderBy('name')
        .get();

    return snapshot.docs;
  }

  Future<void> addEmployee({
    required String uid,
    required String name,
    required String email,
    required String phone,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'phone': phone,
      'role': 'employee',
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
  Future<List<EmployeeModel>> getAllEmployees() async {
    final snapshot = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'employee')
        .orderBy('name')
        .get();

    return snapshot.docs
        .map(
          (doc) => EmployeeModel.fromMap(
        doc.id,
        doc.data(),
      ),
    )
        .toList();
  }
  Future<void> assignCustomer({
    required String customerId,
    required String employeeId,
    required String employeeName,
  }) async {
    await _firestore.collection('customers').doc(customerId).update({
      'assignedTo': employeeId,
      'assignedEmployeeName': employeeName,
    });
  }
  Future<List<CustomerModel>> getCustomersByEmployee(String employeeId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('customers')
        .where('assignedTo', isEqualTo: employeeId)
        .get();

    return snapshot.docs
        .map(
          (doc) => CustomerModel.fromMap(
        doc.id,
        doc.data(),
      ),
    )
        .toList();
  }
}