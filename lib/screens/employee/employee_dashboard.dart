import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/customer_model.dart';
import '../../services/firestore_service.dart';

import 'employee_customer_details_screen.dart';

import 'package:provider/provider.dart';

import '../../providers/employee_provider.dart';
import 'call_queue_screen.dart';

import '../../widgets/logout_dialog.dart';

import '../../providers/lead_status_provider.dart';
import '../login/login_screen.dart';


class EmployeeDashboard extends StatefulWidget {
  const EmployeeDashboard({super.key});

  @override
  State<EmployeeDashboard> createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  final FirestoreService _firestoreService = FirestoreService();

  String employeeName = "Employee";

  bool isLoading = true;

  List<CustomerModel> customers = [];

  String selectedStatus = "All";

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final user = await _firestoreService.getUser(uid);

      customers =
      await _firestoreService.getCustomersByEmployee(uid);

      setState(() {
        employeeName = user?['name'] ?? "Employee";
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pending =
        customers.where((c) => c.status == "Pending").length;

    final interested =
        customers.where((c) => c.status == "Interested").length;

    final followUp =
        customers.where((c) => c.status == "Follow Up").length;

    final notInterested =
        customers.where((c) => c.status == "Not Interested").length;

    final statusProvider = context.watch<LeadStatusProvider>();

    final filteredCustomers = selectedStatus == "All"
        ? customers
        : customers.where((customer) {
      return customer.status == selectedStatus;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Dashboard"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => showLogoutDialog(context),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
      : SingleChildScrollView(
          child : Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome, $employeeName 👋",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            Card(
              child: ListTile(
                leading: const Icon(Icons.people),
                title: const Text("My Customers"),
                trailing: Text(
                  customers.length.toString(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.pending_actions,
                  color: Colors.orange,
                ),
                title: const Text("Pending"),
                trailing: Text(
                  pending.toString(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.thumb_up,
                  color: Colors.green,
                ),
                title: const Text("Interested"),
                trailing: Text(
                  interested.toString(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.schedule,
                  color: Colors.blue,
                ),
                title: const Text("Follow Up"),
                trailing: Text(
                  followUp.toString(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                title: const Text("Not Interested"),
                trailing: Text(
                  notInterested.toString(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),

            const SizedBox(height: 25),

            Row(
              children: [

                const Expanded(
                  child: Text(
                    "Assigned Customers",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                ElevatedButton.icon(
                  onPressed: () async {

                    final pendingCustomers = customers
                        .where((c) => c.status == "Pending")
                        .toList();

                    if (pendingCustomers.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("🎉 No pending customers left."),
                        ),
                      );
                      return;
                    }

                    final provider = context.read<EmployeeProvider>();

                    await provider.loadDashboard();

                    if (!context.mounted) return;

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CallQueueScreen(),
                      ),
                    );

                    await loadDashboard();
                  },
                  icon: const Icon(Icons.phone),
                  label: const Text("Call Next"),
                ),
              ],
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: 220,
              child: DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(
                  labelText: "Filter by Status",
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: [
                  DropdownMenuItem(
                    value: "All",
                    child: Text("All (${customers.length})"),
                  ),

                  ...statusProvider.activeStatuses.map((status) {

                    final count = customers
                        .where((customer) => customer.status == status)
                        .length;

                    return DropdownMenuItem(
                      value: status,
                      child: Text(
                        "$status ($count)",
                      ),
                    );

                  }),
                ],
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    selectedStatus = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 15),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredCustomers.length,
              itemBuilder: (context, index) {
                final customer = filteredCustomers[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        customer.name.isNotEmpty
                            ? customer.name[0].toUpperCase()
                            : "?",
                      ),
                    ),
                    title: Text(customer.name),
                    subtitle: Text(
                      "${customer.phone}\n${customer.city}",
                    ),
                    isThreeLine: true,
                    trailing: Chip(
                      label: Text(customer.status),
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EmployeeCustomerDetailsScreen(
                            customer: customer,
                          ),
                        ),
                      );
                      if (result == true) {
                        loadDashboard();
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
          ),
    );
  }
}