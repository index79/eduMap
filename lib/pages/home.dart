import 'package:eduMap/constants/style_constant.dart';
import 'package:eduMap/models/category.dart';
import 'package:eduMap/models/learning_place.dart';
import 'package:eduMap/widgets/carousal_slider.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _categoryList() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 120,
      child: ListView.builder(
        itemCount: categories.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 75.0,
                width: 75.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(100.0),
                  // color: _selectedCategories.contains(categories[index].name)
                  //     ? Colors.blueAccent
                  //     : null,
                ),
                child: Transform.scale(
                  scale: 0.5,
                  child: Image.asset(categories[index].iconPath),
                ),
                //  ),
              ),
              SizedBox(height: 5),
              Text(categories[index].name, style: StyleConstants.categoryTitle)
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarousalSlider(imageUrls: [
                // 'https://picsum.photos/id/237/400/300',
                // 'https://picsum.photos/id/10/400/300',
                // 'https://picsum.photos/id/11/400/300',
                "images/main_img.png",
              ], isNetwork: false),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Category", style: StyleConstants.heading),
                  Text("All Category", style: StyleConstants.headingBlue),
                ],
              ),
              SizedBox(height: 10),
              _categoryList(),
              SizedBox(height: 30),
              Text("Learnng Info", style: StyleConstants.heading),
              SizedBox(height: 10),
              // _learningPlaceList(),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                      lerningInfos.length,
                      (index) => Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border(
                              bottom: BorderSide(color: Colors.black12),
                              left: BorderSide(color: Colors.black12),
                              top: BorderSide(color: Colors.black12),
                            )),
                            height: 200,
                            width: 130,
                            child: Column(children: [
                              Image.asset(
                                lerningInfos[index].imageUrl,
                                width: 90,
                              ),
                              SizedBox(height: 5),
                              Text(
                                lerningInfos[index].name,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(
                                lerningInfos[index].duration,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.lightBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '신청하기',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.red,
                                ),
                              )
                            ]),
                          )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LearningInfo {
  final String imageUrl;
  final String name;
  final String duration;

  LearningInfo({
    required this.imageUrl,
    required this.name,
    required this.duration,
  });
}

List<LearningInfo> lerningInfos = [
  LearningInfo(
    imageUrl: "images/location_01.png",
    name: "해운대 IT 전문\n\t 무료 교육",
    duration: "2023.06.23~",
  ),
  LearningInfo(
    imageUrl: "images/location_02.png",
    name: "윈 IT 아카데미\n\t 부산지점",
    duration: "2023.07.01~",
  ),
  LearningInfo(
    imageUrl: "images/location_03.png",
    name: "부산 SBS\n\t 게임학원",
    duration: "2023.07.30~",
  ),
];
