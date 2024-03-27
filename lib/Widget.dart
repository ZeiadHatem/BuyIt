import 'package:ecommerce/constants.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/screens/User_Screens/Product_Info_Screen.dart';
import 'package:ecommerce/services/store.dart';
import 'package:flutter/material.dart';

class CustomTextFiled extends StatelessWidget {
  final hint;
  final icon;
  final onClick;
  errorMessage(String error) {
    switch (hint) {
      case 'Enter Your Email':
        return 'Email is Empty';
      case 'Enter Your Password':
        return 'Password is Empty';
      case 'Enter Your name':
        return 'Name is Empty';
    }
  }

  CustomTextFiled({this.hint, this.icon, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        onSaved: onClick,
        obscureText: hint == 'Enter Your Password' ? true : false,
        validator: (value) {
          if (value!.isEmpty) {
            return errorMessage(value);
          }
        },
        cursorColor: Colors.black87,
        decoration: InputDecoration(
            prefixIcon: icon,
            hintText: hint,
            filled: true,
            fillColor: Colors.tealAccent,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.red)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(20)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.white))),
      ),
    );
  }
}

class CustomLogo extends StatelessWidget {
  String image, text;

  CustomLogo({required this.text, required this.image});

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50),
      height: MediaQuery.of(context).size.height * 0.2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image(image: AssetImage(image)),
          Positioned(
            bottom: 0,
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'PlayfairDisplay-Italic-VariableFont_wght.ttf',
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent),
            ),
          )
        ],
      ),
    );
  }
}

class ButtonsHome extends StatelessWidget {
  final text, onPressed, color;

  ButtonsHome({this.text, this.onPressed, this.color});

  Widget build(BuildContext context) {
    return MaterialButton(
      shape: OutlineInputBorder(
          borderSide: BorderSide.none, borderRadius: BorderRadius.circular(40)),
      onPressed: onPressed,
      color: color,
      child: Text(
        text,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'PlayfairDisplay-Italic-VariableFont_wght.ttf',
            fontSize: 17),
      ),
    );
  }
}

Widget productView(String pCategory, product) {
  Store _store = Store();
  return StreamBuilder(
      stream: _store.loadProduct(),
      builder: (context, snapchat) {
        if (snapchat.hasData) {
          List<Products> productList = [];
          for (var data in snapchat.data!.docs) {
            productList.add(Products(
                pId: data.id,
                pName: data.get(kProductName),
                pPrice: data.get(kProductPrice),
                pDescription: data.get(kProductDescription),
                pCategory: data.get(kProductCategory),
                pLocation: data.get(kProductImageLocation)));
            product = [...productList];
            productList.clear();
            productList = getProduct(pCategory, product);
          }
          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.8, crossAxisCount: 2),
              itemCount: productList.length,
              itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, ProductInfo.id,
                            arguments: productList[index]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black87,
                                  offset: Offset(0, 2),
                                  blurRadius: 10)
                            ]),
                        child: Stack(
                          children: [
                            Positioned.fill(
                                child: Image(
                                    image: AssetImage(
                                        productList[index].pLocation))),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.black87.withOpacity(0.4),
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(30),
                                        bottomLeft: Radius.circular(30))),
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
                    ),
                  ));
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      });
}

List<Products> getProduct(String kCategory, product) {
  List<Products> products = [];
  for (var product in product) {
    if (product.pCategory == kCategory) {
      products.add(product);
    }
  }
  return products;
}

class AppsContainer extends StatelessWidget {
  final Products products;
  final itemIndex;
  final id;

  AppsContainer({required this.products, this.itemIndex, this.id});

  Widget build(BuildContext context) {
    //final product = ModalRoute.of(context)?.settings.arguments as Products;
    return InkWell(
      onTap: () {},
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                  color: Colors.tealAccent,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
            ),
          ),
          Positioned(
            left: 60,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.transparent,
              backgroundImage:
                  Image(image: AssetImage(products.pLocation)).image,
            ),
          ),
          Positioned(
              top: 100,
              left: 10,
              child: Text(
                products.pName,
                style: TextStyle(
                    fontFamily: kFamilyFont,
                    color: Colors.blue[900],
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )),
          Positioned(
              height: 40,
              width: 150,
              bottom: 40,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    color: Colors.blue[900]),
                child: Text(
                  "${products.pPrice}USD",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: kFamilyFont,
                      color: Colors.tealAccent,
                      fontSize: 20),
                ),
              )),
          Positioned(
              bottom: 5,
              right: 10,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'More Details >',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontFamily: kFamilyFont),
                ),
              ))
        ],
      ),
    );
  }
}

class MyPopUpMenuItem<T> extends PopupMenuItem<T> {
  final Function onClick;
  MyPopUpMenuItem({required super.child, required this.onClick});

  @override
  PopupMenuItemState<T, PopupMenuItem<T>> createState() =>
      MyPopUpMenuItemState();
}

class MyPopUpMenuItemState<T, PopupMenuItem>
    extends PopupMenuItemState<T, MyPopUpMenuItem<T>> {
  @override
  void handleTap() {
    widget.onClick();
  }
}
