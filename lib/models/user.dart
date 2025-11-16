class User {
  final String id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;

  // Constructor for creating a new User
  User({
    this.id = '',
    this.username = '',
    this.firstName = '',
    this.lastName = '',
    this.email = '',
  });

  // Factory constructor to create User from Firestore document
  factory User.fromMap(Map<String, dynamic> map, String id) {
    return User(
      id: map['id'],
      username: map['username'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
    );
  }

  // Convert User to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }
}
