import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';

class ExcelImportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> importCustomers() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    print("Result: $result");

    if (result != null) {
      print("File Name: ${result.files.single.name}");
      print("File Path: ${result.files.single.path}");
    }

    if (result == null) {
      print("User cancelled file picker.");
      return 0;
    }

    final path = result.files.single.path;

    if (path == null) {
      throw Exception("Unable to read file.");
    }

    final file = File(path);

    final csvString = await file.readAsString();

    final rows = const CsvToListConverter(
      shouldParseNumbers: false,
    ).convert(csvString);

    int imported = 0;

    int skipped = 0;

    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];

      if (row.length < 5) continue;

      final phone = row[1].toString().trim();

      final existingCustomer = await _firestore
          .collection("customers")
          .where("phone", isEqualTo: phone)
          .limit(1)
          .get();

      if (existingCustomer.docs.isNotEmpty) {
        skipped++;
        continue;
      }

      await _firestore.collection("customers").add({
        "name": row[0].toString(),
        "phone": row[1].toString(),
        "schoolName": row[2].toString(),
        "gender": row[3].toString(),
        "city": row[4].toString(),
        "assignedTo": "",
        "assignedEmployeeName": "",
        "status": "Pending",
        "feedback": "",
        "remarks": "",
        "createdAt": Timestamp.now(),
      });

      imported++;
    }
    print("Imported Customers = $imported");
    return imported;

    return imported;

  }
}