import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_router.dart';
import '../../services/firestore_service.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/quick_action_button.dart';

import '../../widgets/logout_dialog.dart';

import '../settings/lead_status_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {

  final FirestoreService _firestoreService = FirestoreService();

  String adminName = "Admin";

  int employeeCount = 0;
  int customerCount = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {

    try {

      final uid = FirebaseAuth.instance.currentUser!.uid;

      final user = await _firestoreService.getUser(uid);

      final employees = await _firestoreService.getEmployeeCount();

      final customers = await _firestoreService.getCustomerCount();

      setState(() {

        adminName = user?['name'] ?? "Admin";

        employeeCount = employees;

        customerCount = customers;

        isLoading = false;

      });

    } catch (e) {

      setState(() {

        isLoading = false;

      });

    }

  }

  Future<void> logout() async {

    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    context.go(AppRouter.login);

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("MCC Admin Dashboard"),
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

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
              "Welcome, $adminName 👋",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Manage your CRM efficiently",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            GridView.count(

              shrinkWrap: true,

              physics: const NeverScrollableScrollPhysics(),

              crossAxisCount: 2,

              crossAxisSpacing: 15,

              mainAxisSpacing: 15,

              childAspectRatio: 1.1,

              children: [

                DashboardCard(
                  title: "Employees",
                  value: employeeCount.toString(),
                  icon: Icons.people,
                  color: Colors.blue,
                  onTap: () {
                    context.push(AppRouter.employeeList);
                  },
                ),

                DashboardCard(
                  title: "Customers",
                  value: customerCount.toString(),
                  icon: Icons.person,
                  color: Colors.green,
                  onTap: () {
                    context.push(AppRouter.customers);
                  },
                ),

                const DashboardCard(
                  title: "Pending Calls",
                  value: "0",
                  icon: Icons.call,
                  color: Colors.orange,
                ),

                const DashboardCard(
                  title: "Completed",
                  value: "0",
                  icon: Icons.check_circle,
                  color: Colors.purple,
                ),

              ],
            ),

            const SizedBox(height: 35),

            const Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // QuickActionButton(
            //   title: "Add Employee",
            //   icon: Icons.person_add,
            //   onTap: () {
            //     context.push(AppRouter.employeeList);
            //   },
            // ),
            //
            // const SizedBox(height: 15),

            QuickActionButton(
              title: "Import Customers",
              icon: Icons.upload_file,
              onTap: () {
                context.push(AppRouter.customers);
              },
            ),

            // const SizedBox(height: 15),
            //
            // QuickActionButton(
            //   title: "Assign Customers",
            //   icon: Icons.assignment_ind,
            //   onTap: () {},
            // ),

            const SizedBox(height: 15),

            QuickActionButton(
              title: "CRM Settings",
              icon: Icons.settings,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LeadStatusScreen(),
                  ),
                );
              },
            ),

            // const SizedBox(height: 15),
            //
            // QuickActionButton(
            //   title: "Logout",
            //   icon: Icons.logout,
            //   onTap: logout,
            // ),

          ],
        ),
      ),
    );
  }
}