import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/models/user.dart';

import '../widgets/toast.dart';

class UserService {
  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection('users');

  // Add new user
  Future<void> addUser(UserModel user) async {
    await userCollection.doc(user.userId).set(user.toMap());
  }

  Future<void> storeUserDetails(User user, String name, String email,String token) async {
    try {
      // Reference to the Firestore 'users' collection
      final userRef = userCollection.doc(user.uid);

      // Add user details to Firestore
      await userRef.set({

        'name': name,
        'email': email,
        'teams': [],
        'tasks':[],
        'fcmToken': token
      });

      showToast("User details stored successfully.");
    } catch (e) {
      showToast("Error saving user details: $e");
    }
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

  Future<List<String>> getMemberIdsByEmails(List emails) async {
    List<String> memberIds = [];
    memberIds.add(FirebaseAuth.instance.currentUser!.uid);
    try {
      for (String email in emails) {
        QuerySnapshot querySnapshot = await userCollection
            .where('email', isEqualTo: email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          if (FirebaseAuth.instance.currentUser!.uid !=
              querySnapshot.docs.first.id) {
            memberIds.add(querySnapshot.docs.first.id);
          }
        }
      }
    } catch (e) {
      throw Exception('Error fetching user IDs: $e');
    }
    return memberIds;
  }

  Future<List<String>> getEmailsByIds(List userIds) async {
    try {
      List<String> emails = [];
      for (String userId in userIds) {
        DocumentSnapshot userDoc = await userCollection.doc(userId).get();
        if (userDoc.exists) {
          String? email = userDoc['email'] as String?;
          if (email != null) {
            emails.add(email);
          }
        }
      }
      return emails;
    } catch (e) {
      print('Error fetching emails: $e');
      return [];
    }
  }
}