import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/models/user.dart';

class UserService {
  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection('users');

  // Add new user
  Future<void> addUser(UserModel user) async {
    await userCollection.doc(user.userId).set(user.toMap());
  }

  // Get user by ID
  Future<UserModel?> getUser(String userId) async {
    DocumentSnapshot doc = await userCollection.doc(userId).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Update user data
  Future<void> updateUser(UserModel user) async {
    await userCollection.doc(user.userId).update(user.toMap());
  }

  // Delete user by ID
  Future<void> deleteUser(String userId) async {
    await userCollection.doc(userId).delete();
  }
}
