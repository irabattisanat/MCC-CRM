import 'dart:async';

import 'package:flutter/material.dart';

import '../models/customer_model.dart';
import '../repositories/customer_repository.dart';
import '../services/customer_service.dart';

class CustomerProvider extends ChangeNotifier {

  final CustomerService _customerService = CustomerService();
  final CustomerRepository _repository = CustomerRepository();

  StreamSubscription<List<CustomerModel>>? _customerSubscription;

  // ============================
  // ALL CUSTOMERS
  // ============================

  List<CustomerModel> _customers = [];

  List<CustomerModel> get customers => _customers;

  // ============================
  // FILTERED CUSTOMERS
  // ============================

  List<CustomerModel> _filteredCustomers = [];

  List<CustomerModel> get filteredCustomers => _filteredCustomers;

  // ============================
  // LOADING
  // ============================

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // ============================
  // SEARCH
  // ============================

  String _searchKeyword = "";

  String get searchKeyword => _searchKeyword;

  // ============================
  // FILTERS
  // ============================

  String _selectedSchool = "All";

  String get selectedSchool => _selectedSchool;

  String _selectedGender = "All";

  String get selectedGender => _selectedGender;

  String _selectedStatus = "All";

  String get selectedStatus => _selectedStatus;

  // ============================
  // SELECTION
  // ============================

  final Set<String> _selectedCustomerIds = {};

  Set<String> get selectedCustomerIds => _selectedCustomerIds;

  bool _selectionMode = false;

  bool get selectionMode => _selectionMode;

  // ============================
  // START LISTENING
  // ============================

  void startListening() {
    _isLoading = true;
    notifyListeners();

    _customerSubscription?.cancel();

    _customerSubscription =
        _repository.getCustomersStream().listen((customers) {
          _customers = customers;

          _applyFilters();

          _isLoading = false;

          notifyListeners();
        });
  }

  // ============================
  // STOP LISTENING
  // ============================

  void stopListening() {
    _customerSubscription?.cancel();
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }

  // ============================
  // SEARCH
  // ============================

  void search(String keyword) {
    _searchKeyword = keyword;
    _applyFilters();
  }

  // ============================
  // FILTERS
  // ============================

  void setSchool(String school) {
    _selectedSchool = school;
    _applyFilters();
  }

  void setGender(String gender) {
    _selectedGender = gender;
    _applyFilters();
  }

  void setStatus(String status) {
    _selectedStatus = status;
    _applyFilters();
  }

  void clearFilters() {
    _searchKeyword = "";
    _selectedSchool = "All";
    _selectedGender = "All";
    _selectedStatus = "All";

    _applyFilters();
  }

  // ============================
  // APPLY FILTERS
  // ============================

  void _applyFilters() {
    _filteredCustomers = _customers.where((customer) {
      final matchesSearch =
          customer.name.toLowerCase().contains(_searchKeyword.toLowerCase()) ||
              customer.phone.contains(_searchKeyword) ||
              customer.schoolName
                  .toLowerCase()
                  .contains(_searchKeyword.toLowerCase());

      final matchesSchool =
          _selectedSchool == "All" ||
              customer.schoolName == _selectedSchool;

      final matchesGender =
          _selectedGender == "All" ||
              customer.gender == _selectedGender;

      final matchesStatus =
          _selectedStatus == "All" ||
              customer.status == _selectedStatus;

      return matchesSearch &&
          matchesSchool &&
          matchesGender &&
          matchesStatus;
    }).toList();

    notifyListeners();
  }

  // ============================
  // SELECTION
  // ============================

  void toggleSelection(String id) {
    if (_selectedCustomerIds.contains(id)) {
      _selectedCustomerIds.remove(id);
    } else {
      _selectedCustomerIds.add(id);
    }

    _selectionMode = _selectedCustomerIds.isNotEmpty;

    notifyListeners();
  }

  bool isSelected(String id) {
    return _selectedCustomerIds.contains(id);
  }

  void clearSelection() {
    _selectedCustomerIds.clear();
    _selectionMode = false;

    notifyListeners();
  }

  void selectAllFiltered() {
    _selectedCustomerIds.clear();

    for (final customer in _filteredCustomers) {
      _selectedCustomerIds.add(customer.id);
    }

    _selectionMode = true;

    notifyListeners();
  }

  // ============================
  // CRUD
  // ============================

  Future<void> addCustomer({
    required String name,
    required String phone,
    required String schoolName,
    required String gender,
    required String city,
  }) async {
    await _repository.addCustomer(
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
  }) async {
    await _repository.updateCustomer(
      documentId: documentId,
      name: name,
      phone: phone,
      schoolName: schoolName,
      gender: gender,
      city: city,
    );
  }

  Future<void> deleteCustomer(String id) async {
    await _repository.deleteCustomer(id);
  }
  Future<void> bulkAssignCustomers({
    required String employeeId,
    required String employeeName,
  }) async {

    await _repository.bulkAssignCustomers(
      customerIds: _selectedCustomerIds.toList(),
      employeeId: employeeId,
      employeeName: employeeName,
    );

    clearSelection();
  }
  Future<void> deleteSelectedCustomers() async {

    await _customerService.deleteCustomers(
      selectedCustomerIds.toList(),
    );

    clearSelection();
  }
}