
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greek_cafe/rules.dart';
import 'package:greek_cafe/senderList.dart';

import 'package:http/http.dart' as http;
import 'package:progress_indicators/progress_indicators.dart';

import 'basketScreen.dart';
import 'main.dart';
import 'package:greek_cafe/profileScreen.dart';

import 'messenger.dart';

bool HistoryComplite = false;
final List<String> HistoryNameBlude = [];
final List<double> HistoryPriceBlude = [];
int timePeriod = 1;


String nameBludeText;
double priceOrder = 0.00;

int internelIdOrderSearch = 0;

class HistoryView extends StatefulWidget {

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryView>  with SingleTickerProviderStateMixin {


  AnimationController _animationController;

  @override
  void initState() {
 _sendRequestHistory();
 _animationController =
 new AnimationController(vsync: this, duration: Duration(seconds: 3));
 super.initState();

 _animationController.addListener(() => setState(() {}));
 if(eatTotalPriceList>0){
   TickerFuture tickerFuture = _animationController.repeat();
   tickerFuture.timeout(Duration(seconds:  1), onTimeout:  () {
     _animationController.forward(from: 1);
     _animationController.stop(canceled: true);
   });}

  }

  _sendRequestHistory() async {
    //print('запросили историю $timePeriod');
    try {

      var response = await http.post('https://koldashev.ru/GreekCafeAPI.php',
          headers: {"Accept": "application/json"},
          body: jsonEncode(<String, dynamic>{
            "login": "$IdRestaurant",
            "user" :"$Uphone",
            "timePeriod" : timePeriod,
            "subject" : "history"
          })
      );

      var jsonDataHistory = response.body;
      parsedJsonHistory = json.decode(jsonDataHistory);
      HistoryComplite = true;
    } catch (error) {
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFffffff),
      appBar:AppBar(
        elevation: 0.0,
        title: Image.asset('images/mainLogo.png',  height: 50, fit:BoxFit.fill),
        centerTitle: true,
        backgroundColor: Color(0xFFffffff),
        brightness: Brightness.light,
        leading: Container(
          child: Material(
            color: Colors.white, // button color
            child: InkWell(
              splashColor: Colors.green, // splash color
              onTap: () {
                HistoryComplite = false;
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => MainScreen()));
              }, // button pressed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.home, size: 18.0, color: Colors.black), // icon
                  Text("Home", style: TextStyle(color: Colors.black87)), // text
                ],
              ),
            ),
          ),
        ),
      ),
      body:SingleChildScrollView(
          physics: ScrollPhysics(),
          child:Center(
              child: Column(
                  children: <Widget>[
                    Text('Ιστορικό παραγγελιών', style: TextStyle(fontSize: 20.0,color: Colors.black87,fontWeight: FontWeight.bold,)),
                    Transform.rotate(
                        angle: 3.1458,
                        child:Container(
                          child:Image.asset('images/spaceImage.png',   fit:BoxFit.fill,),
                          alignment: Alignment(0.00, 0.0),
                          padding: EdgeInsets.fromLTRB(0,0,0,5),
                        )),
                    SizedBox(height: 15.0),
                    //{parsedJsonHistory['numberOrder']}!=0?Container(
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                           FlatButton(
                              child: Text('Μήνας', style: TextStyle(fontSize: 12.0,color: Colors.black87,)),
                              onPressed: () {
                                timePeriod = 1;
                                _sendRequestHistory();
                              },
                            ),
                          FlatButton(
                            child: Text('Ετος', style: TextStyle(fontSize: 12.0,color: Colors.black87,)),
                            onPressed: () {
                              timePeriod = 2;
                              _sendRequestHistory();
                            },
                          ),
                          FlatButton(
                            child: Text('Τα παντα', style: TextStyle(fontSize: 12.0,color: Colors.black87,)),
                            onPressed: () {
                              timePeriod = 3;
                              _sendRequestHistory();
                            },
                          ),
                    ]),
                    SizedBox(height: 1.0, width: MediaQuery.of(context).size.width - 80,
                      child: const DecoratedBox(
                        decoration: const BoxDecoration(
                          color: Colors.black,
                        ),
                      ),),
                    SizedBox(height: 20.0),
                    HistoryComplite?ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: parsedJsonHistory.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              margin: EdgeInsets.fromLTRB(5,5,5,10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: parsedJsonHistory[index]['numberOrder']!=0?Column(
                                  children: <Widget>[
                                    SizedBox(height: 20.0),
                                    Container(
                                      child: Text('Σειρά ${parsedJsonHistory[index]['numberOrder']}', style: TextStyle(fontSize: 15.0,color: Colors.black87)),
                                    ),
                                    SizedBox(height: 1.0, width: MediaQuery.of(context).size.width - 80,
                                      child: const DecoratedBox(
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                        ),
                                      ),),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(20,10,20,10),

                                        child: Row(
                                            children: <Widget>[

                                              Column(
                                        children: <Widget>[
                                                  Text('${parsedJsonHistory[index]['dateOrder']}', style: TextStyle(fontSize: 12.0,color: Colors.black87)),
                                                  Text('  ${parsedJsonHistory[index]['timeOrder']}', style: TextStyle(fontSize: 12.0,color: Colors.black87,)),
                                              ]),
                                          parsedJsonHistory[index]['statusOrder'] == 4?Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(7.0),
                                                        color: Colors.green,
                                                      ),
                                                      child: Text('Ολοκληρώθηκε', style: TextStyle(fontSize: 15.0,color: Colors.white), textAlign: TextAlign.center,),
                                                      padding: EdgeInsets.fromLTRB(5,2,5,2),
                                                      margin: EdgeInsets.fromLTRB(10,0,0,0),
                                                ):parsedJsonHistory[index]['statusOrder'] == 1?Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(7.0),
                                                      color: Colors.redAccent,
                                                    ),
                                                    child: Text('Ακυρώθηκε', style: TextStyle(fontSize: 15.0,color: Colors.white), textAlign: TextAlign.center,),
                                                    padding: EdgeInsets.fromLTRB(5,2,5,2),
                                                    margin: EdgeInsets.fromLTRB(10,0,0,0),
                                                    ):parsedJsonHistory[index]['statusOrder'] == 2?Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(7.0),
                                              color: Colors.blue,
                                            ),
                                            child: Text('Προετοιμασία', style: TextStyle(fontSize: 15.0,color: Colors.white), textAlign: TextAlign.center,),
                                            padding: EdgeInsets.fromLTRB(5,2,5,2),
                                            margin: EdgeInsets.fromLTRB(10,0,0,0),
                                          ):parsedJsonHistory[index]['statusOrder'] == 3?Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(7.0),
                                              color: Colors.lightGreenAccent,
                                            ),
                                            child: Text('Έτοιμο για έκδοση', style: TextStyle(fontSize: 15.0,color: Colors.black), textAlign: TextAlign.center,),
                                            padding: EdgeInsets.fromLTRB(5,2,5,2),
                                            margin: EdgeInsets.fromLTRB(10,0,0,0),
                                          ):Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(7.0),
                                                  color: Colors.yellow,
                                                ),
                                                child: Text('Αποδεκτό', style: TextStyle(fontSize: 15.0,color: Colors.black), textAlign: TextAlign.center,),
                                                padding: EdgeInsets.fromLTRB(5,2,5,2),
                                                margin: EdgeInsets.fromLTRB(10,0,0,0),
                                              ),
                                              parsedJsonHistory[index]['statusOrder'] == 4?ButtonTheme(
                                                minWidth: 20,
                                                child: FlatButton.icon(icon: Icon(
                                                    parsedJsonHistory[index]['buttonClick']==1?
                                                      CupertinoIcons.restart:
                                                      CupertinoIcons.check_mark, size: 30.00),
                                                    label: parsedJsonHistory[index]['buttonClick']==1?Text("Επαναλαμβάνω", style: TextStyle(fontSize: 10.0,color: Colors.black87,)):Text("Εγινε", style: TextStyle(fontSize: 10.0,color: Colors.black87,)),
                                                  textColor: Colors.blueAccent,
                                                  disabledColor: Colors.blueAccent,
                                                  disabledTextColor: Colors.redAccent,
                                                  splashColor: Colors.blueAccent,
                                                  onPressed: (){
                                                    parsedJsonHistory[index]['buttonClick']=0;
                                                  repeatToBasket(parsedJsonHistory[index]['numberOrder']);
                                                  setState(() {});
                                                    TickerFuture tickerFuture = _animationController.repeat();
                                                    tickerFuture.timeout(Duration(seconds:  1), onTimeout:  () {
                                                      _animationController.forward(from: 1);
                                                      _animationController.stop(canceled: true);
                                                    });
                                                    },
                                                ),
                                              ):parsedJsonHistory[index]['statusOrder'] == 2?Container(
                                                  width: 15.0,
                                                  height: 15.0,
                                                  margin: EdgeInsets.fromLTRB(10,0,0,0),
                                                  child:CircularProgressIndicator(strokeWidth: 2.0,
                                                  valueColor : AlwaysStoppedAnimation(Colors.blue),))
                                                  :parsedJsonHistory[index]['statusOrder'] == 3?Container(
                                                  width: 15.0,
                                                  height: 15.0,
                                                  margin: EdgeInsets.fromLTRB(10,0,0,0),
                                                  //padding: EdgeInsets.fromLTRB(0,0,0,10),
                                                  child: HeartbeatProgressIndicator(
                                                    child: Icon(Icons.home, size: 15.00, color: Colors.lightGreen,),
                                                  )):Container(),
                                              ]
                                            ),
                                    ),
                                    SizedBox(height: 1.0, width: MediaQuery.of(context).size.width - 80,
                                      child: const DecoratedBox(
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                        ),
                                      ),),
                                    ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: parsedJsonHistory[index]['itemsOrder'].length,
                                        itemBuilder: (BuildContext context, int index2) {
                                          return Container(
                                              child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                        margin: EdgeInsets.fromLTRB(20,0,20,0),
                                                        alignment: Alignment(-1.0, 0.0),
                                                        child: parsedJsonHistory[index]['itemsOrder'][index2]['value']>0?
                                                          Text('${nameBludeSearch(parsedJsonHistory[index]['itemsOrder'][index2]['idBlude'])} - ${parsedJsonHistory[index]['itemsOrder'][index2]['value']} μερ. x ${parsedJsonHistory[index]['itemsOrder'][index2]['price']}€',
                                                              style: TextStyle(fontSize: 17.0,color: Colors.black87)):Container()),
                                                     Container(
                                                         margin: EdgeInsets.fromLTRB(20,0,20,0),
                                                         alignment: Alignment(-1.0, 0.0),
                                                        child: parsedJsonHistory[index]['itemsOrder'][index2]['valueFull']>0?
                                                          Text('${nameBludeSearch(parsedJsonHistory[index]['itemsOrder'][index2]['idBlude'])} - ${parsedJsonHistory[index]['itemsOrder'][index2]['valueFull']} πιά. x ${parsedJsonHistory[index]['itemsOrder'][index2]['priceFull']}€',
                                                              style: TextStyle(fontSize: 17.0,color: Colors.black87,)):Container()),
                                                   // ),
                                                  ]
                                              ),
                                          );
                                        }
                                    ),

                                    SizedBox(height: 5.0),
                                    SizedBox(height: 2.0, width: MediaQuery.of(context).size.width - 50,
                                      child: const DecoratedBox(
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                        ),
                                      ),),
                                    SizedBox(height: 5.0),
                                    Text('Τιμή παραγγελίας ${double.parse((finalPriceForOrder(index).toStringAsFixed(2)))}€ ',
                                        style: TextStyle(fontSize: 17.0,color: Colors.black87,)),
                                    SizedBox(height: 20.0),
                                  ]
                              )
                                  :Container(
                                        child:Text('\nΔεν έχετε κάνει παραγγελίες ακόμη\n', style: TextStyle(fontSize: 20.0,color: Colors.black87),textAlign: TextAlign.center,)
                                    ),
                          );
                        }
                    ):Container(
                        width: 50.0,
                        height: 50.0,
                        margin: EdgeInsets.fromLTRB(10,50,0,0),
                        child:CircularProgressIndicator(strokeWidth: 4.0,
                          valueColor : AlwaysStoppedAnimation(Colors.green),)) // отображаем что-то пока история грузится

                  //  ),
            //:Container(
            //            child:Text('Δεν έχετε κάνει παραγγελίες ακόμη', style: TextStyle(fontSize: 20.0,color: Colors.black87),textAlign: TextAlign.center,)
            //        ),
                  ])
          )),
      floatingActionButton: !ProfileComplite?FloatingActionButton.extended(
        onPressed:() {
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => profileView()));
          /*Navigator.push(context,
            CupertinoPageRoute(builder: (context) => rulesPage()));*/
          },
        tooltip: 'Increment',
        label: Text('Add profile', style: TextStyle(fontSize: 14.0, color: Colors.black),textAlign: TextAlign.justify,),
        icon: Icon(Icons.account_box),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ):notReadMessageCount>0?FloatingActionButton.extended(
        onPressed:() {
          messageListComplite = false;
          HistoryComplite = false;
          isAdmin||isManager?Navigator.push(context,
              CupertinoPageRoute(builder: (context) => senderList())):Navigator.push(context,
              CupertinoPageRoute(builder: (context) => messenger()));},
        tooltip: 'Increment',
        label: Text('$notReadMessageCount messages', style: TextStyle(fontSize: 14.0, color: Colors.black),textAlign: TextAlign.justify,),
        icon: Icon(Icons.message),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ):
    FadeTransition(
    opacity: _animationController,
      child: FloatingActionButton.extended(
        onPressed:() {
          messageListComplite = false;
          HistoryComplite = false;
          sendBascket = true;
          if(eatTotalPriceList >0.00){PrintBasket (); Navigator.push(context,
            CupertinoPageRoute(builder: (context) => CartView()));}},
        tooltip: 'Increment',
        label: Text('${double.parse((eatTotalPriceList.toStringAsFixed(2)))}€', style: TextStyle(fontSize: 14.0, color: Colors.black),textAlign: TextAlign.justify,),
        icon: Icon(Icons.shopping_basket),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      )),
    );
  }
}


