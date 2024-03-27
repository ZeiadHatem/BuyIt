import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:ecommerce/constants.dart';
import 'package:ecommerce/provider/Admin_Mood.dart';
import 'package:ecommerce/provider/cart_item.dart';
import 'package:ecommerce/provider/modal_hud.dart';
import 'package:ecommerce/screens/Admin_Screens/AddProduct_Screen.dart';
import 'package:ecommerce/screens/Admin_Screens/AdminHome_Screen.dart';
import 'package:ecommerce/screens/Admin_Screens/EditProduct_Screen.dart';
import 'package:ecommerce/screens/Admin_Screens/MangeProduct_Screen.dart';
import 'package:ecommerce/screens/Admin_Screens/OrderDetails_Screen.dart';
import 'package:ecommerce/screens/Admin_Screens/Orders_Screen.dart';
import 'package:ecommerce/screens/SignIn_Screen.dart';
import 'package:ecommerce/screens/User_Screens/Cart_Screen.dart';
import 'package:ecommerce/screens/User_Screens/Home_Screen.dart';
import 'package:ecommerce/screens/User_Screens/Product_Info_Screen.dart';
import 'package:ecommerce/screens/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ECommerce());
}

class ECommerce extends StatelessWidget{

  bool isUserLoggedIn = false;
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context , snapshot){
          if(snapshot.hasData){
            isUserLoggedIn = snapshot.data!.getBool(kpreferenceValue)??false;
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<CartItem>(
                    create: (context)=>CartItem()),
                ChangeNotifierProvider<ModalHud>(
                    create: (context)=>ModalHud()),
                ChangeNotifierProvider<AdminSwitch>(
                    create: (context)=>AdminSwitch())
              ],
              child: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent
                ),
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  initialRoute: SplashScreen.id,
                  routes: {
                    SplashScreen.id:(context)=>SplashScreen(nextScreen: isUserLoggedIn?HomeScreen():SignIn(),),
                    SignIn.id:(context)=>SignIn(),
                    SignUp.id: (context)=>SignUp(),
                    HomeScreen.id: (context)=>HomeScreen(),
                    AdminHome.id: (context)=>AdminHome(),
                    AddProductPage.id: (context)=>AddProductPage(),
                    ManageProductPage.id: (context)=>ManageProductPage(),
                    EditProductScreen.id: (context)=>EditProductScreen(),
                    ProductInfo.id: (context)=>ProductInfo(),
                    CartScreen.id: (context)=>CartScreen(),
                    OrdersPage.id: (context)=>OrdersPage(),
                    OrderDetails.id: (context)=>OrderDetails()
                  },
                ),
              ),
            );
          }
          else{
            return MaterialApp(
              home: Scaffold(

                body: Center(child: Text("Loading...."),),
              ),
            );
          }

        }
    );
  }
}


class SplashScreen extends StatelessWidget{
static String id = 'SplashScreen';

final nextScreen;

SplashScreen({this.nextScreen});

  Widget build(BuildContext context){
    return AnimatedSplashScreen(
        splash: Center(
          child: Image(image: AssetImage('tools/images/JustShopping.gif'),),
        ),
        nextScreen:nextScreen,
       splashIconSize: 500,
       backgroundColor: Color.fromRGBO(189, 131, 184, 5),
       duration: 2000,
    );
  }
}