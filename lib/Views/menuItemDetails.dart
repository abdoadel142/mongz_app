import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mongz_app/NetworkHandler.dart';
import 'package:mongz_app/Views/Cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class menuItemDetails extends StatefulWidget {
  final String name;
  final String type;
  final String imageUrl;
  final String description;
  final double price;
  final String menuId;
  final String itemId;
  menuItemDetails(
      { this.name,
        this.type,
        this.imageUrl,
        this.description,
        this.price,
        this.menuId,
        this.itemId,
         });

  @override
  _menuItemDetailsState createState() => _menuItemDetailsState(
      name:this.name,
      type:this.type,
      imageUrl:this.imageUrl,
      description:this.description,
    price: this.price,
    menuId: this.menuId,
    itemId: this.itemId

  );

}

class _menuItemDetailsState extends State<menuItemDetails> {
  final String name;
  final String type;
  final String imageUrl;
  final String description;
  final double price;
  final String menuId;
  final String itemId;
  NetworkHandler networkHandler = NetworkHandler();


  _menuItemDetailsState({this.name,
    this.type,
    this.imageUrl,
    this.description,
    this.price,
    this.itemId,
    this.menuId
});
 int count=1;
 double newPrice=0;
 double p=0;
  String userId;
  @override
  void initState() {
getUserId();
p=price;
newPrice=price;
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

  int _currVal = 0;


  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation:FloatingActionButtonLocation.centerFloat ,

        floatingActionButton: FloatingActionButton.extended(
          onPressed: ()async{
            Map<String, String> data = {
              "menuId": menuId,
              "itemId": itemId,
              "userId":userId,
            };
            var response = await networkHandler.post("/admin/addCart", data);
            print(response.body);
            Navigator.pushNamed(context, Cart.id);
          },
          backgroundColor: Colors.deepOrange,
          label: Container(
            width: MediaQuery.of(context).size.width/1.2 ,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("EGP "+ newPrice.toString(),style: TextStyle(color: Colors.white),),
              Text("Add to basket",style: TextStyle(color: Colors.white),)
            ],
          )
          ),
          
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading:IconButton(
                icon: Icon(Icons.arrow_back_outlined,color: Colors.black,),
                onPressed: ()=> Navigator.pop(context),
              ),
              pinned: true,
              title: Text(name),
              centerTitle: true,
              expandedHeight: MediaQuery.of(context).size.height/3,
              backgroundColor: Colors.white,
              //snap: true,
              flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  centerTitle: true,
                  background: Image(
                    image: AssetImage("images/food2.png"),
                  )
              ),
              stretch: true,
              primary: true,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                  [
                    Column(children: [
                    ListTile(
                      title:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19.0),),
                            ],
                          ),
                          SizedBox(height: 3,),
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
                              IconButton(icon: Icon(Icons.remove_circle_outline), onPressed: (){
                                setState(() {
                                  count >1? count--: count ;
                                  newPrice!=price? newPrice=newPrice-price : newPrice;
                                });
                              }),
                              Text(count.toString()),
                              IconButton(icon: Icon(Icons.add_circle_outline), onPressed: (){
                                setState(() {
                                  count++ ;
                                  newPrice= newPrice+price;
                                });
                              }),
                            ],
                          ),
                          Text("EGP "+newPrice.toString())
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration:  BoxDecoration(
                          shape: BoxShape.rectangle,
                          border:  Border.all(

                            color: Colors.grey[300],
                            width: 1.0,
                          ),

                        ),
                        child: Column(
                          children: [
                               RadioListTile(
                            title: Text("Small"),
                            groupValue: _currVal,
                            toggleable: true,
                            secondary: Text(p.toString()+" EGP"),
                            value: 1,
                            onChanged: (val) {
                              setState(() {
                                _currVal=val;


                              });
                            },
                          ),   RadioListTile(
                            title: Text("Medium"),
                            groupValue: _currVal,
                            toggleable: true,
                            secondary: Text((p*2).toString()+" EGP"),
                            value:2,
                            onChanged: (val) {
                              setState(() {
                                _currVal=val;

                              });
                            },
                          ),   RadioListTile(
                            title: Text("Large"),
                            groupValue: _currVal,
                            toggleable: true,
                            secondary: Text((p*3).toString()+" EGP"),
                            value:3,
                            onChanged: (val) {
                              setState(() {
                                _currVal=val;


                              });
                            },
                          ),
                             ]

                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("Add a Note ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                              Text("(optional)")
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
                                hintText: 'Anything else we need to know?',
                                icon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.speaker_notes_outlined,),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                            )
                        ],
                      ),
                    ),
                    ],),
                  ]
              ),
            )
          ],
        ),
      ),
    );
  }
}
