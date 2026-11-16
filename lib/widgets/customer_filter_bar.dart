import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/customer_provider.dart';
import '../providers/lead_status_provider.dart';

class CustomerFilterBar extends StatelessWidget {
  const CustomerFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CustomerProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 8,
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [

          SizedBox(
            width: 220,
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              value: provider.selectedSchool,
              decoration: const InputDecoration(
                labelText: "School",
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: [
                const DropdownMenuItem(
                  value: "All",
                  child: Text(
                    "All Schools",
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ...provider.customers
                    .map((e) => e.schoolName)
                    .toSet()
                    .map(
                      (school) => DropdownMenuItem(
                    value: school,
                    child: Text(
                      school,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  provider.setSchool(value);
                }
              },
            ),
          ),

          SizedBox(
            width: 160,
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              value: provider.selectedGender,
              decoration: const InputDecoration(
                labelText: "Gender",
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: const [
                DropdownMenuItem(
                  value: "All",
                  child: Text("All"),
                ),
                DropdownMenuItem(
                  value: "Male",
                  child: Text("Male"),
                ),
                DropdownMenuItem(
                  value: "Female",
                  child: Text("Female"),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  provider.setGender(value);
                }
              },
            ),
          ),

          SizedBox(
            width: 180,
            child: Consumer<LeadStatusProvider>(
              builder: (context, statusProvider, child) {
                final statuses = statusProvider.activeStatuses;

                // Make sure the currently selected value still exists
                final selected = statuses.contains(provider.selectedStatus)
                    ? provider.selectedStatus
                    : "All";

                return DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: selected,
                  decoration: const InputDecoration(
                    labelText: "Status",
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: "All",
                      child: Text("All"),
                    ),
                    ...statuses.map(
                          (status) => DropdownMenuItem(
                        value: status,
                        child: Text(
                          status,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      provider.setStatus(value);
                    }
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