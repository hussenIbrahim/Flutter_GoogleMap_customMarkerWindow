import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChnageOffSetProvider with ChangeNotifier {
  ScreenCoordinate screenCoordinate;

  double offsetY = 0.0;
  double offsetX = 0.0;
  changePostion(BuildContext context, double height, double width,
      ScreenCoordinate screenCoordinate) async {
    var devicePixelRatio =
        Platform.isAndroid ? MediaQuery.of(context).devicePixelRatio : 1.0;

    offsetY = (screenCoordinate?.y?.toDouble() ?? 0) / devicePixelRatio -
        (height + 45);
    offsetX = (screenCoordinate?.x?.toDouble() ?? 0) / devicePixelRatio -
        ((width / 2));
    notifyListeners();
  }
}

class ShowHideWindowProvider with ChangeNotifier {
  bool show = false;
  reverseshowChange() {
    show = !show;
    notifyListeners();
  }

  showChange() {
    show = true;
    notifyListeners();
  }
}
