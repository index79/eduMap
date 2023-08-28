import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarousalSlider extends StatefulWidget {
  final List<String> imageUrls;
  final bool isNetwork;
  const CarousalSlider(
      {super.key, required this.imageUrls, required this.isNetwork});

  @override
  State<CarousalSlider> createState() => _CarousalSliderState();
}

class _CarousalSliderState extends State<CarousalSlider> {
  @override
  Widget build(BuildContext context) {
    var currentImageIndex = 0;

    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              initialPage: 0,
              viewportFraction: 1,
              enlargeCenterPage: true,
              autoPlay: true,
              onPageChanged: (index, reason) => setState(() {
                currentImageIndex = index;
              }),
            ),
            items: widget.imageUrls.map(
              (url) {
                return Builder(
                  builder: (BuildContext context) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: widget.isNetwork
                            ? Image.network(url, fit: BoxFit.fill)
                            : Image.asset(url, fit: BoxFit.fill),
                      ),
                    );
                  },
                );
              },
            ).toList(),
          ),
          SizedBox(height: 10),
          AnimatedSmoothIndicator(
            activeIndex: currentImageIndex,
            count: widget.imageUrls.length,
            effect: JumpingDotEffect(
              dotHeight: 10,
              dotWidth: 10,
              activeDotColor: Colors.blue,
              dotColor: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
