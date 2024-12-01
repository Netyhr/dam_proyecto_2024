import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllCategories() {
    return _firestore.collection('Categorias').snapshots();
  }

  Future<DocumentSnapshot> getCategoryById(String categoryId) {
    return _firestore.collection('Categorias').doc(categoryId).get();
  }
}
