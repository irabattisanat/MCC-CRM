class LeadStatusModel {
  final String id;
  final String name;
  final int order;
  final bool isActive;

  LeadStatusModel({
    required this.id,
    required this.name,
    required this.order,
    required this.isActive,
  });

  factory LeadStatusModel.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return LeadStatusModel(
      id: id,
      name: map['name'] ?? '',
      order: map['order'] ?? 0,
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'order': order,
      'isActive': isActive,
    };
  }
}