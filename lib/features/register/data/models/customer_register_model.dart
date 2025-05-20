import 'package:sorteio_oficial/core/entitys/customer_entity.dart';


class CustomerRegister {
  final String name;
  final String email;
  final String phone;
  final int event;

  CustomerRegister({
    required this.name,
    required this.email,
    required this.phone,
    required this.event,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'event': {'id': event},
    };
  }

  factory CustomerRegister.fromJson(Map<String, dynamic> json) {
    return CustomerRegister(
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      event: json['event']['id'],
    );
  }

  /// Conversão para a entidade `Customer` do banco de dados
  Customer toEntity({
    int? id, 
    int sorted = 0,
    int sync = 0,
    String company = '',
  }) {
    return Customer(
      id : id,
      name: name,
      email: email,
      phone: phone,
      sorted: sorted,
      event: event,
      sync: sync,
    );
  }

  @override
  String toString() {
    return 'CustomerRegister{name: $name, email: $email, phone: $phone, event: $event}';
  }
}
