import 'package:ecommerce/Widget.dart';
import 'package:ecommerce/screens/Admin_Screens/AddProduct_Screen.dart';
import 'package:ecommerce/screens/Admin_Screens/MangeProduct_Screen.dart';
import 'package:ecommerce/screens/Admin_Screens/Orders_Screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminHome extends StatelessWidget {
  static String id = 'AdminHome';

  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: Colors.cyanAccent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
            ),
            ButtonsHome(
              text: 'Add Product',
              color: Colors.blue[900],
              onPressed: () {
                Navigator.pushNamed(context, AddProductPage.id);
              },
            ),
            ButtonsHome(
              text: 'Edit Product',
              color: Colors.black87,
              onPressed: () {
                Navigator.pushNamed(context, ManageProductPage.id);
              },
            ),
            ButtonsHome(
              text: 'View Orders',
              color: Colors.deepOrange,
              onPressed: () {
                Navigator.pushNamed(context, OrdersPage.id);
              },
            )
          ],
        ),
      ),
    );
  }
}
