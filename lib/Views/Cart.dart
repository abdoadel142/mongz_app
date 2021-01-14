import 'package:flutter/material.dart';
import 'package:mongz_app/NetworkHandler.dart';
import 'package:mongz_app/Views/Places.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class Cart extends StatefulWidget {
static const id = 'cart';
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  String userId;

  NetworkHandler networkHandler = NetworkHandler();
bool fetched=false;
  List date=[];


  @override
  void initState() {
    getUserId();
    getCart();
    setState(() {
      fetched=true;
    });
    super.initState();
  }

  getUserId()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var Id= await prefs.get('id') ;
    setState(() {
      userId=Id;
      print(userId);
    });
  }

  getCart()async{
    var response = await networkHandler.get("/admin/getCart/"+userId);
    print(response);
int count=0;
    List total=[];
    List<CartItem> placeItems = [];
    response["items"].forEach((doc){
      placeItems.add(CartItem.fromJson(doc[0]["items"][0],response["quantities"][count]));
      count++;
    });


    return placeItems;

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
              tooltip: "Clear Cart",
              icon: Icon(Icons.remove_circle_outline,color: Colors.red,), onPressed: ()async{
          var response = await networkHandler.delete("/admin/clearCart/"+userId);
          Navigator.pushReplacementNamed(context, Cart.id);
        })
        ],
        backgroundColor: Colors.white,
        title:Column(
          children: [
            Text("Basket",style: TextStyle(fontWeight: FontWeight.bold),),
            Text("chicken(Tanta Egypt)",style: TextStyle(color: Colors.grey,fontSize: 14),),
        ],),


        leading: IconButton(icon: Icon(Icons.arrow_back_rounded),onPressed: ()=> Navigator.pop(context),),
        centerTitle: true,
        
      ),
      body: fetched?
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: getCart(),
              builder: (context,snapshot){
                if (!snapshot.hasData) {
                  return Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey,
                      enabled: true,
                      child:Container(
                        color: Colors.grey[500],
                        height: 110,
                        child: ListTile(
                            title: Container(
                              color: Colors.grey[500],
                              height: 50,
                            ),
                          subtitle:Container(
                            height: 50,
                          ) ,

                        ),
                      )
                  );
                }
                return Column(
                  children: snapshot.data,
                );

              },
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("Special request",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.speaker_notes_outlined,color: Colors.grey,),
                      Text("  Add a Note ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),

                    ],
                  ),
                  SizedBox(height: 3,),
                  Container(
                    decoration:  BoxDecoration(
                      shape: BoxShape.rectangle,
                      border:  Border.all(

                        color: Colors.grey[300],
                        width: 1.0,
                      ),

                    ),
                    child:  TextField(
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        hintText: '  Anything else we need to know?',

                        border: InputBorder.none,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("Payment Summary",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text("Subtotal"),
                       Text("EGP 120.00")
                     ],),
                 ),
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text("Service Charge"),
                       Text("EGP 0.00")],),
                 ),
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text("Total amount"),
                       Text("EGP 120.00")],),
                 )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                    Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: Container(
                          height: 50.0,
                          width: MediaQuery.of(context).size.width/2.5,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.deepOrange
                            ),
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white
                               ),
                          child: FlatButton(
                            onPressed: () {
                              Navigator.pushNamed(context, Places.id);
                            },
                            child: Text(
                              "Add items",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15.0,color: Colors.deepOrange),
                            ),
                          )),
                    ),
                Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: Container(
                          height: 50.0,
                          width: MediaQuery.of(context).size.width/2.5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.deepOrange),
                          child: FlatButton(
                            onPressed: () {
                              Navigator.pushNamed(context, Places.id);
                            },
                            child: Text(
                              "Checkout",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15.0,color: Colors.white),
                            ),
                          )),
                    ),

              ],
            )
          ],
        ),
      )

:      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 200,
            child: Image.asset("images/logol.png"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Hey, your basket is empty!",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Go on, stock up and order your faves.",style: TextStyle(color: Colors.grey,fontSize: 16),),
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
                    "Add items",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15.0,color: Colors.white),
                  ),
                )),
          ),

        ],

      ),
    );
  }
}
class CartItem extends StatelessWidget {
  final String itemId;
  final String name;
  final String type;
  final String description;
  final double price;
  final int quantity;
  CartItem({
    this.quantity,
    this.itemId,
    this.name,
    this.type,
    this.description,
    this.price,
  });

  factory CartItem.fromJson(Map<String, dynamic> response, quantity) {
    return CartItem(
      quantity: quantity,
      itemId: response["_id"],
      name: response['name'],
      description: response['description'],
      price: response['price'],
      type: response["type"],
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text("EGP"+price.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    IconButton(icon: Icon(Icons.remove,color: Colors.orange,),
                        onPressed: (){

                        }
                    ),
                    Text(quantity.toString()),
                    IconButton(icon: Icon(Icons.add,color: Colors.orange,), onPressed: (){

                    }),
                  ],
                ),
              ],
            ),

          ],
        ),

        trailing:  ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Icon(Icons.fastfood,size: 50,)
        ),


      ),
    );

  }
}
