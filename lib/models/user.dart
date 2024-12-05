
class UserModel {
  String userId;
  String name;
  String email;
  List<String> tasks;
  List<String> teams;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.tasks,
    required this.teams,
  });

  // Convert UserModel to a Map to store in Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'tasks': tasks,
      'teams': teams,

    };

  }
  // Convert Firestore DocumentSnapshot to UserModel
  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    return UserModel(
      userId: id,
      name: map['name'],
      email: map['email'],
      tasks: List<String>.from(map['tasks']),
      teams: List<String>.from(map['teams']),
    );
  }

}

