class Guild {
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final List<String> guilds;

  // Constructor for creating a new User
  Guild({
    this.username = '',
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.guilds = const [],
  });

  // Factory constructor to create User from Firestore document
  factory Guild.fromMap(Map<String, dynamic> map, String id) {
    return Guild(
      username: map['username'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      guilds: map['guilds'],
    );
  }

  // Convert User to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'guilds': guilds,
    };
  }
}
