class MembershipClassifyModel {
  final String id;
  final String name;

  MembershipClassifyModel({this.id, this.name});

  factory MembershipClassifyModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return MembershipClassifyModel(
      id: json["_id"],
      name: json["Membershipclassfication"],
    );
  }

  static List<MembershipClassifyModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => MembershipClassifyModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(MembershipClassifyModel model) {
    return this?.id == model?.id;
  }

  @override
  String toString() => name;
}
