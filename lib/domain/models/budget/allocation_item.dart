class AllocationItem {
  final String id;
  final String label;
  final int percent;
  final String color;

  const AllocationItem({
    required this.id,
    required this.label,
    required this.percent,
    required this.color,
  });

  double getBudgetAmount(double monthlyIncome) =>
      (monthlyIncome * percent) / 100.0;

  AllocationItem copyWith({
    String? id,
    String? label,
    int? percent,
    String? color,
  }) {
    return AllocationItem(
      id: id ?? this.id,
      label: label ?? this.label,
      percent: percent ?? this.percent,
      color: color ?? this.color,
    );
  }

  factory AllocationItem.fromJson(Map<String, dynamic> json) {
    return AllocationItem(
      id: json['id'] as String? ?? 'needs',
      label: json['label'] as String? ?? 'Needs',
      percent: (json['percent'] as num?)?.round() ?? 50,
      color: json['color'] as String? ?? '#1C5954',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'percent': percent,
      'color': color,
    };
  }

  static const List<AllocationItem> defaultAllocations = [
    AllocationItem(
      id: 'needs',
      label: 'Needs',
      percent: 50,
      color: '#1C5954', // Deep Teal
    ),
    AllocationItem(
      id: 'wants',
      label: 'Wants',
      percent: 30,
      color: '#879B62', // Moss
    ),
    AllocationItem(
      id: 'savings',
      label: 'Savings',
      percent: 20,
      color: '#4D8E75', // Soft Jade
    ),
  ];
}
