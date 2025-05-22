import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sorteio_oficial/features/validator/data/models/model_whitelabel.dart';

class WhitelabelRepository {
  final String baseUrl = 'https://api.55tech.com.br/raffle/whitelabels';
  final String _bearerToken =
      'bf24aa7ce2522264093a553e34a8b0b25cee9423c5a6ce054e4ab38fe3af3a232fca32e5710ac12c49835cfea27003f253fcfba10d7d9a08838442626eb1c1438df7e40c00f099251a05037acbb265623d8f9be2db17eb10cc13b9332fc88195fe4ea8ffaa2d3b6fd2ca83cdf60981e3cd55b5b88853e168534b4976dafd0581';

  Future<ModelWhitelabelResponse?> getWhitelabel(String accessCode) async {
    final uri = Uri.parse(baseUrl).replace(
      queryParameters: {
        'filters[accessCode][\$eq]': accessCode,
        'populate': '*',
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_bearerToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['data'].isEmpty) {
        return null;
      } else {
        final responseMap = {'data': data['data'][0]};
        return ModelWhitelabelResponse.fromMap(responseMap);
      }
    } else {
      throw Exception('Falha ao buscar evento: ${response.statusCode}');
    }
  }
}
