import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/school_model.dart';

class SchoolService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> addSchool(String name) async {
    await _firestore.collection('schools').add({
      'name': name.trim(),
    });
  }

  Future<List<SchoolModel>> getSchools() async {
    final snapshot = await _firestore
        .collection('schools')
        .orderBy('name')
        .get();

    return snapshot.docs
        .map(
          (doc) => SchoolModel.fromMap(
        doc.id,
        doc.data(),
      ),
    )
        .toList();
  }
}