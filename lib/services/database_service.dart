import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDoc {
  final String id;
  final Map<String, dynamic> data;

  const FirestoreDoc({required this.id, required this.data});
}

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add data to a collection
  Future<void> addData(String collection, Map<String, dynamic> data) async {
    await _db.collection(collection).add(data);
  }

  // Get all documents from a collection
  Future<List<FirestoreDoc>> getDocs(String collection) async {
    final snapshot = await _db.collection(collection).get();
    return snapshot.docs
        .map((doc) => FirestoreDoc(id: doc.id, data: doc.data()))
        .toList();
  }

  // Update a document
  Future<void> updateData(String collection, String docId, Map<String, dynamic> data) async {
    await _db.collection(collection).doc(docId).update(data);
  }

  // Delete a document
  Future<void> deleteData(String collection, String docId) async {
    await _db.collection(collection).doc(docId).delete();
  }
}
