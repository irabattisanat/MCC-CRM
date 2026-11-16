import '../models/customer_model.dart';
import '../services/customer_service.dart';

class CustomerRepository {
  final CustomerService _customerService = CustomerService();

  Future<List<CustomerModel>> getCustomers() {
    return _customerService.getCustomers();
  }

  Future<void> addCustomer({
    required String name,
    required String phone,
    required String schoolName,
    required String gender,
    required String city,
  }) {
    return _customerService.addCustomer(
      name: name,
      phone: phone,
      schoolName: schoolName,
      gender: gender,
      city: city,
    );
  }

  Future<void> updateCustomer({
    required String documentId,
    required String name,
    required String phone,
    required String schoolName,
    required String gender,
    required String city,
  }) {
    return _customerService.updateCustomer(
      documentId: documentId,
      name: name,
      phone: phone,
      schoolName: schoolName,
      gender: gender,
      city: city,
    );
  }

  Future<void> deleteCustomer(String documentId) {
    return _customerService.deleteCustomer(documentId);
  }

  Stream<List<CustomerModel>> getCustomersStream() {
    return _customerService.getCustomersStream();
  }
  Future<void> bulkAssignCustomers({
    required List<String> customerIds,
    required String employeeId,
    required String employeeName,
  }) {
    return _customerService.bulkAssignCustomers(
      customerIds: customerIds,
      employeeId: employeeId,
      employeeName: employeeName,
    );
  }
}