import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/lead_status_model.dart';

class LeadStatusService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  CollectionReference get _statusCollection =>
      _firestore.collection('lead_statuses');

  Stream<List<LeadStatusModel>> getStatuses() {
    return _statusCollection
        .orderBy('order')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => LeadStatusModel.fromMap(
          doc.id,
          doc.data() as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }

  Future<void> addStatus(String name) async {
    final snapshot = await _statusCollection.get();

    await _statusCollection.add({
      "name": name,
      "order": snapshot.docs.length + 1,
      "isActive": true,
    });
  }

  Future<void> updateStatus({
    required String id,
    required String name,
  }) async {
    await _statusCollection.doc(id).update({
      "name": name,
    });
  }

  Future<void> deleteStatus(String id) async {
    await _statusCollection.doc(id).delete();
  }
}