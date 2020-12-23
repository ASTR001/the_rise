class DistrictModel {
  final String id;
  final String name;

  DistrictModel({this.id, this.name});

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return DistrictModel(
      id: json["_id"],
      name: json["district"],
    );
  }

  static List<DistrictModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => DistrictModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(DistrictModel model) {
    return this?.id == model?.id;
  }

  @override
  String toString() => name;
}
