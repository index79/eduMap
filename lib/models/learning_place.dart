class LearningPlace {
  final String name;
  final DateTime startingDate;
  final String? placeUrl;

  LearningPlace({
    required this.name,
    required this.startingDate,
    this.placeUrl,
  });
}

List<LearningPlace> learningPaces = [
  LearningPlace(
    name: '해운대 IT 전문 무료 교육',
    startingDate: DateTime.now(),
  ),
  LearningPlace(name: '원 IT 아카데미 부산 지점', startingDate: DateTime.now()),
  LearningPlace(name: '부산 SBS 게임학원', startingDate: DateTime.now()),
];
