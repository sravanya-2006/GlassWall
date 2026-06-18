import 'package:flutter/material.dart';

class Screen3 extends StatefulWidget {
  const Screen3({super.key});

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  var selected =1;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Center(
        child: Column(
          children: [
            SegmentedButton(segments: [
              ButtonSegment(value: 1,label: Text("Text")),
              ButtonSegment(value:2,label: Text("File"))
            ], selected: {selected},
            onSelectionChanged: (p0) => {
              setState(() {
                selected = p0.first;
              })
            },
            
            )
          ],
        ),
      ),
    );
  }
}