class EventModel {
  final int? id;
  final String name;
  final int whitelabel;
  final int selected;

  EventModel({
    this.id,
    required this.name,
    required this.whitelabel,
    this.selected = 0,
  });

  factory EventModel.fromJson(Map<String, dynamic> data) {
    final attributes = data['attributes'] ?? {};
    final whitelabelData = attributes['whitelabel']?['data']?['id'];

    return EventModel(
      id: data['id'],
      name: attributes['name'] ?? '',
      whitelabel: whitelabelData ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'whitelabel': whitelabel,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'whitelabel': whitelabel,
      'selected': selected,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'],
      name: map['name'],
      whitelabel: map['whitelabel'],
      selected: map['selected'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'EventModel{id: $id, name: $name, whitelabel: $whitelabel, selected: $selected}';
  }
}
