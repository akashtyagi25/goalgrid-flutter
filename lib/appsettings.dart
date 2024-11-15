import 'package:isar/isar.dart';
//run cmd to generate file: dart run build_runner  build
part 'appsettings.g.dart';

@Collection()
class Appsettings {
  Id id=Isar.autoIncrement;
  DateTime? firstLaunchDate;
  


}