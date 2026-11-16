import 'package:flutter/material.dart';

import '../../models/customer_model.dart';
import '../../models/employee_model.dart';
import '../../services/firestore_service.dart';

class AssignEmployeeScreen extends StatefulWidget {
  final CustomerModel customer;

  const AssignEmployeeScreen({
    super.key,
    required this.customer,
  });

  @override
  State<AssignEmployeeScreen> createState() => _AssignEmployeeScreenState();
}

class _AssignEmployeeScreenState extends State<AssignEmployeeScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  List<EmployeeModel> employees = [];

  EmployeeModel? selectedEmployee;

  bool isLoading = true;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    loadEmployees();
  }

  Future<void> loadEmployees() async {
    employees = await _firestoreService.getAllEmployees();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> assignEmployee() async {
    if (selectedEmployee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select an employee."),
        ),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    await _firestoreService.assignCustomer(
      customerId: widget.customer.id,
      employeeId: selectedEmployee!.uid,
      employeeName: selectedEmployee!.name,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Customer assigned successfully."),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assign Employee"),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.customer.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(widget.customer.phone),

            const SizedBox(height: 30),

            DropdownButtonFormField<EmployeeModel>(
              decoration: const InputDecoration(
                labelText: "Select Employee",
                border: OutlineInputBorder(),
              ),
              value: selectedEmployee,
              items: employees.map((employee) {
                return DropdownMenuItem(
                  value: employee,
                  child: Text(employee.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedEmployee = value;
                });
              },
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isSaving ? null : assignEmployee,
                child: isSaving
                    ? const CircularProgressIndicator()
                    : const Text("Assign"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}