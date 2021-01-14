import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mongz_app/Models/offerslidermodel.dart';
import 'package:mongz_app/Views/Cart.dart';
import 'package:mongz_app/Views/Splash_Screen.dart';
import 'package:mongz_app/Views/Places.dart';
import 'package:mongz_app/Views/map_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mongz_app/Views/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';

class firstPage extends StatefulWidget {
  static const id = 'first';
  @override
  _firstPageState createState() => _firstPageState();
}

class _firstPageState extends State<firstPage> {
  Position _currentPosition;
  String _currentAddress;
  Future<Position> current_position;
  var enabled=true;
  var offersSlider = [
    OfferSliderItem(
        "https://images.unsplash.com/photo-1432139555190-58524dae6a55?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MTF8fHxlbnwwfHx8&auto=format&fit=crop&w=500&q=60",
        "Italian Sandwhich",
        "Italian Restaurant"),
    OfferSliderItem(
        "https://images.unsplash.com/photo-1506354666786-959d6d497f1a?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MTh8fHxlbnwwfHx8&auto=format&fit=crop&w=500&q=60",
        "Pizza",
        "DuBuque - Fahey"),
    OfferSliderItem(
        "https://images.pexels.com/photos/1600711/pexels-photo-1600711.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
        "Sandwich",
        "Bogan Group"),
  ];

