import 'package:hive/hive.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
part 'DataModel.g.dart';

@HiveType(typeId: 0)
class DataModel{
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final bool complete;

  DataModel({required this.title, required this.description, required this.complete});

}