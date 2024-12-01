class Team {
  String teamId;
  String name;
  List<String> teamMembers; // List of user IDs
  DateTime creationDate;

  Team({
    required this.teamId,
    required this.name,
    required this.teamMembers,
    required this.creationDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'teamMembers': teamMembers,
      'creationDate': creationDate,
    };
  }

  factory Team.fromMap(String docId, Map<String, dynamic> map) {
    return Team(
      teamId: docId,
      name: map['name'] as String,
      teamMembers: map['teamMembers'] as List<String>,
      creationDate: map['creationDate'] as DateTime,
    );
  }
}
