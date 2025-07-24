import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class StaticBloodBankService {
  /// Loads static blood bank JSON data from assets
  static Future<List<Map<String, dynamic>>> loadBanks() async {
    final jsonStr = await rootBundle.loadString('assets/blood_banks.json');
    final List<dynamic> jsonList = json.decode(jsonStr);
    return List<Map<String, dynamic>>.from(jsonList);
  }

  /// Uploads static blood bank data to Firestore
  static Future<void> uploadToFirebase({bool clearExisting = true}) async {
    final banks = await loadBanks();
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection("bloodbanks");

    if (clearExisting) {
      print("🧹 Deleting existing documents in 'blood banks'...");
      final snapshots = await collection.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }
      print("✅ Existing documents cleared.");
    }

    print("📤 Uploading ${banks.length} blood banks to Firestore...");
    final batch = firestore.batch();

    for (var bank in banks) {
      final docRef = collection.doc(); // auto-ID
      batch.set(docRef, bank);
    }

    try {
      await batch.commit();
      print("✅ Successfully uploaded ${banks.length} blood banks.");
    } catch (e) {
      print("❌ Failed to upload blood banks: $e");
    }
  }
}
