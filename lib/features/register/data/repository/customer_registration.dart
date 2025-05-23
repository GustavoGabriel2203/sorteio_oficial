import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sorteio_oficial/core/entitys/customer_entity.dart';

class RemoteCustomerService {
  final String _baseUrl = 'https://api.55tech.com.br/raffle/customers';
  final String _token =
      'bf24aa7ce2522264093a553e34a8b0b25cee9423c5a6ce054e4ab38fe3af3a232fca32e5710ac12c49835cfea27003f253fcfba10d7d9a08838442626eb1c1438df7e40c00f099251a05037acbb265623d8f9be2db17eb10cc13b9332fc88195fe4ea8ffaa2d3b6fd2ca83cdf60981e3cd55b5b88853e168534b4976dafd0581';

  Future<bool> sendSingleCustomer(Customer customer) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({
          "data": {
            "name": customer.name,
            "email": customer.email,
            "phone": customer.phone,
            "sorted": customer.sorted,
            "event": {"id": customer.event}
          }
        }),
      );

      final isSuccess = response.statusCode == 200 || response.statusCode == 201;
      

      if (!isSuccess) {
        print('Erro ao enviar cliente: ${response.statusCode}');
        print(response.body);
      }

      return isSuccess;
    } catch (e) {
      print('Erro ao enviar cliente: $e');
      return false;
    }
  }
}
