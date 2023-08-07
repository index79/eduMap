import 'package:eduMap/pages/view_mentors_respond.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceivedEstimate extends StatelessWidget {
  const ReceivedEstimate({super.key});

  Widget buildListItem() {
    return Container(
      child: ListView.separated(
        itemCount: dummyItems.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          DummyItem item = dummyItems[index];
          List<DummyMentors> mentors = item.mentors;
          double status = item.status == Status.requested
              ? 0
              : item.status == Status.inProgress
                  ? 50
                  : 100;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewMentorsRespond(item: item)));
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          DateFormat('yyyy.MM.dd').format(item.date),
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: status / 100,
                        backgroundColor: Colors.grey[200],
                        color: item.status == Status.completed
                            ? Colors.grey
                            : Colors.teal,
                        minHeight: 15,
                      ),
                    ),
                    SizedBox(height: 7),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('견적요청', style: progressBarStyle(1, item.status)),
                        Text('상담진행', style: progressBarStyle(2, item.status)),
                        Text('거래완료', style: progressBarStyle(3, item.status)),
                      ],
                    ),
                    SizedBox(height: 10),
                    if (mentors.length > 0)
                      Row(
                        children: [
                          Container(
                            width: 125,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  for (int i = 0; i < mentors.length; i++)
                                    Align(
                                      widthFactor: 0.8,
                                      child: CircleAvatar(
                                        radius: 15,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          child: Image.network(
                                              mentors[i].profileUrl),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            '${mentors.length}명의 멘토가 응답하였어요',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(
          thickness: 20,
          color: Colors.grey[200],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('응답한 멘토 보기'),
        elevation: 0,
        actions: [
          Icon(Icons.notifications_none_rounded),
          SizedBox(width: 20),
          Icon(Icons.person_outline),
          SizedBox(width: 20),
          OutlinedButton(onPressed: () {}, child: Text('이용안내'))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [],
              ),
            ),
            buildListItem(),
          ],
        ),
      ),
    );
  }
}

enum Status {
  requested,
  inProgress,
  completed,
}

class DummyItem {
  final String title;
  final DateTime date;
  final Status status;
  final String content;
  final List<DummyMentors> mentors;

  DummyItem({
    required this.status,
    required this.content,
    required this.title,
    required this.date,
    required this.mentors,
  });
}

class DummyMentors {
  final String name;
  final String profileUrl;
  final double rate;
  final List<String> comments;
  final int estimate;
  final int id;

  DummyMentors(
      {required this.name,
      required this.profileUrl,
      required this.rate,
      required this.comments,
      required this.estimate,
      required this.id});
}

List<DummyItem> dummyItems = [
  DummyItem(
    status: Status.requested,
    content: "",
    title: '인테리어 필름 시공',
    date: DateTime.parse('2023-06-28'),
    mentors: [
      DummyMentors(
        name: '인테리어 전문',
        profileUrl: "https://randomuser.me/api/portraits/men/36.jpg",
        rate: 5.0,
        comments: [],
        estimate: 100000,
        id: 123,
      ),
      DummyMentors(
          name: 'aa 인테리어',
          profileUrl: "https://randomuser.me/api/portraits/men/40.jpg",
          rate: 4.0,
          comments: [],
          estimate: 100000,
          id: 456),
      DummyMentors(
          name: 'bb 인테리어',
          profileUrl: "https://randomuser.me/api/portraits/women/51.jpg",
          rate: 3.0,
          comments: [],
          estimate: 100000,
          id: 789),
      DummyMentors(
          name: 'cc 인테리어',
          profileUrl: "https://randomuser.me/api/portraits/women/44.jpg",
          rate: 2.0,
          comments: [],
          estimate: 100000,
          id: 111),
    ],
  ),
  DummyItem(
    status: Status.inProgress,
    content: "",
    title: '조명 인테리어',
    date: DateTime.parse('2023-06-26'),
    mentors: [
      DummyMentors(
          name: '윤영식',
          profileUrl: "https://randomuser.me/api/portraits/men/40.jpg",
          rate: 3.1,
          comments: [],
          estimate: 100000,
          id: 222),
      DummyMentors(
          name: '태양전기',
          profileUrl: "https://randomuser.me/api/portraits/women/51.jpg",
          rate: 5.0,
          comments: [],
          estimate: 100000,
          id: 333),
    ],
  ),
  DummyItem(
    status: Status.completed,
    content: "",
    title: '용달/화물 운송',
    date: DateTime.parse('2023-05-17'),
    mentors: [
      DummyMentors(
          name: 'pravatar',
          profileUrl: "https://randomuser.me/api/portraits/women/44.jpg",
          rate: 5.0,
          comments: [],
          estimate: 100000,
          id: 444),
    ],
  ),
];

TextStyle progressBarStyle(int step, Status currentStatus) {
  if (step == 1) {
    return TextStyle(
        color:
            currentStatus == Status.requested ? Colors.black : Colors.grey[500],
        fontWeight: FontWeight.bold);
  } else if (step == 2) {
    return TextStyle(
        color: currentStatus == Status.inProgress
            ? Colors.black
            : Colors.grey[500],
        fontWeight: FontWeight.bold);
  } else {
    return TextStyle(
        color:
            currentStatus == Status.completed ? Colors.black : Colors.grey[500],
        fontWeight: FontWeight.bold);
  }
}
