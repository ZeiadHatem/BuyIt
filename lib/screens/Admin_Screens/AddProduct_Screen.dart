import 'package:ecommerce/Widget.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/services/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddProductPage extends StatelessWidget {
  static String id = 'AddProductPage';
  var _name, _price, _description, _category, _imageLocation;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final Store _store = Store();
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
      child: Scaffold(
        backgroundColor: Colors.indigo[900],
        body: Form(
          key: _globalKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Edit of Product" , style: TextStyle(
                  fontFamily: 'PlayfairDisplay-Italic-VariableFont_wght.ttf',
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  fontStyle: FontStyle.italic,
                color: Colors.white
              ),),
              SizedBox(height: MediaQuery.of(context).size.height*0.1,),
              CustomTextFiled(
                hint: 'Product Name',
                onClick: (value) {
                  _name = value;
                },
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextFiled(
                hint: 'Product Price',
                onClick: (value) {
                  _price = value;
                },
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextFiled(
                hint: 'Product Description',
                onClick: (value) {
                  _description = value;
                },
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextFiled(
                  hint: 'Product Category',
                  onClick: (value) {
                    _category = value;
                  }),
              SizedBox(
                height: 10,
              ),
              CustomTextFiled(
                hint: 'Product Location',
                onClick: (value) {
                  _imageLocation = value;
                },
              ),
              SizedBox(
                height: 20,
              ),
              ButtonsHome(
                text: 'Add Product',
                onPressed: () {
                  if(_globalKey.currentState!.validate()){
                    _globalKey.currentState?.save();
                    _store.addProduct(Products(
                      pName: _name,
                      pPrice: _price,
                      pDescription: _description,
                      pCategory: _category,
                      pLocation: _imageLocation
                    ));
                  }

                },
                color: Colors.blueAccent,
              )
            ],
          ),
        ),
      ),
    );
  }
}
