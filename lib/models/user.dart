import 'package:flutter/foundation.dart'; // For debugPrint if needed, but not used here

class User {
  final String username;
  final String email;
  final String firstName;
  final String lastName;

  // Constructor for creating a new User
  User({
    this.username = "none",
    this.firstName = '',
    this.lastName = '',
    this.email = 'a@a.com',
  });

  // Factory constructor to create User from Firestore document
  factory User.fromMap(Map<String, dynamic> map, String id) {
    return User(
      username: map['username'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
    );
  }

  // Convert User to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }
}
