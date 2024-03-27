import 'package:ecommerce/constants.dart';
import 'package:ecommerce/models/Orders.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/services/store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class OrderDetails extends StatelessWidget{
  static String id = 'OrderDetails';
Store _store = Store();

  Widget build (BuildContext context){
    final documentId = ModalRoute.of(context)?.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("Order Details", style: TextStyle(
          fontSize: 20,
          fontFamily: kFamilyFont
        ),),
      ),
      body: StreamBuilder(
        stream: _store.loadOrderDetails(documentId),
        builder: (context , snapshot){

          if(snapshot.hasData){
            List<Products> product = [];
            for(var data in snapshot.data!.docs){
              product.add(Products(
                pName: data.get(kProductName),
                pPrice: data.get(kProductPrice),
                pCount: data.get(kProductCount),
                pCategory: data.get(kProductCategory),
                pLocation: data.get(kProductImageLocation)
              ));
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: product.length,
                      itemBuilder: (context, index)=>Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        height: MediaQuery.of(context).size.height*0.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.tealAccent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Product: ${product[index].pName}',style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,fontFamily: kFamilyFont),),
                                SizedBox(height: 10,),
                                Text('Count: ${product[index].pCount}',style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,fontFamily: kFamilyFont),),
                                SizedBox(height: 10,),
                                Text('Category: ${product[index].pCategory}',style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,fontFamily: kFamilyFont),)
                              ],
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 50,
                              backgroundImage: Image.asset(product[index].pLocation).image,
                            )
                          ],
                        ),
                      )
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: MaterialButton(
                          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide.none),
                          color: Colors.red[900],
                          onPressed: (){},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(CupertinoIcons.delete, color: Colors.white,),
                              Text("Delete" , style: TextStyle(fontFamily: kFamilyFont,fontSize: 20,color: Colors.white),)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 20,),
                      Expanded(
                        child: MaterialButton(
                          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide.none),
                            color: kBackgroundColor1,
                            onPressed: (){},
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(CupertinoIcons.hand_thumbsup_fill, color: Colors.white,),
                              Text("Confirm" , style: TextStyle(fontFamily: kFamilyFont,fontSize: 20,color: Colors.white),)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          }
          else{
            return Center(child: Text("Loading Orders..."),);
          }
        },
      ),
    );
  }
}