import 'package:flutter/material.dart';

import 'config/app_router.dart';
import 'config/app_theme.dart';

class MCCApp extends StatelessWidget {
  const MCCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(

      debugShowCheckedModeBanner: false,

      title: 'MCC',

      theme: AppTheme.lightTheme,

      routerConfig: AppRouter.router,

    );
  }
}