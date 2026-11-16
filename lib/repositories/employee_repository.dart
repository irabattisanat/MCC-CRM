import '../models/customer_model.dart';
import '../models/employee_model.dart';

import '../services/employee_service.dart';

class EmployeeRepository {
  final EmployeeService _service = EmployeeService();

  // =============================
  // EMPLOYEES
  // =============================

  Future<List<EmployeeModel>> getEmployees() async {
    return await _service.getEmployees();
  }

  // =============================
  // CURRENT EMPLOYEE
  // =============================

  Future<Map<String, dynamic>?> getCurrentEmployee() async {
    return await _service.getCurrentEmployee();
  }

  // =============================
  // ASSIGNED CUSTOMERS
  // =============================

  Future<List<CustomerModel>> getAssignedCustomers() async {
    return await _service.getAssignedCustomers();
  }

  // =============================
  // SAVE CALL
  // =============================

  Future<void> saveCall({
    required CustomerModel customer,
    required String status,
    required String feedback,
    required String remarks,
  }) async {
    await _service.saveCall(
      customer: customer,
      status: status,
      feedback: feedback,
      remarks: remarks,
    );
  }
}