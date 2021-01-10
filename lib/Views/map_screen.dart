import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mongz_app/Views/Home_Page.dart';

class map_screen extends StatefulWidget {
  final Position position;
  static const id = 'map';

  map_screen({this.position});

  @override
  _map_screenState createState() => _map_screenState(position);
}

class _map_screenState extends State<map_screen> {
  final Position myposition;
  bool found = false;

  _map_screenState(this.myposition);
  @override
  void initState() {
    super.initState();

    if (myposition != null) {
      found = true;
      getAddressFromLatLng(myposition);
      print(myposition.latitude);
    }
    myMarker.add(
      Marker(
        markerId: MarkerId("mymarker"),
        draggable: false,
        position: found
            ? LatLng(myposition.latitude, myposition.longitude)
            : LatLng(51.507351, -0.127758),
        flat: true,
      ),
    );
  }

  GoogleMapController mapController;
  List<Marker> myMarker = [];
  String searchAddr;
  String currentAddress;
  String currentAddress2;
  Future getAddressFromLatLng(_currentPosition) async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      currentAddress =
          "${place.locality}, ${place.postalCode}, ${place.country}";
      currentAddress2 = "${place.subLocality}, ${place.street}";
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        // backgroundColor: Colors.orange,
        body: Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height - 50.0,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            markers: Set.from(myMarker),
            onMapCreated: onMapCreated,
            initialCameraPosition: CameraPosition(
                target: found
                    ? LatLng(myposition.latitude, myposition.longitude)
                    : LatLng(51.507351, -0.127758),
                zoom: 10.0),
            mapType: MapType.normal,
            onTap: (cordinate) async {
              setState(() {
                myMarker.add(
                  Marker(
                    markerId: MarkerId(Random(100).toString()),
                    position: cordinate,
                    draggable: true,
                  ),
                );
              });
              // mapController.animateCamera(CameraUpdate.newLatLng(cordinate));
              await getAddressFromLatLng(cordinate);

              _modalBottomSheetMenu();
            },
          ),
        ),
        Positioned(
          top: 30.0,
          right: 15.0,
          left: 15.0,
          child: Container(
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0), color: Colors.white),
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Enter Address',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                  icon: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: searchandNavigate,
                      iconSize: 30.0)),
              onChanged: (val) {
                setState(() {
                  searchAddr = val;
                });
              },
            ),
          ),
        )
      ],
    ));
  }

  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
        ),
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Text(
                  'Delivery location',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.mapPin),
                title: Text(currentAddress),
                subtitle: Text(currentAddress2),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, firstPage.id);
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    height: 50.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.orange),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, firstPage.id);
                      },
                      child: Text(
                        "Delever Here",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15.0),
                      ),
                    )),
              ),
            ],
          );
        });
  }

  saveLocation() async {
    var url = "http://192.168.1.3:8080/login";

    final http.Response response = await http.post(
      url,
      // headers: {'Content-Type': 'application/json'},
      headers: {
        "Accept": "application/json",
        "Content-type": "application/json",
      },
      body: jsonEncode(<String, String>{
        "lat": myposition.latitude.toString(),
        "lon": myposition.longitude.toString(),
      }),
    );
    //status = response.statusCode;
    print(response.statusCode);
    if (response.statusCode == 422) {
      throw Exception('faild');
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      print(response.statusCode);
      throw Exception('something wrong happend');
    }
    if (response.statusCode == 200) {
      Navigator.pushReplacementNamed(context, firstPage.id);
    }
  }

  searchandNavigate() {
    locationFromAddress(searchAddr).then((result) {
      mapController.animateCamera(CameraUpdate.zoomOut());
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(result[0].latitude, result[0].longitude),
              zoom: 10.0),
        ),
      );
    });
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }
}
