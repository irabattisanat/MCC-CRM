import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerCard extends StatelessWidget {
  final String name;
  final String phone;
  final String schoolName;
  final String gender;
  final String city;
  final String status;

  final bool showCheckbox;
  final bool isSelected;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const CustomerCard({
    super.key,
    required this.name,
    required this.phone,
    required this.schoolName,
    required this.gender,
    required this.city,
    required this.status,
    this.showCheckbox = false,
    this.isSelected = false,
    this.onTap,
    this.onLongPress,
  });

  Future<void> _callCustomer() async {
    final Uri uri = Uri(
      scheme: 'tel',
      path: phone,
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Color _statusColor() {
    switch (status.toLowerCase()) {
      case "pending":
        return Colors.orange;

      case "interested":
        return Colors.green;

      case "not interested":
        return Colors.red;

      case "follow up":
        return Colors.blue;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 6 : 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: isSelected ? Colors.blue.shade50 : Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showCheckbox)
                Checkbox(
                  value: isSelected,
                  onChanged: (_) => onTap?.call(),
                ),

              const CircleAvatar(
                radius: 24,
                child: Icon(Icons.person),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),

                    const SizedBox(height: 8),

                    InkWell(
                      onTap: _callCustomer,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.phone,
                            size: 16,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              phone,
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(
                          Icons.school,
                          size: 16,
                          color: Colors.indigo,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(schoolName),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(
                          Icons.wc,
                          size: 16,
                          color: Colors.purple,
                        ),
                        const SizedBox(width: 6),
                        Text(gender),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(
                          Icons.location_city,
                          size: 16,
                          color: Colors.teal,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(city),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Chip(
                backgroundColor: _statusColor(),
                label: Text(
                  status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}