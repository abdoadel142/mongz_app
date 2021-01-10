import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
static const id = 'cart';
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:Text("Basket",style: TextStyle(fontWeight: FontWeight.bold),),


        leading: IconButton(icon: Icon(Icons.arrow_back_sharp),onPressed: ()=> Navigator.pop(context),),
        centerTitle: true,
        
      ),
      body: Container(

      ),
    );
  }
}
