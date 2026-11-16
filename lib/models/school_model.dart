class SchoolModel {
  final String id;
  final String name;

  SchoolModel({
    required this.id,
    required this.name,
  });

  factory SchoolModel.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return SchoolModel(
      id: id,
      name: map['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}