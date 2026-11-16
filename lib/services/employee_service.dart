import 'package:firebase_auth/firebase_auth.dart';

import '../models/customer_model.dart';
import '../models/employee_model.dart';

import 'firestore_service.dart';
import 'customer_service.dart';
import 'call_history_service.dart';

class EmployeeService {
  final FirestoreService _firestore = FirestoreService();

  final CustomerService _customerService = CustomerService();

  final CallHistoryService _callHistoryService =
  CallHistoryService();

  //=============================
  // Employees
  //=============================

  Future<List<EmployeeModel>> getEmployees() async {
    return await _firestore.getAllEmployees();
  }

  //=============================
  // Logged In Employee
  //=============================

  Future<Map<String, dynamic>?> getCurrentEmployee() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return await _firestore.getUser(uid);
  }

  //=============================
  // Assigned Customers
  //=============================

  Future<List<CustomerModel>> getAssignedCustomers() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return await _firestore.getCustomersByEmployee(uid);
  }

  //=============================
  // Save Call
  //=============================

  Future<void> saveCall({
    required CustomerModel customer,
    required String status,
    required String feedback,
    required String remarks,
  }) async {

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final employee =
    await _firestore.getUser(uid);

    await _customerService.updateCustomerCallDetails(
      customerId: customer.id,
      status: status,
      feedback: feedback,
      remarks: remarks,
    );

    await _callHistoryService.addCallHistory(
      customerId: customer.id,
      employeeId: uid,
      employeeName: employee?['name'] ?? "",
      status: status,
      feedback: feedback,
      remarks: remarks,
    );
  }
}