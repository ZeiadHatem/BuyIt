import 'dart:convert';

import 'package:ecommerce/Widget.dart';
import 'package:ecommerce/constants.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/provider/cart_item.dart';
import 'package:ecommerce/screens/User_Screens/Cart_Screen.dart';
import 'package:ecommerce/services/store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductInfo extends StatefulWidget {
  static String id = 'ProductInfo';

  @override
  State<ProductInfo> createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
   Store _store = Store();

   int count = 1;

  Widget build(BuildContext context) {
    final products = ModalRoute.of(context)?.settings.arguments as Products;

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
        child: Scaffold(
          backgroundColor: kBackgroundColor1,
          body: SingleChildScrollView(
            child: Container(
              //disgn the info product screen.
                height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    Container(
                      height: 400,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.tealAccent,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(200))),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.arrow_back_outlined)),
                              Text(
                                products.pName,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: kFamilyFont,
                                    fontWeight: FontWeight.bold),
                              ),
                              FloatingActionButton(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                child: Icon(
                                  CupertinoIcons.heart,
                                  color: Colors.black87,
                                ),
                                onPressed: () {},
                                shape: CircleBorder(
                                    side: BorderSide(
                                        color: Colors.black87, width: 3)),
                              )
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Image(
                              image: AssetImage(products.pLocation),
                              width: 250,
                              height: 250,
                            ),
                          ),
                          Text(
                            'Price:\$${products.pPrice}USD',
                            style: TextStyle(
                                fontFamily: kFamilyFont,
                                color: Colors.blue[900],
                                fontSize: 20),
                          )
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            products.pDescription,
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontFamily: kFamilyFont),
                          ),
                          IconButton(onPressed: (){/*we will meet soon 😁*/}, icon: Icon(Icons.share_rounded,color: Colors.white,))
                        ],
                      ),
                    ),

                    Row(
                      //To many pieces or for one piece as you like it`s just a count  😒😒
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(onPressed: (){
                              setState(() {
                                count++;
                              });
                            }, icon: Icon(Icons.add)),
                            Text(count.toString()),
                            IconButton(onPressed: (){
                              setState(() {
                                if(count>1){
                                  count--;
                                }
                              });
                            }, icon: Icon(Icons.remove)),
                          ],
                        ),

                        Row(
                          children: [
                            IconButton(
                              onPressed: (){Navigator.pushNamed(context, CartScreen.id);},
                              icon: Icon(Icons.shopping_cart_rounded , color: Colors.grey,),
                            )
                          ],
                        )
                      ],
                    ),

                    Column(
                      // that column to display all the related product of the same category.  
                      children: [
                        Text("Related App" , style: TextStyle(
                          fontSize: 30,
                          fontFamily: kFamilyFont,
                          color: Colors.greenAccent.shade700
                        ),),

                        SizedBox(height: 20,),

                        Container(
                          margin: EdgeInsets.all(10),
                          height: 220,
                          color: Colors.transparent,
                            child: StreamBuilder(
                              stream: _store.loadProduct(),
                               builder: (context,snapshot){
                                if(snapshot.hasData){
                                  List<Products> productList = [];
                                  for(var data in snapshot.data!.docs){
                                    final category = data.get(kProductCategory);
                                    final id = data.id;
                                    //this if condition for display all products without the product appear.  
                                    if(products.pCategory == category && products.pId!=id)
                                    productList.add(Products(
                                      pId: data.id,
                                      pName: data.get(kProductName),
                                      pLocation: data.get(kProductImageLocation),
                                      pPrice: data.get(kProductPrice)
                                    ));
                                  }
                                  return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: productList.length,
                                        itemBuilder: (context,index)=>AppsContainer(
                                          products: productList[index],
                                          itemIndex: index,
                                          id: products.pId,
                                        )
                                    );
                                }
                                else{
                                  return Center(child: CircularProgressIndicator(),);
                                }
                               },
                            ),
                        )
                      ],
                    ),

                    Spacer(),
                    ButtonTheme(
                        height: 50,
                        shape: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: MaterialButton(
                          color: Colors.red[900],
                          onPressed: () async{
                            CartItem cartItem = Provider.of<CartItem>(context , listen: false);
                            products.pCount = count;
                            bool exist = false;
                            var productInCart = cartItem.product;
                            for(var productInCart in productInCart){
                              if(productInCart.pId == products.pId){
                                exist = true;
                              }
                            }
                            if(exist){
                              //that condition is exist to don`t reapet the order again.
                              //if user want some he will choose count of pieces and add to the cart again.
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("you \'ve added This Before"))
                              );
                            }else{
                              cartItem.addToCart(products);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Added To Cart"))
                              );
                            }
                          },
                          child: Text(
                            "Add To Cart",
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                        )),
                  ],
                )),
          ),
        ));
  }
}
