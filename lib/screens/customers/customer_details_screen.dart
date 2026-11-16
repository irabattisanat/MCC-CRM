import 'package:flutter/material.dart';
import '../../models/customer_model.dart';

import 'assign_employee_screen.dart';

import 'edit_customer_screen.dart';
import '../../services/customer_service.dart';

class CustomerDetailsScreen extends StatelessWidget {

  final CustomerModel customer;

  const CustomerDetailsScreen({
    super.key,
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              customer.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(customer.phone),
            ),

            ListTile(
              leading: const Icon(Icons.location_city),
              title: Text(customer.city),
            ),

            ListTile(
              leading: const Icon(Icons.info),
              title: Text(customer.status),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditCustomerScreen(
                        customer: customer,
                      ),
                    ),
                  );

                  if (result == true) {
                    Navigator.pop(context, true);
                  }
                },
                icon: const Icon(Icons.edit),
                label: const Text("Edit Customer"),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {

                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Delete Customer"),
                      content: const Text(
                        "Are you sure you want to delete this customer?",
                      ),
                      actions: [

                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: const Text("Cancel"),
                        ),

                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: const Text("Delete"),
                        ),

                      ],
                    ),
                  );

                  if (confirm != true) return;

                  await CustomerService().deleteCustomer(customer.id);

                  if (!context.mounted) return;

                  Navigator.pop(context, true);
                },
                icon: const Icon(Icons.delete),
                label: const Text("Delete Customer"),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AssignEmployeeScreen(
                        customer: customer,
                      ),
                    ),
                  );

                  if (result == true) {
                    Navigator.pop(context, true);
                  }
                },
                icon: const Icon(Icons.person_add),
                label: const Text("Assign Employee"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}