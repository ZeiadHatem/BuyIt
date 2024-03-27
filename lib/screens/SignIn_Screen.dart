import 'package:ecommerce/provider/Admin_Mood.dart';
import 'package:ecommerce/provider/modal_hud.dart';
import 'package:ecommerce/screens/Admin_Screens/AdminHome_Screen.dart';
import 'package:ecommerce/screens/User_Screens/Home_Screen.dart';
import 'package:ecommerce/screens/signup_screen.dart';
import 'package:ecommerce/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widget.dart';
import '../constants.dart';


class SignIn extends StatefulWidget {
  static String id = 'SignIn';

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  var _email, _pass;

  final emailController = TextEditingController();

  final passController = TextEditingController();

  final _auth = Auth();

  final adminPass = 'admin1234';

  bool rememberMe = false;

  _validate(BuildContext context) async {
    final modalHud = Provider.of<ModalHud>(context, listen: false);
    modalHud.changeisLoading(true);
    if (_globalKey.currentState!.validate()) {
      _globalKey.currentState?.save();
      if (Provider.of<AdminSwitch>(context, listen: false).areYouAdmin) {
        if (_pass == adminPass) {
          try {
            await _auth.signIn(_email, _pass);
            modalHud.changeisLoading(false);
            Navigator.pushNamed(context, AdminHome.id);
          } on FirebaseAuthException catch (e) {
            modalHud.changeisLoading(false);
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.message.toString())));
          }
        } else {
          modalHud.changeisLoading(false);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("SomeThing went Wrong😕")));
        }
      } else {
        try {
          await _auth.signIn(_email, _pass);
          modalHud.changeisLoading(false);
          Navigator.pushNamed(context, HomeScreen.id);
        } on FirebaseAuthException catch (e) {
          modalHud.changeisLoading(false);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.message.toString())));
        }
      }
    }
    modalHud.changeisLoading(false);
  }

  void keepUserLoggedIn() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(kpreferenceValue, rememberMe);
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kBackgroundColor1,
      body: ModalProgressHUD(
        color: Colors.transparent,
        inAsyncCall: Provider.of<ModalHud>(context).isLoading,
        child: Form(
          key: _globalKey,
          child: ListView(
            children: [
              CustomLogo(text: 'Buy It', image: 'tools/images/iconfront.png'),
              SizedBox(
                height: height * .1,
              ),
              CustomTextFiled(
                onClick: (value) {
                  _email = value;
                },
                icon: Icon(
                  Icons.email_outlined,
                  color: Colors.black87,
                ),
                hint: 'Enter Your Email',
              ),
              SizedBox(
                height: height * .02,
              ),
              CustomTextFiled(
                  onClick: (value) {
                    _pass = value;
                  },
                  hint: 'Enter Your Password',
                  icon: Icon(Icons.lock)),
              SizedBox(
                height: height * .05,
              ), // in this way , the height of the sized box is 0.05, the height of the screen

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        Provider.of<AdminSwitch>(context, listen: false)
                            .changeAreYouAdmin(true);
                      },
                      child: Text(
                        'I\’m an Admin',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Provider.of<AdminSwitch>(context).areYouAdmin
                                ? kBackgroundColor1
                                : Colors.white,
                            fontSize: 12),
                      ),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        Provider.of<AdminSwitch>(context, listen: false)
                            .changeAreYouAdmin(false);
                      },
                      child: Text(
                        'I\’m a User',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Provider.of<AdminSwitch>(context).areYouAdmin
                                ? Colors.white
                                : kBackgroundColor1,
                            fontSize: 12),
                      ),
                    ))
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: Colors.white
                    ),
                    child: Checkbox(
                      activeColor: kBackgroundColor1,
                        value: rememberMe, onChanged: (value){
                      setState(() {
                        rememberMe = value!;
                      });
                    }),
                  ),

                  Text("RememberMe" , style: TextStyle(color:Colors.white,fontSize: 17, fontFamily: kFamilyFont),)
                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: MaterialButton(
                  color: Colors.black87,
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50)),
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    emailController.clear();
                    passController.clear();
                    if(rememberMe==true){
                      keepUserLoggedIn();
                    }
                    _validate(context);
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily:
                            'PlayfairDisplay-Italic-VariableFont_wght.ttf',
                        fontSize: 20,
                        color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: height * .05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don’t Have An Account ?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, SignUp.id);
                    },
                    child: const Text(
                      "SignUp",
                      style: TextStyle(fontSize: 15, color: Colors.blue),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


}
