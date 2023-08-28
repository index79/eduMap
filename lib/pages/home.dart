import 'package:carousel_slider/carousel_slider.dart';
import 'package:eduMap/constants/style_constant.dart';
import 'package:eduMap/models/category.dart';
import 'package:eduMap/models/learning_place.dart';
import 'package:eduMap/widgets/carousal_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _learningPlaceList() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 120,
      child: ListView.builder(
        itemCount: learningPaces.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 15, 10),
              height: 80.0,
              width: 80.0,
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
            Text(categories[index].name, style: StyleConstants.categoryTitle)
          ],
        ),
      ),
    );
  }

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

  // carousalSlider() {
  //   List<String> imageUrls = [
  //     'https://picsum.photos/id/237/400/300',
  //     'https://picsum.photos/id/10/400/300',
  //     'https://picsum.photos/id/11/400/300',
  //   ];

  //   return Container(
  //     padding: EdgeInsets.all(10),
  //     child: Column(
  //       children: [
  //         CarouselSlider(
  //           options: CarouselOptions(
  //             initialPage: 0,
  //             viewportFraction: 1,
  //             enlargeCenterPage: true,
  //             autoPlay: true,
  //             onPageChanged: (index, reason) => setState(() {
  //               currentImageIndex = index;
  //             }),
  //           ),
  //           items: imageUrls.map(
  //             (url) {
  //               return Builder(
  //                 builder: (BuildContext context) {
  //                   return ClipRRect(
  //                     borderRadius: BorderRadius.circular(20.0),
  //                     child: SizedBox(
  //                       width: MediaQuery.of(context).size.width * 0.9,
  //                       child: Image.network(url, fit: BoxFit.fill),
  //                     ),
  //                   );
  //                 },
  //               );
  //             },
  //           ).toList(),
  //         ),
  //         SizedBox(height: 10),
  //         AnimatedSmoothIndicator(
  //           activeIndex: currentImageIndex,
  //           count: imageUrls.length,
  //           effect: JumpingDotEffect(
  //             dotHeight: 10,
  //             dotWidth: 10,
  //             activeDotColor: Colors.blue,
  //             dotColor: Colors.grey,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 1,
      //   centerTitle: true,
      //   toolbarHeight: 90,
      //   title: Image.asset('images/logo.png', width: 150),
      //   actions: [
      //     IconButton(
      //         onPressed: () {},
      //         icon: Icon(
      //           Icons.access_alarm_sharp,
      //           color: Colors.black45,
      //           size: 30,
      //         )),
      //     IconButton(
      //       onPressed: () {},
      //       icon: Icon(
      //         Icons.notifications_none_outlined,
      //         color: Colors.black45,
      //         size: 30,
      //       ),
      //     )
      //   ],
      // ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarousalSlider(imageUrls: [
                'https://picsum.photos/id/237/400/300',
                'https://picsum.photos/id/10/400/300',
                'https://picsum.photos/id/11/400/300',
              ], isNetwork: true),
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
            ],
          ),
        ),
      ),
    );
  }
}
