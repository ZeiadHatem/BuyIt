import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Widget.dart';
import 'package:ecommerce/constants.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/services/store.dart';
import 'package:flutter/material.dart';

import 'EditProduct_Screen.dart';

class ManageProductPage extends StatefulWidget {
  static String id = 'ManageProductPage';

  @override
  State<ManageProductPage> createState() => _ManageProductPageState();
}

class _ManageProductPageState extends State<ManageProductPage> {
  Store _store = Store();
  List<Products> productListDontRepeat = [];
  var unique = Set<Products>();

  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _store.loadProduct(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List productList = [];
            for (var data in snapshot.data!.docs) {
              productList.add(Products(
                  pId: data.id,
                  pName: data.get(kProductName),
                  pPrice: data.get(kProductPrice),
                  pDescription: data.get(kProductDescription),
                  pCategory: data.get(kProductCategory),
                  pLocation: data.get(kProductImageLocation)));
            }
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.8, crossAxisCount: 2),
                itemCount: productList.length,
                itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: InkWell(
                        onTapUp: (details) {
                          double dxL = details.globalPosition.dx;
                          double dyT = details.globalPosition.dy;
                          double dxR = MediaQuery.of(context).size.width-dxL;
                          double dyB = MediaQuery.of(context).size.width-dyT;
                          showMenu(
                              context: context,
                              position: RelativeRect.fromLTRB(dxL, dyT, dxR, dyB),
                              items: [
                                MyPopUpMenuItem(
                                  onClick: (){
                                    Navigator.pushNamed(context, EditProductScreen.id , arguments: productList[index]);
                                  },
                                  child: Text("Edit"),
                                ),
                                MyPopUpMenuItem(
                                   onClick: (){
                                     _store.deleteProduct(productList[index].pId);
                                     Navigator.pop(context);
                                     print(productList[index].pId);
                                   },
                                    child: Text("Delete")
                                )
                              ]
                          );
                        },
                        child: Stack(
                          children: [
                            Positioned.fill(
                                child: Image(
                                    image: AssetImage(
                                        productList[index].pLocation))),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.black87.withOpacity(0.4)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        productList[index].pName,
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            fontFamily:
                                                'PlayfairDisplay-Italic-VariableFont_wght.ttf',
                                            color: Colors.white),
                                      ),
                                      Text(
                                        "\$${productList[index].pPrice}",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            fontFamily:
                                                'PlayfairDisplay-Italic-VariableFont_wght.ttf',
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