  @override
  void initState() {
    super.initState();
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
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}, ${place.street} > ";
      });
    } catch (e) {
      print(e);
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          //  iconTheme: IconThemeData(color: Colors.grey),
          actions: <Widget>[
            Icon(
              Icons.search,
              size: 30,
            ),
            SizedBox(
              width: 10,
            ),
          ],
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
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
//            DrawerHeader(
//              child: Text(
//                'Mongz',
//                style: TextStyle(
//                    color: Colors.white, letterSpacing: 6, fontSize: 20),
//              ),
//              decoration: BoxDecoration(
//                color: Colors.orange,
//              ),
//            ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Text(
                    "A",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                title: Text("Abdelrhman Adel"),
                subtitle: Text("Egypt"),
                trailing: Icon(Icons.settings),
                onTap: () {},
              ),
              Divider(
                height: 10,
              ),
              ListTile(
                title: Text('Home'),
                trailing: Icon(Icons.home),
                onTap: () {},
              ),
              Divider(
                height: 10,
              ),
              ListTile(
                title: Text('Profile'),
                trailing: Icon(Icons.person),
                onTap: () {
                  Navigator.pushNamed(context, ProfilePage.id);
                },
              ),
              Divider(
                height: 10,
              ),
              ListTile(
                title: Text('Your Orders'),
                trailing: Icon(Icons.fastfood),
                onTap: () {
                  Navigator.pushNamed(context, Cart.id);

                },
              ),
              Divider(
                height: 10,
              ),

              ListTile(
                title: Text('Offers'),
                trailing: Icon(Icons.loyalty),
                onTap: () {},
              ),
              Divider(
                height: 10,
              ),
              ListTile(
                title: Text('Notifications'),
                trailing: Icon(Icons.notifications),
                onTap: () {},
              ),
              Divider(
                height: 10,
              ),
              ListTile(
                title: Text('About'),
                trailing: Icon(Icons.error_outline),
                onTap: () {},
              ),
        Divider(
        height: 10,
      ),
              ListTile(
                title: Text('Logout'),
                trailing: Icon(Icons.logout,color: Colors.red,),
                onTap: () async{
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  Navigator.pushReplacementNamed(context, Splash.id);
                },
              )
            ],
          ),
        ),
        // backgroundColor: Theme.of(context).backgroundColor,
        key: _scaffoldKey,
        extendBody: true,
        body:enabled?
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
            :SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            //scrollDirection: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "What would you like to order ? ",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: ListView(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, Places.id);
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.deepOrange,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              child: FadeInImage(
                                placeholder: AssetImage("images/food2.png"),
                                image: AssetImage("images/food2.png"),
                                fit: BoxFit.contain,
                                width: MediaQuery.of(context).size.width * 0.4,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                alignment: Alignment.center,
                                fadeInDuration: Duration(milliseconds: 200),
                                fadeInCurve: Curves.linear,
                              ),
                            ),
                            Positioned(
                              bottom: 10.0,
                              left: 10.0,
                              child: Container(
                                  child: Text(
                                'food',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.green,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            child: FadeInImage(
                              placeholder: AssetImage("images/green2.png"),
                              image: AssetImage("images/green2.png"),
                              fit: BoxFit.contain,
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.2,
                              alignment: Alignment.center,
                              fadeInDuration: Duration(milliseconds: 200),
                              fadeInCurve: Curves.linear,
                            ),
                          ),
                          Positioned(
                            bottom: 10.0,
                            left: 10.0,
                            child: Container(
                                child: Text('Groceries',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold))),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.blue,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            child: FadeInImage(
                              placeholder: AssetImage("images/d.png"),
                              image: AssetImage("images/d.png"),
                              fit: BoxFit.contain,
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.2,
                              alignment: Alignment.center,
                              fadeInDuration: Duration(milliseconds: 200),
                              fadeInCurve: Curves.linear,
                            ),
                          ),
                          Positioned(
                            bottom: 10.0,
                            left: 10.0,
                            child: Container(
                                child: Text(
                              'Pharmacy',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  Icon(Icons.local_offer_outlined,color: Colors.deepOrange,)
                  ,Text(
                  " Offers",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                ],)
              ),
              _buildOffersSlider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                Row(children: [
                  Icon(Icons.local_offer_outlined ,color: Colors.deepOrange,),
                  Text(
                  " Special Offers",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                ],)

              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: ListTile(
                        title: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: FadeInImage.memoryNetwork(
                            width: MediaQuery.of(context).size.width,
                            height: 150,
                            fit: BoxFit.cover,
                            placeholder: kTransparentImage,
                            image:"https://i.dietdoctor.com/wp-content/uploads/2018/06/DD_keto-meals_feat.jpg?auto=compress%2Cformat&w=1500&h=844&fit=crop",

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
                                    "chicken offer",
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
                              Text("50% off "),
                              Row(
                                children: [
                                  Icon(Icons.tag_faces_outlined,size: 17.0,color: Colors.grey,),
                                  Text(" very good . delevery free"),
                                //  Text(". rate : "+ rate.toString()),
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: ListTile(
                        title: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: FadeInImage.memoryNetwork(
                            width: MediaQuery.of(context).size.width,
                            height: 150,
                            fit: BoxFit.cover,
                            placeholder: kTransparentImage,
                            image:"https://www.biggerbolderbaking.com/wp-content/uploads/2019/07/15-Minute-Pizza-WS-Thumbnail-500x375.png",

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
                                    "pizza offer",
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
                              Text("50% off "),
                              Row(
                                children: [
                                  Icon(Icons.tag_faces_outlined,size: 17.0,color: Colors.grey,),
                                  Text(" very good . delevery free"),
                                //  Text(". rate : "+ rate.toString()),
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: ListTile(
                        title: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: FadeInImage.memoryNetwork(
                            width: MediaQuery.of(context).size.width,
                            height: 150,
                            fit: BoxFit.cover,
                            placeholder: kTransparentImage,
                            image:"https://s2.best-wallpaper.net/wallpaper/3840x2160/1705/Chocolate-cake-and-cherries-delicious-food_3840x2160.jpg",

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
                                    "cake offer",
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
                              Text("50% off "),
                              Row(
                                children: [
                                  Icon(Icons.tag_faces_outlined,size: 17.0,color: Colors.grey,),
                                  Text(" very good . delevery free"),
                                //  Text(". rate : "+ rate.toString()),
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: ListTile(
                        title: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: FadeInImage.memoryNetwork(
                            width: MediaQuery.of(context).size.width,
                            height: 150,
                            fit: BoxFit.cover,
                            placeholder: kTransparentImage,
                            image:"https://images.pexels.com/photos/1600711/pexels-photo-1600711.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",

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
                                    "Sandwich",
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
                              Text("50% off "),
                              Row(
                                children: [
                                  Icon(Icons.tag_faces_outlined,size: 17.0,color: Colors.grey,),
                                  Text(" very good . delevery free"),
                                //  Text(". rate : "+ rate.toString()),
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
              ),

              Padding(
                padding: const EdgeInsets.all(11.0),
                child: Container(
                    height: 50.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.deepOrange),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Places.id);
                      },
                      child: Text(
                        "View All Resturant",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15.0,color: Colors.white),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOffersSlider() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
      items: offersSlider.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FadeInImage(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      fit: BoxFit.cover,
                      placeholder: AssetImage("images/food2.png"),
                      image: NetworkImage(i.image),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      i.itemName,
                      style: TextStyle(color: Colors.white),
                    ),
                    margin: EdgeInsets.all(10),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
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
}
