import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/employee_provider.dart';
import '../../widgets/employee_customer_form.dart';

class CallQueueScreen extends StatelessWidget {
  const CallQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeProvider>(
      builder: (context, provider, child) {
        final customer = provider.currentCustomer;

        // Queue Finished
        if (customer == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Call Queue"),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.celebration,
                      color: Colors.green,
                      size: 80,
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      "Queue Completed 🎉",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "You've completed all pending customer calls.",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.dashboard),
                      label: const Text("Back to Dashboard"),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("Call Queue"),
            centerTitle: true,
          ),

          body: Column(
            children: [

              // ===========================
              // Progress
              // ===========================

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [

                        const Text(
                          "Queue Progress",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          "${provider.currentIndex + 1} / ${provider.queueLength}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    LinearProgressIndicator(
                      value: provider.progress,
                      minHeight: 8,
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              Expanded(
                child: EmployeeCustomerForm(
                  customer: customer,

                  onSave: (
                      status,
                      feedback,
                      remarks,
                      ) async {

                    final hasMore =
                    await provider.saveAndNext(
                      status: status,
                      feedback: feedback,
                      remarks: remarks,
                    );

                    if (!context.mounted) return;

                    if (!hasMore) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            "🎉 Queue Completed!",
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}