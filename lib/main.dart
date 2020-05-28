import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:test_google_map/infoWindow.dart';
import 'package:test_google_map/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (_) => ChnageOffSetProvider(),
          create: (_) => ChnageOffSetProvider(),
        ),
        ChangeNotifierProvider(
          builder: (_) => ShowHideWindowProvider(),
          create: (_) => ShowHideWindowProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Custom Marker InfoWindow',
        home: MapSample(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

var bloc;

class MapSampleState extends State<MapSample> {
  GoogleMapController _mapController;
  List<Marker> markers = [
    new Marker(
        icon: BitmapDescriptor.defaultMarker,
        markerId: MarkerId("id"),
        position: LatLng(36.759608, 43.486447),
        onTap: () {})
  ];
  @override
  void initState() {
    super.initState();
  }

  Orientation _orientation = Orientation.portrait;
  @override
  void dispose() {
    super.dispose();
  }

  Window window = Window(
    height: 100.0,
    width: 250.0,
    child: Column(
      children: [
        Text("Row"),
        Text("Row"),
        Text("Row"),
        Text("Row"),
      ],
    ),
  );
  LatLng currentLatLng = LatLng(0.0, 0.0);
  LatLng previousLatLng = LatLng(0.0, 0.0);

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<ChnageOffSetProvider>(context);
    final blocSHow = Provider.of<ShowHideWindowProvider>(context);

    return Scaffold(body: OrientationBuilder(builder: (context, orientation) {
      if (orientation != _orientation) {
        _onChange(true);

        _orientation = orientation;
      }
      return Stack(
        children: <Widget>[
          Positioned.fill(
            child: GoogleMap(
              onTap: (latlng) {
                previousLatLng = currentLatLng;
                currentLatLng = latlng;
                _goToTarget(latlng);
                Marker marker;
                marker = new Marker(
                    icon: BitmapDescriptor.defaultMarker,
                    markerId: MarkerId("$latlng"),
                    position: latlng,
                    onTap: () {
                      previousLatLng = currentLatLng;
                      currentLatLng = marker.position;
                      if (currentLatLng == previousLatLng) {
                        blocSHow.reverseshowChange();
                      } else {
                        blocSHow.showChange();
                        _onChange(false);
                      }
                    });
                markers.add(marker);
                _onChange(false);

                blocSHow.showChange();
              },
              onCameraMove: (p) {
                _onChange(false);
              },
              initialCameraPosition: CameraPosition(
                target: const LatLng(36.759608, 43.486447),
                zoom: 10,
              ),
              markers: markers.toSet(),
              onMapCreated: (mapController) {
                _mapController = mapController;
              },
            ),
          ),
          blocSHow.show ? window : Container()
        ],
      );
    }));
  }

  _onChange(bool orientationChanged) async {
    ScreenCoordinate res;
    if (orientationChanged) {
      Future.delayed(const Duration(milliseconds: 250)).then((value) async {
        res = await _mapController.getScreenCoordinate(currentLatLng);
        bloc.changePostion(context, window.height, window.width, res);
      });
    } else {
      res = await _mapController.getScreenCoordinate(currentLatLng);
      bloc.changePostion(context, window.height, window.width, res);
    }
  }

  Future<void> _goToTarget(LatLng latlng) async {
    final CameraPosition _kLake =
        CameraPosition(target: latlng, zoom: 15.151926040649414);
    await _mapController.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
