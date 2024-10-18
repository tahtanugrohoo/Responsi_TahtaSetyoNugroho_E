class Keuangan {
  int? id;
  String? itemKeuangan;
  int? allocatedKeuangan;
  int? spentKeuangan;

  Keuangan(
      {this.id, this.itemKeuangan, this.allocatedKeuangan, this.spentKeuangan});
  factory Keuangan.fromJson(Map<String, dynamic> json) {
    return Keuangan(
      id: json['id'],
      itemKeuangan: json['budget_item'],
      allocatedKeuangan: json['allocated'],
      spentKeuangan: json['spent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'budget_item': itemKeuangan,
      'allocated': allocatedKeuangan,
      'spent': spentKeuangan,
    };
  }
}
