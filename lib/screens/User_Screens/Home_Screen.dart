import 'package:ecommerce/Widget.dart';
import 'package:ecommerce/constants.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/screens/SignIn_Screen.dart';
import 'package:ecommerce/screens/User_Screens/Cart_Screen.dart';
import 'package:ecommerce/services/auth.dart';
import 'package:ecommerce/services/store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tabBarIndex = 0;
  int bottomBarIndex = 0;
  Store _store = Store();
  List<Products> _product = [];

  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Discover",
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: kFamilyFont,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                  IconButton(
                    onPressed: (){Navigator.pushNamed(context, CartScreen.id);},
                    icon: Icon(Icons.shopping_cart_rounded , color: Colors.grey,),
                  )
                ],
              ),
              backgroundColor: kBackgroundColor1,
              bottom: TabBar(
                  onTap: (value) {
                    setState(() {
                      tabBarIndex = value;
                    });
                  },
                  tabs: [
                    Text(
                      "Jackets",
                      style: TextStyle(
                          color:
                              tabBarIndex == 0 ? Colors.black87 : Colors.grey,
                          fontFamily: kFamilyFont,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    Text(
                      "Trousers",
                      style: TextStyle(
                          color:
                              tabBarIndex == 1 ? Colors.black87 : Colors.grey,
                          fontFamily: kFamilyFont,
                          fontSize: 15),
                    ),
                    Text(
                      "T-Shirts",
                      style: TextStyle(
                          color:
                              tabBarIndex == 2 ? Colors.black87 : Colors.grey,
                          fontFamily: kFamilyFont,
                          fontSize: 15),
                    ),
                    Text(
                      "Shoes",
                      style: TextStyle(
                          color:
                              tabBarIndex == 3 ? Colors.black87 : Colors.grey,
                          fontFamily: kFamilyFont,
                          fontSize: 15),
                    ),
                  ]),
            ),
            bottomNavigationBar: BottomNavigationBar(
              //to show categories of products.
              currentIndex: bottomBarIndex,
              onTap: (value) async{
                if(value==3){
                  //to save all info of user in his phone and stay it login.
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.clear();
                  Auth auth = Auth();
                  await auth.signOut();
                  Navigator.popAndPushNamed(context, SignIn.id);
                }
                setState(() {
                  bottomBarIndex = value;
                });
              },
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: Colors.grey,
              backgroundColor: kBackgroundColor1,
              items: [
                BottomNavigationBarItem(
                    label: "Profile", icon: Icon(Icons.person)),
                BottomNavigationBarItem(
                    label: "Category", icon: Icon(Icons.category)),
                BottomNavigationBarItem(
                    label: "Settings", icon: Icon(Icons.settings)),
                BottomNavigationBarItem(
                    label: "SignOut", icon: Icon(Icons.logout_rounded)),
              ],
            ),
            body: TabBarView(children: [
              productView(kJackets, _product),
              productView(kTrousers, _product),
              productView(kTShirt, _product),
              productView(kShoes, _product),
            ]),
          ),
        )
      ],
    );
  }
}
