import 'package:hive/hive.dart';
import 'package:rxtask/model/user_model.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();

  HiveService._internal();

  factory HiveService() {
    return _instance;
  }

  final String boxName = 'userBox';
  late Box<UserModel> box;

  Future<void> initHive() async {
    box = await Hive.openBox<UserModel>(boxName);
  }

  int getLength() {
    return box.length;
  }

  Future<void> addUser(UserModel user) async {
    // await box.add(user).then((value) {
    //   print("key is $value");
    // });
    await box.put(user.id, user);
  }

  List<UserModel> getAllUser() {
    return box.values.toList();
  }

  List<UserModel> getUser({required int start, required int end}) {
    return box.valuesBetween(startKey: start, endKey: end).toList();
  }

  Future<void> deleteUser(int index) async {
    // await box.deleteAt(index);
    await box.delete(index); // it should be id
  }

  Future<void> updateUser(UserModel user) async {
    // final box = await Hive.openBox<UserModel>('myBox');
    print(" key is ${user.key.runtimeType}");
    print(user.toMap());
    await box.put(user.id, user);
  }

  Future<void> clearAllUser() async {
    await box.clear();
    print("user delete successfully");
  }

  Future<void> closeBox() async {
    await box.close();
  }
}
