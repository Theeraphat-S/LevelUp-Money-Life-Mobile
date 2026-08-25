import 'package:equatable/equatable.dart';

class QuickTemplate extends Equatable {
  final String id;
  final String name;
  final String category;
  final double defaultAmount;
  final bool isIncome;
  final bool isPinned;

  const QuickTemplate({
    required this.id,
    required this.name,
    required this.category,
    required this.defaultAmount,
    this.isIncome = false,
    this.isPinned = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'defaultAmount': defaultAmount,
      'isIncome': isIncome,
      'isPinned': isPinned,
    };
  }

  factory QuickTemplate.fromMap(Map<String, dynamic> map) {
    return QuickTemplate(
      id: map['id'] as String,
      name: map['name'] as String,
      category: map['category'] as String,
      defaultAmount: (map['defaultAmount'] as num).toDouble(),
      isIncome: map['isIncome'] as bool? ?? false,
      isPinned: map['isPinned'] as bool? ?? false,
    );
  }

  static const List<QuickTemplate> defaultTemplates = [
    QuickTemplate(
      id: 'template_coffee',
      name: 'กาแฟ',
      category: 'Food',
      defaultAmount: 60.0,
      isPinned: true,
    ),
    QuickTemplate(
      id: 'template_lunch',
      name: 'ข้าวกลางวัน',
      category: 'Food',
      defaultAmount: 50.0,
      isPinned: true,
    ),
    QuickTemplate(
      id: 'template_transit',
      name: 'ค่าเดินทาง',
      category: 'Transit',
      defaultAmount: 40.0,
      isPinned: true,
    ),
    QuickTemplate(
      id: 'template_groceries',
      name: 'ของใช้',
      category: 'Needs',
      defaultAmount: 150.0,
    ),
    QuickTemplate(
      id: 'template_snack',
      name: 'ขนม / เครื่องดื่ม',
      category: 'Food',
      defaultAmount: 35.0,
    ),
  ];

  @override
  List<Object?> get props => [id, name, category, defaultAmount, isIncome, isPinned];
}

