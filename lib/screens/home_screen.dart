import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxtask/controller/home_screen_controller.dart';
import 'package:rxtask/model/user_model.dart';
import 'package:rxtask/widgets/app_image_widget.dart';

// homescreenScrollController.position.maxScrollExtent == homescreenScrollController.offset

class HomeScreen extends GetView<HomeScreenController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Recoreds - ${controller.allUsers.length}"),
            actions: [
              IconButton(
                  onPressed: () async {
                    showSearch(
                        context: context,
                        delegate:
                            CustomDelegate(users: controller.allUsers.value));
                  },
                  icon: Icon(Icons.search))
            ],
          ),
          body: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            controller: controller.scrollController,
            itemCount: controller.allUsers.length + 1,
            itemBuilder: (context, index) {
              if (index == controller.allUsers.length) {
                if (controller.totalUser != controller.allUsers.value.length) {
                  return SizedBox.square(
                    dimension: 80,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  return SizedBox.shrink();
                }
              }

              var user = controller.allUsers.value[index];
              return Card(
                child: ListTile(
                  onTap: () {
                    editData(index, user);
                  },
                  isThreeLine: false,
                  leading: AppImageWidget(user: user),
                  title: Text("${user.name}"),
                  subtitle: Text("${user.phoneNumber}\n${user.city}"),
                  trailing: Text(
                    "${user.rupee}\n ${user.rupee <= 50 ? "LOW" : "HIGH"}",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: user.rupee <= 50 ? Colors.red : Colors.green),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<dynamic> editData(int index, UserModel user) {
    TextEditingController _nameController =
        TextEditingController(text: "${user.name}");
    TextEditingController _cityController =
        TextEditingController(text: "${user.city}");
    TextEditingController _phoneController =
        TextEditingController(text: "${user.phoneNumber}");
    TextEditingController _rupeeController =
        TextEditingController(text: "${user.rupee}");

    return Get.dialog(
      barrierDismissible: true,
      AlertDialog(
        content: SizedBox(
          height: 250,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppImageWidget(user: user),
                TextField(
                  readOnly: true,
                  controller: _nameController,
                  textAlign: TextAlign.end,
                  decoration: InputDecoration(
                    prefix: Text("Name"),
                  ),
                ),
                TextField(
                  readOnly: true,
                  controller: _cityController,
                  textAlign: TextAlign.end,
                  decoration: InputDecoration(
                    prefix: Text("City"),
                  ),
                ),
                TextField(
                  readOnly: true,
                  controller: _phoneController,
                  textAlign: TextAlign.end,
                  decoration: InputDecoration(
                    prefix: Text("Phone"),
                  ),
                ),
                TextField(
                  controller: _rupeeController,
                  textAlign: TextAlign.end,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefix: Text("Rs."),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text("Cancle"),
          ),
          TextButton(
            onPressed: () async {
              print("${user.id}");
              await controller
                  .updateUser(
                UserModel(
                  id: user.id,
                  name: user.name,
                  phoneNumber: user.phoneNumber,
                  city: user.city,
                  imageUrl: user.imageUrl,
                  rupee: int.parse(_rupeeController.text),
                ),
              )
                  .then(
                (_) {
                  Get.back();
                },
              );
            },
            child: Text("Update"),
          ),
        ],
      ),
    );
  }
}

class CustomDelegate extends SearchDelegate<UserModel> {
  List<UserModel> users;
  CustomDelegate({required List<UserModel> this.users});

  @override
  List<Widget> buildActions(BuildContext context) =>
      [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
      icon: Icon(Icons.chevron_left),
      onPressed: () => close(context, users![0]));

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) {
    List<UserModel> listToShow;
    if (query.isNotEmpty) {
      listToShow = users!
          .where(
            (e) =>
                e.name.toLowerCase().contains(query) ||
                e.city.toLowerCase().contains(query) ||
                e.phoneNumber.toLowerCase().contains(query),
            // || e.startsWith(query)
          )
          .toList();
    } else {
      listToShow = users ?? [];
    }

    return ListView.builder(
      itemCount: listToShow.length,
      itemBuilder: (_, i) {
        var u = listToShow[i];
        return Card(
          child: ListTile(
            isThreeLine: false,
            leading: AppImageWidget(user: u),
            title: Text(u.name),
            subtitle: Text("${u.phoneNumber}\n${u.city}"),
            trailing: Text("${u.rupee}"),
            // onTap: () => close(context, u),
            onTap: () async {
              await HomeScreen().editData(u.id, u).then(
                    (_) => close(context, u),
                  );
            },
          ),
        );
      },
    );
  }
}
