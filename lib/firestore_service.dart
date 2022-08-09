import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_testtask/model/quiz/results.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  addResult(Results results) async {
    await _db.collection("results").add(results.toMap());
  }
}
