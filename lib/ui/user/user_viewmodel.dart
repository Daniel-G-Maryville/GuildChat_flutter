import 'package:flutter/foundation.dart';
import 'package:guild_chat/data/user_repository.dart';
import 'package:guild_chat/models/user.dart';

class UserViewmodel extends ChangeNotifier {
  int _userCount = 0;
  final int _maxLen = 10;

  int get userCount => _userCount;

  UserViewmodel() {
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    List<User> users = await UserRepository.getAllUsers();
    _userCount = users.length;
    notifyListeners();
  }

  Future<void> setCounter() async {
    List<User> users = await UserRepository.getAllUsers();
    if (users.length >= _maxLen) {
      var i = 0;
      while (i < _maxLen) {
        var user = users.removeLast();
        UserRepository.delete(user.email);
        debugPrint('id ${user.email}');
        i++;
      }
    } else {
      UserRepository.create(email: 'a@a.com', username: 'user');
      users = await UserRepository.getAllUsers();
    }

    _userCount = users.length;
    notifyListeners();
  }
}
