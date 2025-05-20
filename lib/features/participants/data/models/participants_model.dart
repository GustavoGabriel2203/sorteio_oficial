class ParticipantModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final int sorted;
  final int eventId; 

  ParticipantModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.sorted,
    required this.eventId,
  });

  factory ParticipantModel.fromJson(Map<String, dynamic> json) {
  final attributes = json['attributes'];
  final eventData = attributes['event']?['data'];

  return ParticipantModel(
    id: json['id'],
    name: attributes['name'] ?? '',
    email: attributes['email'] ?? '',
    phone: attributes['phone'] ?? '',
    sorted: attributes['sorted'] ?? 0,
    eventId: eventData != null ? eventData['id'] : 0, 
  );}
}
