import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithEmailPassword(String email, String password);
  Future<UserModel> signUpWithEmailPassword(String email, String password);
  Future<void> signOut();
  Stream<UserModel?> get authStateChanges;
  Future<void> updateProfile({String? displayName, String? photoUrl});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl(this._firebaseAuth, this._firestore);

  @override
  Future<UserModel> signInWithEmailPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw ServerException('No user returned from Firebase');
      }

      final userModel = UserModel.fromFirebase(userCredential.user!);

      // Check if user document exists
      final userDoc = _firestore.collection('users').doc(userModel.id);
      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        // Create the user document if it doesn't exist
        await userDoc.set(userModel.toJson());
      } else {
        // Only update lastLogin if document exists
        await userDoc.update({
          'lastLogin': DateTime.now().toIso8601String(),
        });
      }

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Authentication failed');
    } catch (e) {
      throw ServerException('Unexpected error during sign in: ${e.toString()}');
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      try {
        final userDoc = _firestore.collection('users').doc(user.uid);
        final docSnapshot = await userDoc.get();

        if (!docSnapshot.exists) {
          // Create user document if it doesn't exist
          final userModel = UserModel.fromFirebase(user);
          await userDoc.set(userModel.toJson());
          return userModel;
        }

        // Return user model with data from Firestore
        final userData = docSnapshot.data() as Map<String, dynamic>;
        return UserModel(
          id: user.uid,
          email: user.email!,
          displayName: userData['displayName'] as String? ?? user.displayName,
          photoUrl: userData['photoUrl'] as String? ?? user.photoURL,
          lastLogin: DateTime.parse(userData['lastLogin'] as String),
        );
      } catch (e) {
        print('Error in authStateChanges: $e');
        return UserModel.fromFirebase(user);
      }
    });
  }

  @override
  Future<UserModel> signUpWithEmailPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw ServerException('No user returned from Firebase');
      }

      final userModel = UserModel.fromFirebase(userCredential.user!);

      // Create user document in Firestore
      await _firestore.collection('users').doc(userModel.id).set(
        userModel.toJson(),
        SetOptions(merge: true), // Use merge to prevent overwriting existing data
      );

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Sign up failed');
    } catch (e) {
      throw ServerException('Unexpected error during sign up: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        // Update last activity before signing out
        await _firestore.collection('users').doc(currentUser.uid).update({
          'lastActivity': DateTime.now().toIso8601String(),
        }).catchError((e) {
          // Ignore errors updating lastActivity
          print('Error updating lastActivity: $e');
        });
      }
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Sign out failed');
    } catch (e) {
      throw ServerException('Unexpected error during sign out: ${e.toString()}');
    }
  }

  @override
  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw ServerException('No user logged in');

      // Update Firebase Auth profile
      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }

      // Check if user document exists
      final userDoc = _firestore.collection('users').doc(user.uid);
      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        // Create full user document if it doesn't exist
        final userModel = UserModel.fromFirebase(user);
        await userDoc.set(userModel.toJson());
      } else {
        // Update only the changed fields
        final updates = <String, dynamic>{
          'lastUpdated': DateTime.now().toIso8601String(),
        };
        if (displayName != null) updates['displayName'] = displayName;
        if (photoUrl != null) updates['photoUrl'] = photoUrl;

        await userDoc.update(updates);
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Profile update failed');
    } catch (e) {
      throw ServerException('Unexpected error updating profile: ${e.toString()}');
    }
  }
}