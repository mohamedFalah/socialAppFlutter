import 'package:flutter/material.dart';
import 'dart:math' as math; // import this

class Bar extends StatefulWidget {
  @override
  _Bar createState() => _Bar();
}

class _Bar extends State<Bar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: IconButton(
              icon: Icon(
                Icons.exit_to_app_rounded,
                size: 38,
                color: Colors.white,
              ),
              onPressed: null),
        ),
        Text('Feed'),
        IconButton(
            icon: Icon(
              Icons.account_circle_rounded,
              size: 38,
              color: Colors.white,
            ),
            onPressed: null),
      ],
    );
  }
}
