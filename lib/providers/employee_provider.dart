import 'package:flutter/material.dart';

import '../models/customer_model.dart';
import '../models/employee_model.dart';

import '../repositories/employee_repository.dart';

class EmployeeProvider extends ChangeNotifier {
  final EmployeeRepository _repository = EmployeeRepository();

  // ============================
  // EMPLOYEE
  // ============================

  EmployeeModel? _employee;

  EmployeeModel? get employee => _employee;

  // ============================
  // ASSIGNED CUSTOMERS
  // ============================

  List<CustomerModel> _customers = [];

  List<CustomerModel> get customers => _customers;

  // ============================
  // LOADING
  // ============================

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // ============================
  // QUEUE INDEX
  // ============================

  int _currentIndex = 0;

  // ============================
  // CURRENT CUSTOMER
  // ============================

  CustomerModel? get currentCustomer {
    if (_customers.isEmpty) return null;

    if (_currentIndex >= _customers.length) return null;

    return _customers[_currentIndex];
  }

  // ============================
// QUEUE INFO
// ============================

  int get currentIndex => _currentIndex;

  int get queueLength => _customers.length;

  bool get hasCustomers => _customers.isNotEmpty;

  bool get hasNextCustomer =>
      _currentIndex < _customers.length - 1;

  double get progress {
    if (_customers.isEmpty) return 0;

    return (_currentIndex + 1) / _customers.length;
  }

  CustomerModel? get nextCustomer {
    if (!hasNextCustomer) return null;

    return _customers[_currentIndex + 1];
  }

  // ============================
  // DASHBOARD COUNTS
  // ============================

  int get totalCustomers => _customers.length;

  int get pendingCustomers =>
      _customers.where((c) => c.status == "Pending").length;

  int get interestedCustomers =>
      _customers.where((c) => c.status == "Interested").length;

  int get followUpCustomers =>
      _customers.where((c) => c.status == "Follow Up").length;

  int get notInterestedCustomers =>
      _customers.where((c) => c.status == "Not Interested").length;

  // ============================
  // LOAD DASHBOARD
  // ============================

  Future<void> loadDashboard() async {
    _isLoading = true;

    notifyListeners();

    try {
      final user = await _repository.getCurrentEmployee();

      if (user != null) {
        _employee = EmployeeModel(
          uid: "",
          name: user["name"] ?? "",
          email: user["email"] ?? "",
          phone: user["phone"] ?? "",
          isActive: user["isActive"] ?? true,
        );
      }

      _customers = await _repository.getAssignedCustomers();

      _currentIndex = 0;
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  // ============================
  // SAVE CALL
  // ============================

  Future<void> saveCall({
    required CustomerModel customer,
    required String status,
    required String feedback,
    required String remarks,
  }) async {
    await _repository.saveCall(
      customer: customer,
      status: status,
      feedback: feedback,
      remarks: remarks,
    );

    await loadDashboard();
  }
  // ============================
// SAVE & NEXT
// ============================

  Future<bool> saveAndNext({
    required String status,
    required String feedback,
    required String remarks,
  }) async {

    final customer = currentCustomer;

    if (customer == null) {
      return false;
    }

    await saveCall(
      customer: customer,
      status: status,
      feedback: feedback,
      remarks: remarks,
    );

    // Reload latest data
    _customers = await _repository.getAssignedCustomers();

    _customers = _customers
        .where((c) => c.status == "Pending")
        .toList();

    // Keep only pending customers in the queue
    _customers = _customers
        .where((c) => c.status == "Pending")
        .toList();

    if (_currentIndex >= _customers.length) {
      notifyListeners();
      return false;
    }

    notifyListeners();

    return true;
  }

  // ============================
  // NEXT CUSTOMER
  // ============================

  bool moveToNextCustomer() {
    if (!hasNextCustomer) {
      return false;
    }

    _currentIndex++;

    notifyListeners();

    return true;
  }

  // ============================
  // PREVIOUS CUSTOMER
  // ============================

  bool moveToPreviousCustomer() {
    if (_currentIndex == 0) {
      return false;
    }

    _currentIndex--;

    notifyListeners();

    return true;
  }

  // ============================
  // RESET QUEUE
  // ============================

  void resetQueue() {
    _currentIndex = 0;

    notifyListeners();
  }

  // ============================
  // QUEUE STATUS
  // ============================

  bool get isQueueFinished =>
      _currentIndex >= _customers.length - 1;

  int get remainingCustomers =>
      _customers.length - _currentIndex;
}