import 'package:eduMap/pages/chat_list.dart';
import 'package:eduMap/pages/empty.dart';
import 'package:eduMap/pages/home.dart';
import 'package:eduMap/pages/login_page.dart';
import 'package:eduMap/pages/places_to_learn.dart';
import 'package:eduMap/pages/received_estimate.dart';
import 'package:eduMap/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    Future handleSignOut() async {
      authProvider.handleSignOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false,
      );
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: true,
          toolbarHeight: 90,
          title: Image.asset('images/logo.png', width: 150),
          actions: [
            IconButton(
                onPressed: () {
                  handleSignOut();
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.black45,
                  size: 30,
                )),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications_none_outlined,
                color: Colors.black45,
                size: 30,
              ),
            )
          ],
        ),
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
                bottomeNavigationBarItem(0, 'images/bottom_icon_home.png', '홈'),
                bottomeNavigationBarItem(
                    1, 'images/bottom_icon_center.png', '배움터'),
                bottomeNavigationBarItem(
                    2, 'images/bottom_studycenter.png', 'e'),
                bottomeNavigationBarItem(
                    3, 'images/bottom_icon_findmentor.png', '멘토찾기'),
                bottomeNavigationBarItem(
                    4, 'images/bottom_icon_library.png', '받은 견적'),
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
                  width: 70,
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
          child: Wrap(
            // child: Stack(
            //   alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: Colors.white),
              ),
              buildIcon('images/quick_request.png', '수업요청하기', null),
              buildIcon(
                  'images/quick_response.png', '응답한멘토보기', ReceivedEstimate()),
              buildIcon('images/quick_chat.png', '채팅보기', ChatList()),
              buildIcon('images/quick_community.png', '커뮤니티', null),
              // Add more child widgets within the Stack as needed
            ],
            //),
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
          height: 45,
          child: IconButton(
              onPressed: () {
                if (widget != null) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => widget));
                }
              },
              icon: Image.asset(path)),
        ),
        SizedBox(height: 2),
        Text(
          title,
          style: TextStyle(fontSize: 12, color: Colors.white),
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
