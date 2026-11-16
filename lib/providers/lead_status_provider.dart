import 'dart:async';

import 'package:flutter/material.dart';

import '../models/lead_status_model.dart';
import '../services/lead_status_service.dart';

class LeadStatusProvider extends ChangeNotifier {
  final LeadStatusService _service = LeadStatusService();

  List<LeadStatusModel> _statuses = [];

  List<LeadStatusModel> get statuses => _statuses;

  List<String> get activeStatuses {
    return _statuses
        .where((status) => status.isActive)
        .map((status) => status.name)
        .toList();
  }

  StreamSubscription? _subscription;

  void startListening() {
    _subscription?.cancel();

    _subscription = _service.getStatuses().listen((data) {
      _statuses = data;
      notifyListeners();
    });
  }

  Future<void> addStatus(String name) async {
    await _service.addStatus(name);
  }

  Future<void> updateStatus(
      String id,
      String name,
      ) async {
    await _service.updateStatus(
      id: id,
      name: name,
    );
  }

  Future<void> deleteStatus(String id) async {
    await _service.deleteStatus(id);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}