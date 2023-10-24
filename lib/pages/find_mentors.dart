import 'package:eduMap/models/mentor.dart';
import 'package:flutter/material.dart';

class FindMentors extends StatelessWidget {
  const FindMentors({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                              _breakDownWordIntoRow(mentors[index].fields),
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
                                          MaterialStateProperty.all(
                                              Colors.blue)))
                            ],
                          )
                        ],
                      ),
                    ),
                  )),
        ),
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
