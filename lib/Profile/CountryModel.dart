class CountryModel {
  final String id;
  final String name;

  CountryModel({this.id, this.name});

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return CountryModel(
      id: json["_id"],
      name: json["CountryName"],
    );
  }

  static List<CountryModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => CountryModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(CountryModel model) {
    return this?.id == model?.id;
  }

  @override
  String toString() => name;
}
