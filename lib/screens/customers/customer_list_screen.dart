import 'package:flutter/material.dart';

import '../../models/customer_model.dart';
import 'package:provider/provider.dart';

import '../../providers/customer_provider.dart';
import '../../widgets/customer_card.dart';

import 'add_customer_screen.dart';
import 'customer_details_screen.dart';

import 'package:go_router/go_router.dart';
import '../../config/app_router.dart';

import '../../services/excel_import_service.dart';

import '../../widgets/customer_filter_bar.dart';

import 'bulk_assign_dialog.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {

  List<CustomerModel> filteredCustomers = [];

  final TextEditingController searchController =
  TextEditingController();

  final ExcelImportService _excelImportService = ExcelImportService();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerProvider>().startListening();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void searchCustomer(String keyword) {
    context.read<CustomerProvider>().search(keyword);
  }

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<CustomerProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: provider.selectionMode
            ? IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            provider.clearSelection();
          },
        )
            : null,

        title: Text(
          provider.selectionMode
              ? "${provider.selectedCustomerIds.length} Selected"
              : "Customers",
        ),

        actions: [

          if (provider.selectionMode) ...[

            IconButton(
              tooltip: "Select All",
              icon: const Icon(Icons.select_all),
              onPressed: () {
                provider.selectAllFiltered();
              },
            ),

            IconButton(
              tooltip: "Assign",
              icon: const Icon(Icons.person_add),
              onPressed: () async {

                final employee = await showDialog(
                  context: context,
                  builder: (_) => const BulkAssignDialog(),
                );

                if (employee == null) return;

                final selectedCount =
                    provider.selectedCustomerIds.length;

                await provider.bulkAssignCustomers(
                  employeeId: employee.uid,
                  employeeName: employee.name,
                );

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "$selectedCount customers assigned to ${employee.name}",
                    ),
                    backgroundColor: Colors.green,
                  ),
                );

              },
            ),
            IconButton(
              tooltip: "Delete",
              icon: const Icon(Icons.delete),
              onPressed: () async {

                final selectedCount = provider.selectedCustomerIds.length;

                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Delete Customers"),
                    content: Text(
                      "Are you sure you want to delete $selectedCount selected customer(s)?\n\nThis action cannot be undone.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Delete"),
                      ),
                    ],
                  ),
                );

                if (confirm != true) return;

                await provider.deleteSelectedCustomers();

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "$selectedCount customer(s) deleted successfully.",
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),

          ] else ...[

            IconButton(
              icon: const Icon(Icons.upload_file),
              onPressed: () async {

                try {

                  final count =
                  await _excelImportService.importCustomers();

                  if (!mounted) return;

                  if (count > 0) {

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "Successfully imported $count customers"),
                        backgroundColor: Colors.green,
                      ),
                    );

                  }

                } catch (e) {

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );

                }

              },
            ),

          ]

        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          await context.push(AppRouter.addCustomer);

        },
        child: const Icon(Icons.add),
      ),

    body: provider.isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: "Search Customers...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: searchCustomer,
            ),
          ),
          const CustomerFilterBar(),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 8,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${provider.filteredCustomers.length} Customers Found",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),

          Expanded(
            child: provider.filteredCustomers.isEmpty
                ? const Center(
              child: Text("No Customers Found"),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: provider.filteredCustomers.length,
              itemBuilder: (context, index) {

                final customer = provider.filteredCustomers[index];

                return CustomerCard(
                  name: customer.name,
                  phone: customer.phone,
                  schoolName: customer.schoolName,
                  gender: customer.gender,
                  city: customer.city,
                  status: customer.status,

                  showCheckbox: provider.selectionMode,

                  isSelected: provider.isSelected(customer.id),

                  onTap: () {
                    if (provider.selectionMode) {
                      provider.toggleSelection(customer.id);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CustomerDetailsScreen(
                            customer: customer,
                          ),
                        ),
                      );
                    }
                  },

                  onLongPress: () {
                    provider.toggleSelection(customer.id);
                  },
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}