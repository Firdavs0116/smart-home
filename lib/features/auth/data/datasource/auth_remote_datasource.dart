import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_home1/features/auth/data/models/auth_model.dart';
import '../../../../core/errors/exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String email, String password, String name);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserModel> signIn(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw ServerExceptions(
          message: 'User not found',
          statuscode: 0,
        );
      }

      // Try to get from Firestore with timeout
      try {
        final userDoc = await firestore
            .collection('users')
            .doc(user.uid)
            .get()
            .timeout(const Duration(seconds: 5));

        if (userDoc.exists) {
          return UserModel.fromFirestore(userDoc);
        }
      } catch (e) {
        print('Firestore timeout: $e');
      }

      // Fallback to Firebase Auth data
      return UserModel(
        uid: user.uid,
        email: user.email ?? email,
        name: user.displayName ?? 'User',
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Authentication failed';
      if (e.code == 'user-not-found') {
        message = 'Foydalanuvchi topilmadi';
      } else if (e.code == 'wrong-password') {
        message = 'Parol noto\'g\'ri';
      } else if (e.code == 'invalid-email') {
        message = 'Email noto\'g\'ri';
      }
      throw ServerExceptions(message: message, statuscode: 0);
    }
  }

  @override
  Future<UserModel> signUp(String email, String password, String name) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw ServerExceptions(
          message: 'Sign up failed',
          statuscode: 1,
        );
      }

      // Update display name
      await user.updateDisplayName(name);

      // Try to save to Firestore
      try {
        final userData = {
          'uid': user.uid,
          'email': email,
          'name': name,
          'createdAt': FieldValue.serverTimestamp(),
        };

        await firestore
            .collection('users')
            .doc(user.uid)
            .set(userData)
            .timeout(const Duration(seconds: 5));
      } catch (e) {
        print('Firestore save failed: $e');
      }

      return UserModel(
        uid: user.uid,
        email: email,
        name: name,
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Sign up failed';
      if (e.code == 'email-already-in-use') {
        message = 'Bu email allaqachon ro\'yxatdan o\'tgan';
      } else if (e.code == 'weak-password') {
        message = 'Parol juda zaif';
      } else if (e.code == 'invalid-email') {
        message = 'Email noto\'g\'ri';
      }
      throw ServerExceptions(message: message, statuscode: 1);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw ServerExceptions(
        message: 'Sign out failed',
        statuscode: 2,
      );
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = firebaseAuth.currentUser;

      if (user == null) return null;

      // Try Firestore first
      try {
        final userDoc = await firestore
            .collection('users')
            .doc(user.uid)
            .get()
            .timeout(const Duration(seconds: 3));

        if (userDoc.exists) {
          return UserModel.fromFirestore(userDoc);
        }
      } catch (e) {
        print('Firestore get failed: $e');
      }

      // Fallback to Firebase Auth
      return UserModel(
        uid: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? 'User',
      );
    } catch (e) {
      throw ServerExceptions(
        message: 'Failed to get current user',
        statuscode: 5,
      );
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;

      return UserModel(
        uid: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? 'User',
      );
    });
  }
}