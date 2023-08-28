import 'package:eduMap/constants/constants.dart';
import 'package:eduMap/models/models.dart';
import 'package:eduMap/widgets/carousal_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class LectureDetail extends StatelessWidget {
  final Lecture lecture;
  final Place place;
  const LectureDetail({Key? key, required this.place, required this.lecture})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var centerProfile = getCenterProfile(place.name);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          place.name,
          style: StyleConstants.heading,
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CarousalSlider(imageUrls: centerProfile.images, isNetwork: false),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: Column(
                children: [
                  _buildItem("eduNm"),
                  _buildItem("period"),
                  _buildItem("eduLoc"),
                  _buildItem("people"),
                  _buildItem('eduSdate'),
                  _buildItem('eduTime'),
                  _buildItem('phone'),
                  OutlinedButton(
                      onPressed: () => _launchURL(centerProfile.url),
                      child: Text('신청하기')),
                  SizedBox(height: 20),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _launchURL(String _url) async {
    final Uri url = Uri.parse(_url);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Widget _buildItem(String key) {
    String title = '';
    String iconPath = '';
    String description = '';
    CenterProfile centerProfile = getCenterProfile(lecture.eduLoc);
    switch (key) {
      case 'eduNm':
        title = '교육명';
        iconPath = 'images/detail_h_img01.png';
        description = "${lecture.eduNm} / ${lecture.eduExp}";
        break;
      case 'period':
        title = '모집기간';
        iconPath = 'images/detail_h_img02.png';
        description = lecture.period;
        break;
      case 'eduLoc':
        title = '교육장소';
        iconPath = 'images/detail_h_img03.png';
        description = "${lecture.eduLoc}\n${lecture.roadAddr}";
        break;
      case 'people':
        title = '모집인원';
        iconPath = 'images/detail_h_img04.png';
        description = "최대 ${lecture.people} 명 (대상: ${lecture.target})";
        break;
      case 'eduSdate':
        title = '교육기간';
        iconPath = 'images/detail_h_img05.png';
        description =
            "${DateFormat('yyyy-MM-dd').format(lecture.eduSdate)} ~ ${DateFormat('yyyy-MM-dd').format(lecture.eduSdate)}";
        break;
      case 'eduTime':
        title = '교육시간';
        iconPath = 'images/detail_h_img06.png';
        description = lecture.eduTime;
        break;
      case 'phone':
        title = '연락처';
        iconPath = 'images/detail_h_img07.png';
        description = "${centerProfile.phone}";
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(iconPath, scale: 20),
            SizedBox(width: 10),
            Text(title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
        SizedBox(height: 7),
        Row(
          children: [
            SizedBox(width: 10),
            Text(
              description,
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
        SizedBox(height: 20)
      ],
    );
  }
}

class CenterProfile {
  final String name;
  final String phone;
  final String url;
  final List<String> images;

  CenterProfile({
    required this.images,
    required this.name,
    required this.phone,
    required this.url,
  });
}

CenterProfile getCenterProfile(String centerName) {
  print(centerName);
  switch (centerName) {
    case "문화복합센터 3층 정보화교육장":
      return CenterProfile(
        name: "문화복합센터 3층 정보화교육장",
        phone: "051-784-3400",
        url:
            "https://www.haeundae.go.kr/reserve/index.do?menuCd=DOM_000000501008000000",
        images: [
          "images/해운대문화복합센터01.jpg",
          "images/해운대문화복합센터02.jpg",
          "images/해운대문화복합센터03.jpg"
        ],
      );
    case "좌1동 행정복지센터 3층 정보화교육장":
      return CenterProfile(
        name: "좌1동 행정복지센터 3층 정보화교육장",
        phone: "051-749-4306",
        url:
            "https://www.haeundae.go.kr/reserve/index.do?menuCd=DOM_000000501008000000",
        images: [
          "images/해운대좌1동행정복지센터01.jpg",
          "images/해운대좌1동행정복지센터02.jpg",
          "images/해운대좌1동행정복지센터03.jpg"
        ],
      );
    case "강서구청 여성센터 정보화교육장":
      return CenterProfile(
        name: "강서구청 여성센터 정보화교육장",
        phone: "051-970-4301",
        url: "https://lll.bsgangseo.go.kr/html/",
        images: [
          "images/강서구청여성센터02.jpg",
          "images/강서구청여성센터03.jpg",
        ],
      );
  }
  return CenterProfile(
    name: "기장군청 멀티미디어교육장",
    phone: "1800-0096",
    url: "https://www.gijang.go.kr/index.gijang?menuCd=DOM_000000104001003000",
    images: [
      "images/기장군청멀티미디어교육장01.jpg",
    ],
  );
}
