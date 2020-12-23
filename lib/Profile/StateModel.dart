class StateModel {
  final String id;
  final String name;

  StateModel({this.id, this.name});

  factory StateModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return StateModel(
      id: json["_id"],
      name: json["StateName"],
    );
  }

  static List<StateModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => StateModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(StateModel model) {
    return this?.id == model?.id;
  }

  @override
  String toString() => name;
}
