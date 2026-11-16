import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_router.dart';
import '../../models/employee_model.dart';
import '../../services/employee_service.dart';
import '../../widgets/employee_card.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final EmployeeService _employeeService = EmployeeService();

  List<EmployeeModel> employees = [];
  List<EmployeeModel> filteredEmployees = [];

  bool isLoading = true;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadEmployees();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadEmployees() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await _employeeService.getEmployees();

      setState(() {
        employees = data;
        filteredEmployees = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  void searchEmployee(String value) {
    setState(() {
      filteredEmployees = employees.where((employee) {
        return employee.name
            .toLowerCase()
            .contains(value.toLowerCase()) ||
            employee.email
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            employee.phone.contains(value);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employees"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(AppRouter.addEmployee);
        },
        child: const Icon(Icons.add),
      ),

      body: RefreshIndicator(
        onRefresh: loadEmployees,
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: searchController,
                onChanged: searchEmployee,
                decoration: InputDecoration(
                  hintText: "Search employee...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),

            Expanded(
              child: isLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : filteredEmployees.isEmpty
                  ? const Center(
                child: Text(
                  "No Employees Found",
                  style: TextStyle(fontSize: 18),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: filteredEmployees.length,
                itemBuilder: (context, index) {
                  final employee = filteredEmployees[index];

                  return EmployeeCard(
                    name: employee.name,
                    email: employee.email,
                    phone: employee.phone,
                    isActive: employee.isActive,
                    onTap: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}