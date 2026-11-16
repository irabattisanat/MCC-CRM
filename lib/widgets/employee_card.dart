import 'package:flutter/material.dart';

class EmployeeCard extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final bool isActive;
  final VoidCallback? onTap;

  const EmployeeCard({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : "?",
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(email),
            Text(phone),
            const SizedBox(height: 6),
            Chip(
              label: Text(
                isActive ? "Active" : "Inactive",
              ),
              backgroundColor:
              isActive ? Colors.green.shade100 : Colors.red.shade100,
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}