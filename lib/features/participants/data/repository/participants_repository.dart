import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sorteio_oficial/core/database/dao/whitelabel_dao.dart';
import 'package:sorteio_oficial/features/participants/data/models/participants_model.dart';

class ParticipantService {
  final WhitelabelDao whitelabelDao;

  final String _baseUrl = 'https://api.55tech.com.br/raffle/customers';
  final String _token =
      'bf24aa7ce2522264093a553e34a8b0b25cee9423c5a6ce054e4ab38fe3af3a232fca32e5710ac12c49835cfea27003f253fcfba10d7d9a08838442626eb1c1438df7e40c00f099251a05037acbb265623d8f9be2db17eb10cc13b9332fc88195fe4ea8ffaa2d3b6fd2ca83cdf60981e3cd55b5b88853e168534b4976dafd0581';

  ParticipantService(this.whitelabelDao);

  Future<List<ParticipantModel>> fetchParticipantsFromCurrentEvent() async {
    final whitelabel = await whitelabelDao.getWhitelabel();

    if (whitelabel == null) {
      throw Exception('Whitelabel não encontrado no banco local.');
    }

    final uri = Uri.parse(
      '$_baseUrl?filters[event][id][\$eq]=${whitelabel.id}',
    );

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      return data.map((json) => ParticipantModel.fromJson(json)).toList();
    } else {
      throw Exception(
        'Erro ao buscar participantes do evento ${whitelabel.id}: ${response.statusCode}',
      );
    }
  }
}
