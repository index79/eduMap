import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Spinner extends StatelessWidget {
  final String? color;

  const Spinner({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Column(
        children: [
          SpinKitCircle(
            itemBuilder: (BuildContext context, int index) {
              return const DecoratedBox(
                decoration:
                    BoxDecoration(color: Color.fromARGB(255, 125, 125, 125)),
              );
            },
          ),
          SizedBox(height: 10),
          Text('페이지 읽는 중',
              style: TextStyle(
                  color: color == null ? Colors.black45 : Colors.white))
        ],
      ),
    );
  }
}
