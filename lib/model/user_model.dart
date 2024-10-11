import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String phoneNumber;
  @HiveField(3)
  final String city;
  @HiveField(4)
  final String imageUrl;
  @HiveField(5)
  final int rupee;

  UserModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.city,
    required this.imageUrl,
    required this.rupee,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      city: json['city'],
      imageUrl: json['imageUrl'],
      rupee: json['rupee'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'city': city,
      'imageUrl': imageUrl,
      'rupee': rupee,
    };
  }
}
