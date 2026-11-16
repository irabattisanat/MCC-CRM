import 'package:flutter/material.dart';

import '../../models/employee_model.dart';
import '../../services/employee_service.dart';

class BulkAssignDialog extends StatefulWidget {
  const BulkAssignDialog({super.key});

  @override
  State<BulkAssignDialog> createState() => _BulkAssignDialogState();
}

class _BulkAssignDialogState extends State<BulkAssignDialog> {

  final EmployeeService _employeeService = EmployeeService();

  List<EmployeeModel> employees = [];

  EmployeeModel? selectedEmployee;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadEmployees();
  }

  Future<void> loadEmployees() async {

    employees = await _employeeService.getEmployees();

    setState(() {
      isLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(

      title: const Text("Assign Customers"),

      content: SizedBox(
        width: 350,

        child: isLoading

            ? const Center(
          child: CircularProgressIndicator(),
        )

            : ListView.builder(

          shrinkWrap: true,

          itemCount: employees.length,

          itemBuilder: (context, index) {

            final employee = employees[index];

            return RadioListTile<EmployeeModel>(

              title: Text(employee.name),

              subtitle: Text(employee.email),

              value: employee,

              groupValue: selectedEmployee,

              onChanged: (value) {

                setState(() {

                  selectedEmployee = value;

                });

              },

            );

          },

        ),

      ),

      actions: [

        TextButton(

          onPressed: () {

            Navigator.pop(context);

          },

          child: const Text("Cancel"),

        ),

        ElevatedButton(

          onPressed: selectedEmployee == null

              ? null

              : () {

            Navigator.pop(context, selectedEmployee);

          },

          child: const Text("Assign"),

        ),

      ],

    );

  }

}