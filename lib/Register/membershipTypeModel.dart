class MembershipTypeModel {
  final String id;
  final String name;

  MembershipTypeModel({this.id, this.name});

  factory MembershipTypeModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return MembershipTypeModel(
      id: json["_id"],
      name: json["MembershipType"],
    );
  }

  static List<MembershipTypeModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => MembershipTypeModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(MembershipTypeModel model) {
    return this?.id == model?.id;
  }

  @override
  String toString() => name;
}
