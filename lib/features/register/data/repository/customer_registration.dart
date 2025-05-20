import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sorteio_oficial/core/database/dao/customer_dao.dart';

class RemoteCustomerService {
  final String _baseUrl = 'https://api.55tech.com.br/raffle/customers';
  final String _token =
      'bf24aa7ce2522264093a553e34a8b0b25cee9423c5a6ce054e4ab38fe3af3a232fca32e5710ac12c49835cfea27003f253fcfba10d7d9a08838442626eb1c1438df7e40c00f099251a05037acbb265623d8f9be2db17eb10cc13b9332fc88195fe4ea8ffaa2d3b6fd2ca83cdf60981e3cd55b5b88853e168534b4976dafd0581';

  Future<List<dynamic>> fetchCustomersByEventId(int eventId) async {
    final uri = Uri.parse(
      '$_baseUrl?filters[event][id][\$eq]=$eventId',
    );

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_token',
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Erro ao buscar clientes do evento $eventId: ${response.statusCode}');
    }
  }

  Future<void> syncCustomers(CustomerDao dao, int eventId) async {
    final unsyncedCustomers = await dao.getUnsyncedCustomersByEvent(eventId);

    for (final customer in unsyncedCustomers) {
      final body = {
        "data": {
          "name": customer.name,
          "email": customer.email,
          "phone": customer.phone,
          "sorted": customer.sorted,
          "event": {
            "id": customer.event
          }
        }
      };

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      };

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: headers,
        body: jsonEncode(body),
      );

     if (response.statusCode == 200 || response.statusCode == 201) {
      print('Cliente sincronizado com sucesso: ${customer.email}');
    } else {
      print('Erro ao sincronizar cliente ${customer.email}: ${response.statusCode}');
      print(response.body);
    }
  }
  }}