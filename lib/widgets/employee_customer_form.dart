import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/customer_model.dart';

import 'package:provider/provider.dart';

import '../providers/lead_status_provider.dart';

class EmployeeCustomerForm extends StatefulWidget {
  final CustomerModel customer;

  final Future<void> Function(
      String status,
      String feedback,
      String remarks,
      ) onSave;

  final Widget? bottomWidget;

  const EmployeeCustomerForm({
    super.key,
    required this.customer,
    required this.onSave,
    this.bottomWidget,
  });

  @override
  State<EmployeeCustomerForm> createState() =>
      _EmployeeCustomerFormState();
}

class _EmployeeCustomerFormState
    extends State<EmployeeCustomerForm> {

  late TextEditingController feedbackController;
  late TextEditingController remarksController;

  late String status;

  bool saving = false;

  @override
  void initState() {
    super.initState();

    feedbackController = TextEditingController(
      text: widget.customer.feedback,
    );

    remarksController = TextEditingController(
      text: widget.customer.remarks,
    );

    status = widget.customer.status;
  }

  @override
  void dispose() {
    feedbackController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  Future<void> callCustomer() async {
    final uri = Uri(
      scheme: 'tel',
      path: widget.customer.phone,
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          Text(
            widget.customer.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          ListTile(
            leading: const Icon(Icons.phone),
            title: Text(widget.customer.phone),
            trailing: IconButton(
              icon: const Icon(Icons.call),
              onPressed: callCustomer,
            ),
          ),

          ListTile(
            leading: const Icon(Icons.location_city),
            title: Text(widget.customer.city),
          ),

          const SizedBox(height: 20),

          Consumer<LeadStatusProvider>(
            builder: (context, provider, child) {
              // Dynamic statuses created by the admin (excluding Pending)
              final dynamicStatuses = provider.activeStatuses
                  .where((s) => s != "Pending")
                  .toList();

              // Build the dropdown list
              final List<String> statuses = [];

              // Show Pending only if the customer is still Pending
              if (widget.customer.status == "Pending") {
                statuses.add("Pending");
              }

              // Add the current status first (if it's not Pending)
              if (widget.customer.status != "Pending" &&
                  !statuses.contains(widget.customer.status)) {
                statuses.add(widget.customer.status);
              }

              // Add all remaining dynamic statuses
              for (final s in dynamicStatuses) {
                if (!statuses.contains(s)) {
                  statuses.add(s);
                }
              }

              // Safety check
              if (!statuses.contains(status)) {
                status = statuses.first;
              }

              return DropdownButtonFormField<String>(
                value: status,
                decoration: const InputDecoration(
                  labelText: "Status",
                  border: OutlineInputBorder(),
                ),
                items: statuses
                    .map(
                      (s) => DropdownMenuItem(
                    value: s,
                    child: Text(s),
                  ),
                )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    status = value!;
                  });
                },
              );
            },
          ),

          const SizedBox(height: 20),

          TextField(
            controller: feedbackController,
            decoration: const InputDecoration(
              labelText: "Feedback",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),

          const SizedBox(height: 20),

          TextField(
            controller: remarksController,
            decoration: const InputDecoration(
              labelText: "Remarks",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: saving
                  ? null
                  : () async {

                setState(() {
                  saving = true;
                });

                await widget.onSave(
                  status,
                  feedbackController.text.trim(),
                  remarksController.text.trim(),
                );

                if (mounted) {
                  setState(() {
                    saving = false;
                  });
                }
              },
              icon: const Icon(Icons.save),
              label: Text(
                saving
                    ? "Saving..."
                    : "Save",
              ),
            ),
          ),

          if (widget.bottomWidget != null) ...[
            const SizedBox(height: 25),
            widget.bottomWidget!,
          ],
        ],
      ),
    );
  }
}