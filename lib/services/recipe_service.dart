import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? _currentUserId = FirebaseAuth.instance.currentUser?.uid;

  Stream<QuerySnapshot> getAllRecipes() {
    return _firestore.collection('Recetas').snapshots();
  }

  Stream<QuerySnapshot> getUserRecipes() {
    return _firestore
        .collection('Recetas')
        .where('autor', isEqualTo: _currentUserId)
        .snapshots();
  }

  Future<DocumentSnapshot> getUserById(String userId) {
    return _firestore.collection('Usuarios').doc(userId).get();
  }

  Future<DocumentSnapshot> getCategoryById(String categoryId) {
    return _firestore.collection('Categorias').doc(categoryId).get();
  }
}
