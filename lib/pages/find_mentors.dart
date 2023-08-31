import 'package:flutter/material.dart';

class FindMentors extends StatelessWidget {
  const FindMentors({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: List.generate(
            mentors.length,
            (index) => Card(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: Image.network(mentors[index].imageUrl),
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mentors[index].name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(mentors[index].field),
                                Row(
                                  children: [
                                    Text('지역:'),
                                    SizedBox(width: 5),
                                    Text(mentors[index].region),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(mentors[index].intro),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text("멘토 등록일: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                )),
                            Text(mentors[index].registerDate),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text("멘토의 경험: ",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.blue)),
                            _breakDownWordIntoRow(mentors[index].experience),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.favorite,
                                  color: Colors.purple,
                                ),
                                SizedBox(width: 5),
                                Text('1'),
                              ],
                            ),
                            TextButton(
                                onPressed: () {},
                                child: Text(
                                  "멘토신청",
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.blue)))
                          ],
                        )
                      ],
                    ),
                  ),
                )),
      ),
    );
  }
}

Widget _breakDownWordIntoRow(String word) {
  var words = word.split(",");
  List<Widget> result = [];
  for (var word in words) {
    result.add(Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 226, 201, 247),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        word,
        style: TextStyle(
          color: Color.fromARGB(255, 52, 33, 156),
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    ));
    result.add(SizedBox(width: 7));
  }

  return Row(
    children: result,
  );
}

class Mentor {
  final String name;
  final String region;
  final String intro;
  final String registerDate;
  final String experience;
  final String imageUrl;
  final String field;

  Mentor({
    required this.name,
    required this.region,
    required this.intro,
    required this.registerDate,
    required this.experience,
    required this.imageUrl,
    required this.field,
  });
}

List<Mentor> mentors = [
  Mentor(
    name: "김하나",
    region: "서울 강남 강남역",
    intro:
        "대기업 인사팀 경험 후 스타트업 피플팀 리더를 맡고 있습니다. 대기업에서 스타트업 이직 고민하고 있는 분 티타임 신청해 주세요 :)",
    registerDate: "2023.08.01",
    experience: "프론트엔드,앱기획,마케팅",
    imageUrl: "https://randomuser.me/api/portraits/women/44.jpg",
    field: "앱기획 분야 멘토",
  )
];
