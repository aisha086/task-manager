class UserModel {
  String userId;
  String userName;
  String userEmail;
  List<String> teams; // List of team IDs the user is part of
  String docId;

  UserModel({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.teams,
    required this.docId
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'teams': teams,
    };
  }

  factory UserModel.fromMap(String docID, Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      userEmail: map['userEmail'] as String,
      teams: map['teams'] as List<String>,
      docId: docID
    );
  }
}
