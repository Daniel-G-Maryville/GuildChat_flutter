class Guild {
  final String guildName;
  final List<String> members; // list of member ids
  final String ownerId;

  // Constructor for creating a new Guild
  Guild({
    this.guildName = '',
    this.members = const [],
    this.ownerId = '',
  });

  // Factory constructor to create Guild from Firestore document
  factory Guild.fromMap(Map<String, dynamic> map, String id) {
    return Guild(
      guildName: map['guildName'],
      ownerId: map['ownerId'],
      members: (map['members'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
   );
  }

  // Convert Guild to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'guildName': guildName,
      'members': members,
      'ownerId': ownerId,
    };
  }
}
