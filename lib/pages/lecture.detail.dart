import 'package:eduMap/models/lecture.dart';
import 'package:flutter/material.dart';

class LectureDetail extends StatelessWidget {
  final Lecture curriculum;
  const LectureDetail({Key? key, required this.curriculum}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Curriculum Detail'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var entry in curriculum.toJson().entries)
                if (entry.key == 'streetViewUrl')
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: Image.network(
                      entry.value.toString(),
                      fit: BoxFit.cover,
                    ),
                  )
                else if (entry.key != 'lat' && entry.key != 'lng')
                  ListTile(
                    title: Text(entry.key),
                    subtitle: Text(entry.value.toString()),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
