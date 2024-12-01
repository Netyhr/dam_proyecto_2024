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

  Future<bool> addRecipe(
      {required String name,
      required String categoryId,
      required String instructions}) async {
    try {
      await _firestore.collection('Recetas').add({
        'autor': _currentUserId,
        'nombre': name,
        'categoria': categoryId,
        'instrucciones': instructions,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkAuthor(String recipeId) async {
    final author = await _firestore.collection('Recetas').doc(recipeId).get();

    if (_currentUserId == author['autor']) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteRecipe(String recipeId) async {
    final author = await _firestore.collection('Recetas').doc(recipeId).get();

    if (_currentUserId == author['autor']) {
      await _firestore.collection('Recetas').doc(recipeId).delete();
      return true;
    } else {
      return false;
    }
  }
}
