import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'firebase_options.dart';

import 'providers/customer_provider.dart';
import 'providers/employee_provider.dart';
import 'providers/lead_status_provider.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CustomerProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) {
            final provider = LeadStatusProvider();
            provider.startListening();
            return provider;
          },
        ),

        ChangeNotifierProvider(
          create: (_) => EmployeeProvider(),
        ),
      ],
      child: const MCCApp(),
    ),
  );
}