nameBludeSearch (int idBudeSearch){
    var oneCount = parsedJson[0]['menuClient'].length;
    for (int i = 0; i < oneCount; i++) {
      var twoCount = parsedJson[0]['menuClient'][i]['groupMember'].length;
      for (int ii = 0; ii < twoCount; ii++) {
        if (parsedJson[0]['menuClient'][i]['groupMember'][ii]['id_blude'] == idBudeSearch) {
          nameBludeText = parsedJson[0]['menuClient'][i]['groupMember'][ii]['nameBlude'];
         }
      }
    }
  return nameBludeText;
}

finalPriceForOrder(int orderNumber){
  priceOrder = 0.00;
  var oneCount = parsedJsonHistory[orderNumber]['itemsOrder'].length;
  for (int i = 0; i < oneCount; i++) {
  if(parsedJsonHistory[orderNumber]['itemsOrder'][i]['value'] > 0){ priceOrder += parsedJsonHistory[orderNumber]['itemsOrder'][i]['value'] * parsedJsonHistory[orderNumber]['itemsOrder'][i]['price'];}
  if(parsedJsonHistory[orderNumber]['itemsOrder'][i]['valueFull'] > 0){ priceOrder += parsedJsonHistory[orderNumber]['itemsOrder'][i]['valueFull'] * parsedJsonHistory[orderNumber]['itemsOrder'][i]['priceFull'];}
  }
  return priceOrder;
}

