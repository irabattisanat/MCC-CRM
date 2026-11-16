import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/customer_model.dart';
import '../../models/call_history_model.dart';

import '../../services/customer_service.dart';
import '../../services/firestore_service.dart';
import '../../services/call_history_service.dart';

import '../../widgets/employee_customer_form.dart';
import '../../widgets/call_history_card.dart';

class EmployeeCustomerDetailsScreen extends StatefulWidget {
  final CustomerModel customer;

  const EmployeeCustomerDetailsScreen({
    super.key,
    required this.customer,
  });

  @override
  State<EmployeeCustomerDetailsScreen> createState() =>
      _EmployeeCustomerDetailsScreenState();
}

class _EmployeeCustomerDetailsScreenState
    extends State<EmployeeCustomerDetailsScreen> {

  final CustomerService _customerService = CustomerService();
  final FirestoreService _firestoreService = FirestoreService();
  final CallHistoryService _callHistoryService = CallHistoryService();

  List<CallHistoryModel> history = [];

  bool loadingHistory = true;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    history = await _callHistoryService.getCustomerHistory(
      widget.customer.id,
    );

    if (!mounted) return;

    setState(() {
      loadingHistory = false;
    });
  }

  Future<void> saveCustomer(
      String status,
      String feedback,
      String remarks,
      ) async {

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final employee =
    await _firestoreService.getUser(uid);

    await _customerService.updateCustomerCallDetails(
      customerId: widget.customer.id,
      status: status,
      feedback: feedback,
      remarks: remarks,
    );

    await _callHistoryService.addCallHistory(
      customerId: widget.customer.id,
      employeeId: uid,
      employeeName: employee?['name'] ?? '',
      status: status,
      feedback: feedback,
      remarks: remarks,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Customer updated successfully",
        ),
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Details"),
      ),

      body: EmployeeCustomerForm(
        customer: widget.customer,

        onSave: saveCustomer,

        bottomWidget: loadingHistory
            ? const Padding(
          padding: EdgeInsets.all(24),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
            : Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            const Divider(),

            const SizedBox(height: 15),

            const Text(
              "Call History",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            if (history.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "No call history available.",
                  ),
                ),
              ),

            ...history.map(
                  (call) => CallHistoryCard(
                history: call,
              ),
            ),
          ],
        ),
      ),
    );
  }
}