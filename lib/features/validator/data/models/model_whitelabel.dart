import 'dart:convert';

/// Modelo da resposta da API que envolve os dados do whitelabel
class ModelWhitelabelResponse {
  final WhiteLabel data;

  ModelWhitelabelResponse({required this.data});

  factory ModelWhitelabelResponse.fromMap(Map<String, dynamic> map) {
    return ModelWhitelabelResponse(
      data: WhiteLabel.fromMap(map['data'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data.toMap(),
    };
  }

  factory ModelWhitelabelResponse.fromJson(String source) =>
      ModelWhitelabelResponse.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}

/// Modelo dos dados internos do whitelabel
class WhiteLabel {
  final String name;
  final String accessCode;
  final int eventId;

  WhiteLabel({
    required this.name,
    required this.accessCode,
    required this.eventId,
  });

  factory WhiteLabel.fromMap(Map<String, dynamic> map) {
    final attributes = map['attributes'] ?? {};

    return WhiteLabel(
      name: attributes['name'] ?? '',
      accessCode: attributes['accessCode'] ?? '',
      eventId: map['id'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'accessCode': accessCode,
      'eventId': eventId,
    };
  }

  factory WhiteLabel.fromJson(String source) =>
      WhiteLabel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}
