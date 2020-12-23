class CityModel {
  final String id;
  final String name;

  CityModel({this.id, this.name});

  factory CityModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return CityModel(
      id: json["_id"],
      name: json["CityName"],
    );
  }

  static List<CityModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => CityModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(CityModel model) {
    return this?.id == model?.id;
  }

  @override
  String toString() => name;
}
