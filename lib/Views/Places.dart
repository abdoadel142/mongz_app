import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:mongz_app/NetworkHandler.dart';
import 'package:mongz_app/Services/locationServices.dart';
import 'package:mongz_app/Views/Place.dart';
import 'package:mongz_app/Views/map_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shimmer/shimmer.dart';
class Places extends StatefulWidget {
  static const id = 'places';
  @override
  _PlacesState createState() => _PlacesState();
}

class _PlacesState extends State<Places> {
  Position _currentPosition;
  String _currentAddress;
  LocationServices locationServices = new LocationServices();
  NetworkHandler networkHandler = NetworkHandler();
  bool enabled = true;
  //Future<Position> current_position;
  @override
  void initState() {
    super.initState();
    getPlaces();
    _getCurrentLocation();

  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
      setState(() {
        enabled=false;
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    _currentAddress =
        await locationServices.getAddressFromLatLng(_currentPosition);
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  getPlaces()async{
  var response = await networkHandler.get("/admin/places");
  List<PlacesItem> placeItems = [];

  response["restaurant"].forEach((doc){
    placeItems.add(PlacesItem.fromJson(doc));
 print(response["restaurant"][2]["imageUrl"]);
    print('000000000000000000000000000000');

  });

 return placeItems;

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
                  'Choose delivery location',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text('Your Location'),
                subtitle: _currentAddress == null
                    ? Text("egypt street")
                    : Text(_currentAddress),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.location_searching),
                title: Text('Delever to current location'),
                subtitle: Text("Enable device location"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.mapPin),
                title: Text('Delever to different location'),
                subtitle: Text("Choose location on the map"),
                onTap: () {
                  Navigator.pop(context);
                  //    Navigator.pushNamed(context, map_screen.id);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => map_screen(
                        position: _currentPosition,
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: Container(

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width/3.1,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[200]),
                    ),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.menu_outlined,color: Colors.black,
                          ),
                          tooltip: "filter",
                        ),
                        Text(
                          "filter",
                         // style: TextStyle(fontSize: 20, color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width/3,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[200]),
                    ),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.restaurant,color: Colors.black,),
                          tooltip: "Cuisiens",
                        ),
                        Text(
                          "Chisiens",
                         // style: TextStyle(fontSize: 20, color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width/3,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[200]),
                    ),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.search_rounded,color: Colors.black,
                          ),
                          tooltip: "Search",
                        ),
                        Text(
                          "Search",
                         // style: TextStyle(fontSize: 20, color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              height: 50,
            ),
          ),
          backgroundColor: Colors.white,
          //  iconTheme: IconThemeData(color: Colors.grey),

          title: GestureDetector(
            onTap: _modalBottomSheetMenu,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Delivering to",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                Text(
                  _currentAddress == null ? "" : _currentAddress,
                  style: TextStyle(color: Colors.deepOrange, fontSize: 14),
                )
              ],
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_outlined),
            onPressed: ()=> Navigator.pop(context),
          ),
        ),

        // backgroundColor: Theme.of(context).backgroundColor,
        key: _scaffoldKey,
        extendBody: true,
        body: enabled?
        Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey,
          enabled: true,
          child:ListView.builder(
              itemCount: 10,
              itemBuilder: (context,index){
                return ListTile(
                    title: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: Colors.black,
                        width: MediaQuery.of(context).size.width,
                        height: 150,

                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: Colors.grey[900],
                            height: 10.0,
                          ),
                        ),Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: Colors.grey[900],
                            height: 10.0,
                          ),
                        ),
                      ],
                    ));
              }),
        )
        : SingleChildScrollView(
          child: Column(
          mainAxisSize: MainAxisSize.min,
          //scrollDirection: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.13,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index){
                  return  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: Colors.indigo[100],
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          child: FadeInImage(
                            placeholder: AssetImage("images/sale.png"),
                            image: AssetImage("images/sale.png"),
                            fit: BoxFit.contain,
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.height * 0.1,
                            alignment: Alignment.center,
                            fadeInDuration: Duration(milliseconds: 200),
                            fadeInCurve: Curves.linear,
                          ),
                        ),
                        Positioned(
                          bottom: 10.0,
                          left: 10.0,
                          child: Text(
                            '50% Offers',
                            style: TextStyle(
                                fontSize: 12,),
                          ),
                        ),
                      ],
                    ),
                  );
                })
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "All restaurants ",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),

            FutureBuilder(
              future: getPlaces(),
              builder: (context,snapshot){
                if (!snapshot.hasData) {
                  return Text("");
                }
                return Column(
                  children: snapshot.data,
                );

              },
            ),

          ],
        ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////

class PlacesItem extends StatelessWidget {
  final String name;
  final String id;
  final String type;
  final  imageUrl;
  final String description;
  final String address;
  final String openingHours;
  final  location;
final int rate;
  PlacesItem({
    this.name,
    this.id,
    this.type,
    this.imageUrl,
    this.description,
    this.address,
    this.openingHours,
    this.location,
    this.rate
  });

  factory PlacesItem.fromJson(Map<String, dynamic> response) {
    return PlacesItem(
      name: response['name'],
      id: response['_id'],
      description: response['description'],
      address: response['address'],
      openingHours: response['openingHours'],
      imageUrl: response['imageUrl'],
     // location: response["location"],
     rate: response["rate"],
    );
  }

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: EdgeInsets.only(bottom: 20.0),
        child: GestureDetector(
          onTap: () => {
          Navigator.push(
          context,
          MaterialPageRoute(
          builder: (context) => Place( name: name,rate: rate,type: type, description: description,menuId: id,)
          ),
          )

            },
          child: Column(
            children: <Widget>[
              Container(
                child: ListTile(
                  leading: Image.memory(base64Decode(imageUrl)),
                ),
              ),
              Container(
                child: ListTile(
                    title: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: FadeInImage(
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        fit: BoxFit.cover,
                        placeholder: AssetImage("images/food2.png"),
                        image:
                        NetworkImage(
                            "https://images.unsplash.com/photo-1460306855393-0410f61241c7?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MjJ8fHxlbnwwfHx8&auto=format&fit=crop&w=500&q=60"
                        ),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0,),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text(
                               name,
                               style: TextStyle(
                                   fontSize: 16.0,
                                   color: Colors.black,
                                   fontWeight: FontWeight.bold),
                             ),
                             Row(
                               children: [
                               Icon(Icons.directions_bike,size: 17.0,)
                                 ,  Text(" Within 35 mins",
                                 style:TextStyle(
                                     fontSize: 14.0,
                                     color: Colors.black,
                                     )
                                   ,)

                               ],
                             )
                           ],
                         ),
                          Text(description),
                         Row(
                           children: [
                             Icon(Icons.tag_faces_outlined,size: 17.0,color: Colors.grey,),
                             Text(" very good . delevery free"),
                             Text(". rate : "+ rate.toString()),
                           ],
                         ),
                          Row(
                            children: [
                              Text(
                                "Special deals  ",
                                style: TextStyle(
                                  color: Colors.pink,
                                ),
                              ),
                              Text(".  Live tracking"),
                            ],
                          )



                        ],
                      ),
                    ),


                ),
              ),
              //Divider(thickness: 2,)
            ],
          ),
        ));
  }
}
