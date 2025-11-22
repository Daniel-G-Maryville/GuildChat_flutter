class Guild {
  final String guildName;
  final List<String>? members; // list of member ids
  final String ownerId;

  // Constructor for creating a new User
  Guild({
    this.guildName = '',
    this.members,
    this.ownerId = '',
  });

  // Factory constructor to create User from Firestore document
  factory Guild.fromMap(Map<String, dynamic> map, String id) {
    return Guild(
      guildName: map['guildName'],
      ownerId: map['ownerId'],
      members: map['members'],
   );
  }

  // Convert User to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'guildName': guildName,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }
}
