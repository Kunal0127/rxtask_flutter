import 'package:flutter/material.dart';
import 'package:rxtask/model/user_model.dart';

class AppImageWidget extends StatelessWidget {
  final UserModel user;

  const AppImageWidget({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      width: 54,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
        image: DecorationImage(
            image: NetworkImage(user.imageUrl), fit: BoxFit.cover),
        border: Border.all(width: 2),
      ),
      child: Icon(
        Icons.person_2,
        size: 32,
        color: Colors.white,
      ),
    );
  }
}
