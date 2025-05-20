import 'package:floor/floor.dart';

@Entity(tableName: 'Customers')
class Customer {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;
  final String email;
  final String phone;
  final int sorted; // 0 = não sorteado, 1 = sorteado
  final int event;  // ID do evento
  final int sync;   // 0 = não sincronizado, 1 = sincronizado

  Customer({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.sorted,
    required this.event,
    required this.sync,
  });
}
