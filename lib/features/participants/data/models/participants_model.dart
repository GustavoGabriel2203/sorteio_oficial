class ParticipantModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final int sorted;

  ParticipantModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.sorted,
  });

  factory ParticipantModel.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'];

    return ParticipantModel(
      id: json['id'],
      name: attributes['name'],
      email: attributes['email'],
      phone: attributes['phone'],
      sorted: attributes['sorted'],
    );
  }
}
