import 'package:flutter/widgets.dart';

class AdminSwitch extends ChangeNotifier{

  bool areYouAdmin= false;

  changeAreYouAdmin(bool value){

    areYouAdmin =value;
    notifyListeners();
  }
}