import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Database {
  static late FirebaseFirestore firestore;

  static Future<void> initDatabase() async {
    await Firebase.initializeApp();
    firestore = FirebaseFirestore.instance;

    return;
  }
}
