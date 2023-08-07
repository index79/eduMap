import 'package:eduMap/pages/chat_list.dart';
import 'package:eduMap/pages/empty.dart';
import 'package:eduMap/pages/home.dart';
import 'package:eduMap/pages/places_to_learn.dart';
import 'package:eduMap/pages/received_estimate.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  int _selectedIndex = 0;
  bool _showMore = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: const [
            Home(),
            PlacesToLearn(),
            Empty(),
            ReceivedEstimate(),
            ChatList(),
          ],
        ),
        bottomNavigationBar: Stack(
          children: [
            BottomNavigationBar(
              items: [
                bottomeNavigationBarItem(
                    0, 'images/bottom_studycenter.png', '홈'),
                bottomeNavigationBarItem(
                    1, 'images/bottom_studycenter.png', '배움터'),
                bottomeNavigationBarItem(
                    2, 'images/bottom_studycenter.png', 'e'),
                bottomeNavigationBarItem(3, 'images/bottom_mentor.png', '멘토찾기'),
                bottomeNavigationBarItem(
                    4, 'images/bottom_mentee.png', '받은 견적'),
              ],
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedIconTheme: const IconThemeData(color: Colors.blueAccent),
              unselectedIconTheme: const IconThemeData(color: Colors.grey),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 45,
                  child: FloatingActionButton(
                    heroTag: null,
                    child: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        _showMore = true; // Toggle the showMore state
                        if (_showMore) _showSubMenus();
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showSubMenus() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: 200,
          height: 200,
          margin: const EdgeInsets.only(bottom: 60),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'images/quick_background.png',
              ),
              fit: BoxFit.contain,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                  top: 0,
                  right: 70,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Colors.white),
                  )),
              Positioned(
                top: 20,
                left: 120,
                child: buildIcon('images/quick_request.png', '수업요청하기', null),
              ),
              Positioned(
                top: 20,
                right: 120,
                child: buildIcon(
                    'images/quick_response.png', '응답한멘토보기', ReceivedEstimate()),
              ),
              Positioned(
                bottom: 50,
                left: 120,
                child: buildIcon('images/quick_chat.png', '채팅보기', ChatList()),
              ),
              Positioned(
                bottom: 50,
                right: 125,
                child: buildIcon('images/quick_community.png', '커뮤니티', null),
              ),
              // Add more child widgets within the Stack as needed
            ],
          ),
        );
      },
      backgroundColor: Colors.transparent, // 앱 <=> 모달의 여백 부분을 투명하게 처리
    );
  }

  Widget buildIcon(String path, String title, Widget? widget) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 40,
          child: IconButton(
              onPressed: () {
                if (widget != null) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => widget));
                }
              },
              icon: Image.asset(path)),
        ),
        SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(fontSize: 10, color: Colors.white),
        )
      ],
    );
  }

  bottomeNavigationBarItem(int itemIndex, String iconUrl, String title) {
    iconColor(int currentIndex) {
      if (currentIndex == _selectedIndex) {
        return const ColorFilter.mode(Colors.blueAccent, BlendMode.srcIn);
      }
      return const ColorFilter.mode(Colors.grey, BlendMode.srcIn);
    }

    return BottomNavigationBarItem(
      icon: ColorFiltered(
        colorFilter: iconColor(itemIndex),
        child: SizedBox(width: 24.0, height: 24.0, child: Image.asset(iconUrl)),
      ),
      label: title,
    );
  }
}