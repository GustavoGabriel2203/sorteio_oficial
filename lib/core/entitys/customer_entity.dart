import 'package:floor/floor.dart';

@Entity(tableName: 'Customers')
class Customer {
  @primaryKey
  final int id;
  final String name;
  final String email;
  final String phone;
  final String company;
  final int sorted; // 0 = não sorteado, 1 = sorteado
  final int event; // ID do evento
  final int sync; // 0 = não sincronizado, 1 = sincronizado

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.company,
    required this.sorted,
    required this.event,
    required this.sync,
  });
}
