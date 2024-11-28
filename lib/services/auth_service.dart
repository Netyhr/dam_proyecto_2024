import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<User?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    return userCredential.user;
  } catch (e) {
    print("Error during Google Sign-In: $e");
    return null;
  }
}

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
  await GoogleSignIn().signOut();
}

Future<void> addUserToDatabase(User user) async {
  // Check if the user already exists in Firestore
  DocumentSnapshot userDoc = await FirebaseFirestore.instance
      .collection('Usuarios')
      .doc(user.uid)
      .get();

  if (!userDoc.exists) {
    // Add user to the "Usuarios" collection in Firestore
    await FirebaseFirestore.instance.collection('Usuarios').doc(user.uid).set({
      'uuid': user.uid,
      'nombre': user.displayName ??
          'No Name', // Use the displayName or a default value
    });
    print('User added to database');
  } else {
    print('User already exists in database');
  }
}
