import 'package:ecommerce/Widget.dart';
import 'package:ecommerce/constants.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/provider/cart_item.dart';
import 'package:ecommerce/screens/User_Screens/Product_Info_Screen.dart';
import 'package:ecommerce/services/store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  static String id = "CartScreen";

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  Store _store = Store();


  showCustomDialog(List<Products> products, context) async {
    var price = getTotalPrice(products);
    var address;
    AlertDialog alertDialog = AlertDialog(
      actions: [
        MaterialButton(
          color: kBackgroundColor1,
          shape: OutlineInputBorder(
            borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(30)),
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            try{
              _store.storeOrders({
                kAddress : address,
                kTotalPrice : price,

              }, products);
              
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Orderd Successfully")));
              Navigator.pop(context);
            }
            catch(ex){
              print("Error $ex");
            }
            
          },
          child: Text(
            "Confirm",
            style: TextStyle(
              color: Colors.white,
                fontFamily: kFamilyFont,
                fontWeight: FontWeight.bold,
                fontSize: 17),
          ),
        )
      ],
      elevation: 5,
      scrollable: true,
      shape: OutlineInputBorder(
          borderSide: BorderSide.none, borderRadius: BorderRadius.circular(40)),
      title: Row(
        children: [
          Icon(
            Icons.shopping_bag,
            size: 30,
            color: kBackgroundColor1,
          ),
          Text(
            "BuyIt",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: kFamilyFont),
          )
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Total Price = $price\$"),
          TextField(
            onChanged: (value){
              address = value;
            },
            decoration: InputDecoration(hintText: 'Enter Your Address'),
          )
        ],
      ),
    );
    await showDialog(
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }

  getTotalPrice(List<Products> products) {
    var price = 0;
    for (var product in products) {
      price += product.pCount! * int.parse(product.pPrice);
    }
    return price;
  }

  Widget build(BuildContext context) {
    List<Products> products = Provider.of<CartItem>(context).product;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor1,
        title: Text(
          "My Cart",
          style: TextStyle(
              fontSize: 30,
              fontFamily: kFamilyFont,
              fontWeight: FontWeight.bold,
              color: Colors.grey),
        ),
      ),
      body: products.isEmpty
          ? Center(
              child: Image(image: AssetImage('tools/images/cart_is_empty.png')))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                InkWell(
                                  onTapUp: (details) async {
                                    double dxL = details.globalPosition.dx;
                                    double dyT = details.globalPosition.dy;
                                    double dxR =
                                        MediaQuery.of(context).size.width - dxL;
                                    double dyB =
                                        MediaQuery.of(context).size.width - dyT;
                                    showMenu(
                                        context: context,
                                        position: RelativeRect.fromLTRB(
                                            dxL, dyT, dxR, dyB),
                                        items: [
                                          MyPopUpMenuItem(
                                            onClick: () {
                                              Navigator.pop(context);
                                              Navigator.pushNamed(
                                                  context, ProductInfo.id,
                                                  arguments: products[index]);
                                              Provider.of<CartItem>(context,
                                                      listen: false)
                                                  .deleteProduct(
                                                      products[index]);
                                            },
                                            child: Text("Edit"),
                                          ),
                                          MyPopUpMenuItem(
                                              onClick: () {
                                                Navigator.pop(context);
                                                Provider.of<CartItem>(context,
                                                        listen: false)
                                                    .deleteProduct(
                                                        products[index]);
                                              },
                                              child: Text("Delete"))
                                        ]);
                                  },
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    decoration: BoxDecoration(
                                        color: kBackgroundColor1,
                                        borderRadius: BorderRadius.circular(40),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 25,
                                              offset: Offset(0, 15),
                                              color: Colors.black38)
                                        ]),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: Image(
                                                  image: AssetImage(
                                                      products[index]
                                                          .pLocation))
                                              .image,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                products[index].pName,
                                                style: TextStyle(
                                                    fontFamily: kFamilyFont,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    color: Colors.grey),
                                              ),
                                              Text(
                                                '\$${products[index].pPrice} USD',
                                                style: TextStyle(
                                                    fontFamily: kFamilyFont,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17,
                                                    color: Colors.cyanAccent),
                                              )
                                            ],
                                          ),
                                        ),
                                        Text(
                                          'Pieces: ${products[index].pCount}',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: kFamilyFont,
                                              color: Colors.greenAccent),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                ),
                MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  color: Colors.red[900],
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none),
                  onPressed: () {
                    showCustomDialog(products, context);
                  },
                  child: Text(
                    "Orders",
                    style: TextStyle(
                      fontFamily: kFamilyFont,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
