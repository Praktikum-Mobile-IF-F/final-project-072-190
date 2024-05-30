import 'package:hive/hive.dart';

part 'user.g.dart';


@HiveType(typeId: 7)
class User extends HiveObject {

  @HiveField(0)
  String? id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String birth;

  @HiveField(3)
  final String address;


  User({
    required this.email,
    required this.birth,
    required this.address,
  });
}