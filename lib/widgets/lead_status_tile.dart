import 'package:flutter/material.dart';

import '../models/lead_status_model.dart';

class LeadStatusTile extends StatelessWidget {
  final LeadStatusModel status;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const LeadStatusTile({
    super.key,
    required this.status,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      child: ListTile(
        leading: const Icon(
          Icons.flag,
          color: Colors.blue,
        ),
        title: Text(
          status.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}