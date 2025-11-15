import 'package:flutter/foundation.dart';
import 'package:guild_chat/models/user.dart';

class UserViewmodel extends ChangeNotifier {
  int _userCount = 0;
  final int _maxLen = 10;

  int get userCount => _userCount;

  UserViewmodel() {
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    List<User> users = await User().getAllUsers();
    _userCount = users.length;
    notifyListeners();
  }

  Future<void> setCounter() async {
    List<User> users = await User().getAllUsers();
    if (users.length >= _maxLen) {
      var i = 0;
      while (i < _maxLen) {
        var user = users.removeLast();
        user.delete();
        debugPrint('id ${user.id}');
        i++;
      }
    } else {
      User().addUser('test');
      users = await User().getAllUsers();
    }

    _userCount = users.length;
    notifyListeners();
  }
}
