import 'package:eduMap/pages/chat_page.dart';
import 'package:eduMap/pages/received_estimate.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewMentorsRespond extends StatelessWidget {
  const ViewMentorsRespond({super.key, required this.item});
  final DummyItem item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
      ),
      body: Container(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: item.mentors.length,
          itemBuilder: (context, index) {
            var mentor = item.mentors[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(mentor.profileUrl, width: 60),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mentor.name,
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.bold),
                            ),
                            Row(children: [
                              Icon(Icons.star,
                                  color: Colors.yellow[700], size: 19),
                              SizedBox(height: 30),
                              Text(
                                mentor.rate.toString(),
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '(${mentor.comments.length})',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ])
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      '총 ${NumberFormat('#,##0', 'en_US').format(mentor.estimate)}원',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Row(children: [
                      OutlinedButton(onPressed: () {}, child: Text('견적서 보기')),
                      SizedBox(width: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                arguments: ChatPageArguments(
                                  peerId: mentor.id.toString(),
                                  peerAvatar: mentor.profileUrl,
                                  peerNickname: mentor.name,
                                ),
                              ),
                            ),
                          );
                        },
                        child: Text(
                          '채팅하기',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.blue[200]),
                      )
                    ]),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