repeatToBasket(int numberOrder){
  var oneCount = parsedJsonHistory.length;
  for (int i = 0; i < oneCount; i++) { //обходим массив истории заказов для получения элементов только нужного заказа
    if(parsedJsonHistory[i]['numberOrder'] == numberOrder){
     var twoCount = parsedJsonHistory[i]['itemsOrder'].length;
      for (int ii = 0; ii < twoCount; ii++) { // обходим массив нужного заказа для получения ИД блюд в его составе
        var threeCount = parsedJson[0]['menuClient'].length;
        for(int iii=0; iii < threeCount; iii++) { // обходим массив основного меню и получаем список блюд
          var foreCount = parsedJson[0]['menuClient'][iii]['groupMember'].length;
          for (int iiii = 0; iiii < foreCount; iiii++) { // ищем совпадения блюда из меню с сопаденим блюдп из истории
            if(parsedJsonHistory[i]['itemsOrder'][ii]['idBlude'] == parsedJson[0]['menuClient'][iii]['groupMember'][iiii]['id_blude']){
              if(parsedJsonHistory[i]['itemsOrder'][ii]['value'] > 0) {
                print('add standart blude ${parsedJsonHistory[i]['itemsOrder'][ii]['value']}');
                parsedJson[0]['menuClient'][iii]['groupMember'][iiii]['value'] = parsedJson[0]['menuClient'][iii]['groupMember'][iiii]['value'] +
                parsedJsonHistory[i]['itemsOrder'][ii]['value'];
                eatTotalPriceList = eatTotalPriceList +
                    (parsedJson[0]['menuClient'][iii]['groupMember'][iiii]['priceBlude'] * parsedJsonHistory[i]['itemsOrder'][ii]['value']);
              }
              if(parsedJsonHistory[i]['itemsOrder'][ii]['valueFull'] > 0) {
                print('add full blude ${parsedJsonHistory[i]['itemsOrder'][ii]['valueFull']}');
                parsedJson[0]['menuClient'][iii]['groupMember'][iiii]['valueFull'] = parsedJson[0]['menuClient'][iii]['groupMember'][iiii]['valueFull'] +
                parsedJsonHistory[i]['itemsOrder'][ii]['valueFull'];
                eatTotalPriceList = eatTotalPriceList +
                    (parsedJson[0]['menuClient'][iii]['groupMember'][iiii]['priceBludeFull'] * parsedJsonHistory[i]['itemsOrder'][ii]['valueFull']);
              }
            }
          }
        }
      }
      print('ok');
    }

  }
}




