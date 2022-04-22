import 'package:flutter_getx_restapi_sqlite/data/db_data.dart';
import 'package:flutter_getx_restapi_sqlite/data/rest_data.dart';
import 'package:flutter_getx_restapi_sqlite/models/user.dart';
import 'package:flutter_getx_restapi_sqlite/models/user_loaction.dart';
import 'package:flutter_getx_restapi_sqlite/models/user_name.dart';
import 'package:flutter_getx_restapi_sqlite/models/user_picture.dart';
import 'package:flutter_getx_restapi_sqlite/repository/user_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'user_repository_test.mocks.dart';
import 'package:flutter_test/flutter_test.dart';

@GenerateMocks([RestData, DbData])
void main() {
  late MockRestData restDataSource;
  late MockDbData dBDataSource;

  late UserRepository repository;

  setUp(() {
    restDataSource = MockRestData();
    dBDataSource = MockDbData();

    repository = UserRepository(restDataSource, dBDataSource);
  });

  test('User is created successfully', () async {
    when(restDataSource.getName()).thenAnswer((_) async => mockName);
    when(restDataSource.getLocation()).thenAnswer((_) async => mockLocation);
    when(restDataSource.getPicture()).thenAnswer((_) async => mockImage);
    when(dBDataSource.save(any)).thenAnswer((_) async => 1);

    final newUser = await repository.getNewUser();

    expect(newUser.name, 'Yayo');
    expect(newUser.lastName, 'Arellano');
    expect(newUser.city, 'Taipei');
    expect(newUser.thumbnail, 'https://www.randomimage.com');

    verify(dBDataSource.save(newUser)).called(1);
  });

  test('Get all users successfully', () async {
    when(dBDataSource.getAllUsers()).thenAnswer((_) async => [mockUser]);

    final users = await repository.getAllUsers();

    expect(users.length, 1);
    expect(users[0].name, 'Yayo');
  });

  test('Delete user successfully', () async {
    when(dBDataSource.delete(mockUser)).thenAnswer((_) async => 1);
    final result = await repository.deleteUser(mockUser);

    expect(result, true);
  });
}

final mockName = UserName('Mr', 'Yayo', 'Arellano');
final mockLocation = UserLocation('Taipei', 'Taiwan');
final mockImage = UserPicture('https://www.randomimage.com');
const mockUser =
    User('Yayo', 'Arellano', 'Mexico', 'https://www.someImage.com');
