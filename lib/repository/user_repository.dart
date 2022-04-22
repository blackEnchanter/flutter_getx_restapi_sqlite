import 'package:flutter_getx_restapi_sqlite/data/db_data.dart';
import 'package:flutter_getx_restapi_sqlite/data/rest_data.dart';
import 'package:flutter_getx_restapi_sqlite/models/user.dart';

class UserRepository {
  final RestData _restData;
  final DbData _dbData;

  UserRepository(this._restData, this._dbData);

  Future<User> getNewUser() async {
    final name = await _restData.getName();
    final location = await _restData.getLocation();
    final picture = await _restData.getPicture();
    final user = User(name.first, name.last, location.city, picture.thumbnail);
    await _dbData.save(user);
    return user;
  }

  Future<List<User>> getAllUsers() async {
    return _dbData.getAllUsers();
  }

  Future<bool> deleteUser(User toDelete) async {
    final result = await _dbData.delete(toDelete);
    return result == 1;
  }
}
