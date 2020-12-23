class RegionModel {
  final String id;
  final String name;

  RegionModel({this.id, this.name});

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return RegionModel(
      id: json["_id"],
      name: json["region"],
    );
  }

  static List<RegionModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => RegionModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(RegionModel model) {
    return this?.id == model?.id;
  }

  @override
  String toString() => name;
}
