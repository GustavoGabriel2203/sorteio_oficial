import 'package:floor/floor.dart';

@Entity(tableName: 'Whitelabels')
class Whitelabel {
  @PrimaryKey()
  final int id;

  Whitelabel({required this.id});
}
