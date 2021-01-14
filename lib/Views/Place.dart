import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mongz_app/NetworkHandler.dart';
import 'package:mongz_app/Views/menuItemDetails.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';

class Place extends StatefulWidget {
  final String name;
  final String menuId;
  final String type;
  final String imageUrl;
  final String description;
  final int rate;
  static const id = 'place';
  Place(
      { this.name,
        this.menuId,
        this.type,
        this.imageUrl,
        this.description,
        this.rate });

@override
  _PlaceState createState() => _PlaceState(
    name:this.name,
    menuId:this.menuId,
    type:this.type,
    imageUrl:this.imageUrl,
    description:this.description,
    rate:this.rate
);

}

class _PlaceState extends State<Place> {
  final String name;
  final String menuId;
  final String type;
  final String imageUrl;
  final String description;
  final int rate;
  NetworkHandler networkHandler = NetworkHandler();


  _PlaceState({this.name,
    this.menuId,
    this.type,
    this.imageUrl,
    this.description,
    this.rate});

  @override
  void initState() {
    super.initState();
    getPlaces();
  }

  getPlaces()async{
    var response = await networkHandler.get("/admin/getMenu/"+menuId);
    List<MenuItem> placeItems = [];
    response["menu"]["items"].forEach((doc){
      placeItems.add(MenuItem.fromJson(doc,menuId));

    }
    );

    return placeItems;
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading:IconButton(
                icon: Icon(Icons.arrow_back_outlined,color: Colors.black,),
                onPressed: ()=> Navigator.pop(context),
              ),
              pinned: true,
             title: Text(name),
         //    centerTitle: true,
             // floating: true,
              actions: <Widget>[IconButton(
                  icon: Icon(
                    Icons.info,
                    color: Colors.black,
                  ),
                ),],
              expandedHeight: MediaQuery.of(context).size.height/1.5,
              backgroundColor: Colors.white,
              //snap: true,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(50.0),
                child:
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300])),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: Colors.orange,
                        ),
                      ),
                      Text(
                        "Most Selling",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("sandwtches",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("soup",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("salad",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  height: 50,
                )
              ),
              flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  centerTitle: true,
                  background: Column(
                    children: [
                          Image.network(
                            imageUrl
                      ),
                      ListTile(
                        title:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17.0),),
                                Text("info",style: TextStyle(color: Colors.deepOrange),),
                              ],
                            ),
                            Text(description,) ,
                          ],
                        ),
                      ),
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.tag_faces_outlined),
                                Text("  Good  "+rate.toString(),style: TextStyle(fontWeight: FontWeight.bold)),
                                Text("based on (154) ratings")

                              ],
                            ),
                            Text("review",style: TextStyle(color: Colors.deepOrange),),

                          ],
                        ),
                      ),
                      ListTile(
                        title: Row(
                       //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.directions_bike),
                            Text(" within 24 mins ",style: TextStyle(fontWeight: FontWeight.bold),),
                            Text("(EGP 15.00 delivery)")
                          ],
                        ),
                      ),
                      ListTile(
                        title: Row(
                       //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.credit_card_outlined,color: Colors.green,),
                            Text(" 40% off your 1st order with Mastercard",
                              style: TextStyle(color: Colors.pink,fontSize: 14,fontWeight: FontWeight.bold),),

                          ],
                        ),
                      ),

                    ],
                  )
              ),
              stretch: true,
              primary: true,
            ),
            SliverList(
           delegate: SliverChildListDelegate(
             [
               FutureBuilder(
                 future: getPlaces(),
                 builder: (context,snapshot){
                   if (!snapshot.hasData) {
                     return Shimmer.fromColors(
                       baseColor: Colors.grey[300],
                       highlightColor: Colors.grey,
                       enabled: true,
                       child:Container(
                         height: 150,
                         child: ListTile(
                             title: ClipRRect(
                               borderRadius: BorderRadius.circular(12),
                               child: Container(
                                 color: Colors.grey[600],
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
                                     color: Colors.grey[400],
                                     height: 10.0,
                                   ),
                                 ),Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: Container(
                                     color: Colors.grey[400],
                                     height: 10.0,
                                   ),
                                 ),
                               ],
                             )
                         ),
                       )
                     );
                   }
                   return Column(
                     children: snapshot.data,
                   );

                 },
               ),
             ]
           ),
            )
          ],
        ),
      ),
    );
  }
}


class MenuItem extends StatelessWidget {
  final String menuId;
  final String itemId;
  final String name;
  final String type;
  final String imageUrl;
  final String description;
  final double price;
  MenuItem({
    this.menuId,
    this.itemId,
    this.name,
    this.type,
    this.imageUrl,
    this.description,
    this.price,
  });

  factory MenuItem.fromJson(Map<String, dynamic> response, String menuid) {
    return MenuItem(
      itemId: response["_id"],
      name: response['name'],
      description: response['description'],
      price: response['price'],
    //  imageUrl: response['imageUrl'],
      type: response["type"],
      menuId: menuid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: ()=>{
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => menuItemDetails(name: name,
                  description: description,
                  type: type,
                  imageUrl: imageUrl,
                  price:price,
                menuId:menuId,
                itemId: itemId,
              )
          ),
        )
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(name,style: TextStyle(fontWeight: FontWeight.bold,),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(description),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(price.toString() +"EGP",style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            ],
          ),
          trailing:  ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: FadeInImage.memoryNetwork(
              width: MediaQuery.of(context).size.width/4,

              fit: BoxFit.contain,
              placeholder:kTransparentImage ,
              image: "https://img.favpng.com/7/14/0/lunch-computer-icons-dinner-restaurant-png-favpng-aM6jwD1uebMREQcC8s9j7YPiu.jpg",
            ),
          ),


        ),
      ),
    );

  }
}


