import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sorteio_oficial/features/events/data/models/event_model.dart';

abstract class BaseEventService {
  Future<EventModel> fetchEventById(int eventId);
}

class RREventService extends BaseEventService {
  final String _baseUrl = 'https://api.rrservice.com.br/raffle/events';
  final String _token =
      'bf24aa7ce2522264093a553e34a8b0b25cee9423c5a6ce054e4ab38fe3af3a232fca32e5710ac12c49835cfea27003f253fcfba10d7d9a08838442626eb1c1438df7e40c00f099251a05037acbb265623d8f9be2db17eb10cc13b9332fc88195fe4ea8ffaa2d3b6fd2ca83cdf60981e3cd55b5b88853e168534b4976dafd0581';

  @override
  Future<EventModel> fetchEventById(int eventId) async {
    final uri = Uri.parse('$_baseUrl/$eventId');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return EventModel.fromJson(data['data']);
    } else {
      throw Exception(
        'Erro ao buscar evento ID $eventId: ${response.statusCode}',
      );
    }
  }
}

class RemoteEventService extends BaseEventService {
  final String _baseUrl = 'https://api.55tech.com.br/raffle/events';
  final String _token =
      'bf24aa7ce2522264093a553e34a8b0b25cee9423c5a6ce054e4ab38fe3af3a232fca32e5710ac12c49835cfea27003f253fcfba10d7d9a08838442626eb1c1438df7e40c00f099251a05037acbb265623d8f9be2db17eb10cc13b9332fc88195fe4ea8ffaa2d3b6fd2ca83cdf60981e3cd55b5b88853e168534b4976dafd0581';

  @override
  Future<EventModel> fetchEventById(int eventId) async {
    final queryParameters = {
      'filters[whitelabel][id][\$eq]': eventId.toString(),
      'populate': '*',
    };
    final uri = Uri.parse(_baseUrl).replace(queryParameters: queryParameters);

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return EventModel.fromJson(data['data']);
    } else {
      throw Exception(
        'Erro ao buscar evento ID $eventId: ${response.statusCode}',
      );
    }
  }
}
