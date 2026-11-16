import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/call_history_model.dart';

class CallHistoryCard extends StatelessWidget {
  final CallHistoryModel history;

  const CallHistoryCard({
    super.key,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              history.employeeName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              DateFormat(
                "dd MMM yyyy • hh:mm a",
              ).format(history.createdAt),
            ),

            const Divider(height: 25),

            Text(
              "Status : ${history.status}",
            ),

            const SizedBox(height: 10),

            Text(
              "Feedback",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(history.feedback),

            const SizedBox(height: 10),

            Text(
              "Remarks",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(history.remarks),
          ],
        ),
      ),
    );
  }
}