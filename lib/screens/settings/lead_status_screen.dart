import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/lead_status_provider.dart';
import '../../widgets/lead_status_tile.dart';

class LeadStatusScreen extends StatelessWidget {
  const LeadStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LeadStatusProvider>();

    // Hide Pending from admin
    final statuses = provider.statuses
        .where(
          (status) => status.name.toLowerCase() != "pending",
    )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lead Status Management"),
      ),
      body: statuses.isEmpty
          ? const Center(
        child: Text(
          "No Lead Statuses Found",
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: statuses.length,
        itemBuilder: (context, index) {
          final status = statuses[index];

          return LeadStatusTile(
            status: status,
            onEdit: () {
              _showEditDialog(
                context,
                provider,
                status.id,
                status.name,
              );
            },
            onDelete: () {
              _showDeleteDialog(
                context,
                provider,
                status.id,
                status.name,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddDialog(context, provider);
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Status"),
      ),
    );
  }

  static void _showAddDialog(
      BuildContext context,
      LeadStatusProvider provider,
      ) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Add Lead Status"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Status Name",
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
              onPressed: () async {
                final name = controller.text.trim();

                if (name.isEmpty) return;

                // Prevent duplicate Pending
                if (name.toLowerCase() == "pending") {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Pending is a system status and cannot be created.",
                        ),
                      ),
                    );
                  }
                  return;
                }

                await provider.addStatus(name);

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  static void _showEditDialog(
      BuildContext context,
      LeadStatusProvider provider,
      String id,
      String currentName,
      ) {
    final controller = TextEditingController(
      text: currentName,
    );

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Edit Status"),
          content: TextField(
            controller: controller,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = controller.text.trim();

                if (name.isEmpty) return;

                if (name.toLowerCase() == "pending") {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Pending is a system status and cannot be renamed.",
                        ),
                      ),
                    );
                  }
                  return;
                }

                await provider.updateStatus(
                  id,
                  name,
                );

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  static void _showDeleteDialog(
      BuildContext context,
      LeadStatusProvider provider,
      String id,
      String name,
      ) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Delete Status"),
          content: Text(
            'Delete "$name"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                await provider.deleteStatus(id);

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}