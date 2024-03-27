import 'package:ecommerce/Widget.dart';
import 'package:ecommerce/constants.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/services/store.dart';
import 'package:flutter/material.dart';


class EditProductScreen extends StatelessWidget{

  static String id = 'EditProduct';

  var _name, _price, _description, _category, _imageLocation;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  Store _store = Store();
  Widget build(BuildContext context){
    Products product =ModalRoute.of(context)?.settings.arguments as Products;
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _globalKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Edit of Product" , style: TextStyle(
              fontFamily: 'PlayfairDisplay-Italic-VariableFont_wght.ttf',
              fontWeight: FontWeight.bold,
              fontSize: 40,
              fontStyle: FontStyle.italic
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
              text: 'Edit Product',
              onPressed: () {
                print(product.pId);
                if(_globalKey.currentState!.validate()){
                  _globalKey.currentState?.save();
                  _store.updateProduct({
                    kProductName: _name,
                    kProductPrice: _price,
                    kProductDescription: _description,
                    kProductImageLocation: _imageLocation,
                    kProductCategory: _category
                  }, product.pId);
                }

              },
              color: Colors.blueAccent,
            )
          ],
        ),
      ),
    );
  }
}