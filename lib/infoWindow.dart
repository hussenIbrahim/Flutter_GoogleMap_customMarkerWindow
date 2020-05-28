

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_google_map/provider.dart';

class Window extends StatefulWidget {
  final height;
  final width;
  final child;
  Window({Key key, this.height, this.width, this.child}) : super(key: key);

  @override
  _WindowState createState() => _WindowState();
}

class _WindowState extends State<Window> {
  

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<ChnageOffSetProvider>(context);

    return Positioned(
        top: bloc.offsetY,
        left: bloc.offsetX,
        child: ClipPath(
          clipper: MyCustomClipper(),
          child: Container(
              padding: EdgeInsets.only(bottom: 25),
              color: Colors.grey,
              height: widget.height,
              width: widget.width,
              child: Container(
                  child: Center(
                child: widget.child,
              ))),
        ));
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;

    final path = Path();
    path.lineTo(0.0, size.height - 30);

    path.quadraticBezierTo(0.0, size.height - 25, 5.0, size.height - 25);
    path.lineTo(size.width - 5.0, size.height - 25);

    path.lineTo((width / 2) - 15, height - 25);
    path.lineTo((width / 2), height);
    path.lineTo((width / 2) + 15, height - 25);
    path.lineTo(width - 5, height - 25);

    path.quadraticBezierTo(
        size.width, size.height - 25, size.width, size.height - 30);

    path.lineTo(size.width, 5.0);
    path.quadraticBezierTo(size.width, 0.0, size.width - 5.0, 0.0);
    path.lineTo(5.0, 0.0);
    path.quadraticBezierTo(0.0, 0.0, 0.0, 5.0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
