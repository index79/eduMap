class Category {
  final String name;
  final String iconPath;

  Category({required this.name, required this.iconPath});
}

List<Category> categories = [
  Category(name: '컴퓨터활용', iconPath: 'images/m01.png'),
  Category(name: '스마트폰활용', iconPath: 'images/m02.png'),
  Category(name: 'SNS활용', iconPath: 'images/m03.png'),
  Category(name: '프로그래밍', iconPath: 'images/m04.png'),
  Category(name: '디지털이론', iconPath: 'images/m05.png'),
  Category(name: '디자인', iconPath: 'images/m06.png'),
  Category(name: '사진/영상', iconPath: 'images/m07.png'),
  Category(name: '웹툰/일러스트', iconPath: 'images/m08.png'),
  Category(name: '스페셜', iconPath: 'images/m09.png'),
];
