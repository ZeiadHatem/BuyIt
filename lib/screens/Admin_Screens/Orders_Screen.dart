import 'package:ecommerce/constants.dart';
import 'package:ecommerce/models/Orders.dart';
import 'package:ecommerce/screens/Admin_Screens/OrderDetails_Screen.dart';
import 'package:ecommerce/services/store.dart';
import 'package:flutter/material.dart';



class OrdersPage extends StatelessWidget{
  static String id = "OrdersScreen";

  Store _store = Store();

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor1,
        title: Text("customer orders",style: TextStyle(
          fontFamily: kFamilyFont,
          fontSize: 20
        ),),
      ),
      body: StreamBuilder(
        stream: _store.loadOrders(),
        builder: (context , snapshot){
          if(snapshot.hasData){
            List<Order> ordersList=[];

            for(var order in snapshot.data!.docs){
              ordersList.add(Order(
                documentId: order.id,
                address: order.get(kAddress),
                totallPrice: order.get(kTotalPrice)
              ));
            }
            return ListView.builder(
              itemCount: ordersList.length,
                itemBuilder: (context , index)=>InkWell(
                  onTap:(){
                    Navigator.pushNamed(context, OrderDetails.id, arguments: ordersList[index].documentId);
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height*0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.tealAccent,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('TotalPrice: ${ordersList[index].totallPrice}',style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,fontFamily: kFamilyFont),),
                        SizedBox(height: 10,),
                        Text('Address: ${ordersList[index].address}',style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,fontFamily: kFamilyFont),)
                      ],
                    ),
                  ),
                )
            );


          }else{
            return Center(child: Text('There is no Order'),);
          }
        },
      ),
    );
  }
}