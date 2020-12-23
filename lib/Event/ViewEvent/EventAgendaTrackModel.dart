class EventAgendaTrackModel {
  final String id;
  final String name;

  EventAgendaTrackModel({this.id, this.name});

  factory EventAgendaTrackModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return EventAgendaTrackModel(
      id: json["_id"],
      name: json["TrackName"],
    );
  }

  static List<EventAgendaTrackModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => EventAgendaTrackModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(EventAgendaTrackModel model) {
    return this?.id == model?.id;
  }

  @override
  String toString() => name;
}
