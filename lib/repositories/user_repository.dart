import 'package:tienda/models/user_model.dart';
import 'package:tienda/repositories/db/user.dart';

class UserRepository {
  final List<UserModel> _users = userFromDB;

  bool existUserFromDB(String username) {
    final user = _users.where((element) => element.username == username);
    return user.isNotEmpty;
  }

  UserModel getuser(String username) {
    final user = _users.firstWhere((element) => element.username == username);
    return user;
  }
}
