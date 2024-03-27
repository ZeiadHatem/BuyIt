import 'package:ecommerce/Widget.dart';
import 'package:ecommerce/constants.dart';
import 'package:ecommerce/provider/modal_hud.dart';
import 'package:ecommerce/screens/SignIn_Screen.dart';
import 'package:ecommerce/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class SignUp extends StatelessWidget {
  static String id = 'SignUp';
  var _email, _pass;
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _auth = Auth();

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
                  hint: 'Enter Your name',
                  icon: Icon(Icons.person)),
              SizedBox(height: height * 0.02),
              CustomTextFiled(
                  onClick: (value) {
                    _email = value;
                  },
                  hint: 'Enter Your Email',
                  icon: Icon(Icons.email_outlined)),
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: MaterialButton(
                  color: Colors.black87,
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    emailController.clear();
                    passController.clear();
                    final modalHud =
                        Provider.of<ModalHud>(context, listen: false);
                    modalHud.changeisLoading(true);   // when user press the button
                    if (_globalKey.currentState!.validate()) {
                      _globalKey.currentState!.save();
                      print(_email);
                      print(_pass);
                      try {
                        final authResult = await _auth.signUp(_email.trim(), _pass.trim());
                        modalHud.changeisLoading(false); // when the authentication is finish disappear
                         Navigator.pushNamed(context, SignIn.id);
                        print(authResult.user?.uid);
                      }
                      on FirebaseAuthException catch (e) {
                        modalHud.changeisLoading(false);       // when have exception is disappear
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(e.message.toString()))); // to show the error to user but to understan like user not developer
                      }
                    }
                    modalHud.changeisLoading(false);   // when finished is disappear
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily:
                            'PlayfairDisplay-Italic-VariableFont_wght.ttf',
                        fontWeight: FontWeight.bold),
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
                    'Do Have An Account ?',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, SignIn.id);
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 15, color: Colors.blue),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
