import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

class CustomProgressBar extends StatelessWidget {
  final double progress;
  const CustomProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 115*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width),
      height: 115*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width),
      alignment: Alignment.center,
      child: LiquidCircularProgressIndicator(
        value: progress > 1 ? 1 : progress, // Defaults to 0.5.
        valueColor: AlwaysStoppedAnimation(Color(0xFF5D6EFF)), // Defaults to the current Theme's accentColor.
        backgroundColor: Color(0xFFE4E4E4), // Defaults to the current Theme's backgroundColor.
        borderColor: Colors.white,
        borderWidth: 0,
        direction: Axis.vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
        center: Text("${(progress*100).toInt()}%",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width),
          )
        ),
      )
    );
  }
}
