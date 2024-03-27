import 'package:ecommerce/models/product.dart';
import 'package:flutter/cupertino.dart';

class CartItem extends ChangeNotifier{

  List<Products> product = [];

  addToCart(Products products){
    product.add(products);
    notifyListeners();
  }

  deleteProduct(Products products){

    product.remove(products);
    notifyListeners();
  }
}