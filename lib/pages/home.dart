import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Image.asset('images/logo.png', width: 150),
      bottom: PreferredSize(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(8)),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Explore',
                        border: InputBorder.none,
                        icon: Padding(
                          padding: EdgeInsets.only(left: 13),
                          child: Icon(
                            Icons.search,
                            color: Colors.blue,
                          ),
                        )),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.access_alarm_sharp,
                          color: Colors.black45,
                          size: 30,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.notifications_none_outlined,
                          color: Colors.black45,
                          size: 30,
                        ))
                  ],
                )
              ],
            ),
          ),
          preferredSize: Size.fromHeight(80)),
    ));
  }
}
