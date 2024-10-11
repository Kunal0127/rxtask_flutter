import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxtask/model/user_model.dart';
import 'package:rxtask/utils/app_prefs.dart';
import 'package:rxtask/service/hive_service.dart';

class HomeScreenController extends GetxController {
  RxList<UserModel> allUsers = <UserModel>[].obs;
  final scrollController = ScrollController();
  int totalUser = 43;
  int databaseLength = 0;
  int perCall = 10;
  int skip = 0;
  // Set<String> selected = <String>{"name"}.obs;

  @override
  void onInit() {
    super.onInit();
    update();
    if (AppPrefs.getValue(key: "databaseCreated") != true) {
      addRandomUsers();
    }
    scrollController.addListener(
      () async {
        if (scrollController.position.maxScrollExtent ==
            scrollController.offset) {
          print("list reached to end");
          if (totalUser != allUsers.length) {
            await Future.delayed(Duration(milliseconds: 1500));
            allUsers.addAll(HiveService()
                .getUser(start: skip, end: skip + perCall)
                .toList());
            skip += perCall + 1;
            print(skip);
            update();
            print("list added list length is ${allUsers.length}");
          }
        }
      },
    );
  }

  @override
  void onReady() {
    super.onReady();
    getUser(start: skip, end: skip + perCall);
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> addRandomUsers() async {
    final faker = Faker();

    List<UserModel> users = List.generate(
      totalUser,
      (index) {
        return UserModel(
            id: index,
            name: faker.person.name(),
            phoneNumber: faker.phoneNumber.us(),
            city: faker.address.city(),
            imageUrl: faker.image.image(),
            rupee: faker.randomGenerator.integer(100, min: 0));
      },
    );

    users.forEach(
      (user) async {
        await HiveService().addUser(user);
      },
    );
    databaseLength = HiveService().getLength();
    await AppPrefs.setValue(key: "databaseCreated", value: true);
    print("user has been added successfully $databaseLength");
  }

  Future getUser({required int start, required int end}) async {
    var ls = await HiveService().getUser(start: start, end: end);
    skip += perCall + 1;
    print(skip);
    allUsers.addAll(ls);
    update();
    ls.forEach(
      (element) {
        print("${element.toMap()}");
      },
    );
  }

  Future<void> getAllUsers() async {
    var u = await HiveService().getAllUser();
    allUsers.value = u;
    update();
    // allUsers.value.addAll(u);
  }

  Future<void> updateUser(UserModel user) async {
    await HiveService().updateUser(user);
    // await getAllUsers();

    int index = allUsers.value.indexWhere(
      (userModel) {
        return user.id == userModel.id;
      },
    );
    if (index != -1) {
      allUsers.value[index] = user;
    }
    update();
  }
}
