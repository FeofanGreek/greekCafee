
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:url_launcher/url_launcher.dart';

import 'main.dart';
import 'package:greek_cafe/profileScreen.dart';

import 'manageStaff.dart';
import 'messenger.dart';

bool orderListComplite = false;
final List<String> HistoryNameBlude = [];
final List<double> HistoryPriceBlude = [];

String  nameBludeText, orderComment = 'Όλα';
double priceOrder = 0.00;

int filterOrders = 111;
int timePeriodOrders = 0;

int internelIdOrderSearch = 0;

class editOrders extends StatefulWidget {

  @override
  _editOrdersScreenState createState() => _editOrdersScreenState();
}

class _editOrdersScreenState extends State<editOrders> {

  bool isClosed = false;
  bool isClosed2 = false;

  @override
  void initState() {

    if(isCooker){filterOrders=2;}
    if(isDeliver){filterOrders=3;}
    if(isManager){filterOrders=111;}
    if(isAdmin){filterOrders=111;}
    _sendRequestOrdersList(filterOrders);
    super.initState();
  }

  receptRequest() async{
    try {
      var response = await http.post('https://koldashev.ru/GreekCafeAPI.php',
          headers: {"Accept": "application/json"},
          body: jsonEncode(<String, dynamic>{
            "login": "$IdRestaurant",
            "subject" : "receptRequest"
          })
      );

    } catch (error) {
    }
  }


  _turnOrder(orderId,turn) async {
    try {
      var response = await http.post('https://koldashev.ru/GreekCafeAPI.php',
          headers: {"Accept": "application/json"},
          body: jsonEncode(<String, dynamic>{
            "login": "$IdRestaurant",
            "turn" : turn,
            "orderId" : orderId,
            "managerPhone" : "$Uphone",
            "subject" : "changeStatus"
          })
      );
      var jsonDataHistory = response.body;
      parsedJsonHistory = json.decode(jsonDataHistory);
      orderListComplite = true;
    } catch (error) {
    }
    _sendRequestOrdersList(turn);
  }

  callClient(url) async {
    url = url.replaceAll(' ','');
    url = url.replaceAll('-','');
    url = url.replaceAll('(','');
    url = url.replaceAll(')','');

    if (await canLaunch('tel://$url')) {
      await launch('tel://$url');
    } else {
      throw 'Невозможно набрать номер $url';
    }
    print('пробуем позвонить');
  }

  @override
  _sendRequestOrdersList(filter) async {
    try {
      var response = await http.post('https://koldashev.ru/GreekCafeAPI.php',
          headers: {"Accept": "application/json"},
          body: jsonEncode(<String, dynamic>{
            "login": "$IdRestaurant",
            "filter" : "$filter",
            "timePeriod" : timePeriodOrders,
            "subject" : "listOrders"
          })
      );
      var jsonDataHistory = response.body;
      if(response.body != '')
      {parsedJsonHistory = json.decode(jsonDataHistory);}
      else
      {parsedJsonHistory = '';}

      setState(() {});
    } catch (error) {
    }
    orderListComplite = true;
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
                  orderListComplite = false;
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
          actions: <Widget>[
            isAdmin?Container(
              margin: EdgeInsets.fromLTRB(0,0,10,0),
              child: Material(
                color: Colors.white, // button color
                child: InkWell(
                  splashColor: Colors.green, // splash color
                  onTap: () {
                    orderListComplite = false;
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => manageStaff()));}, // button pressed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.account_box, size: 18.0, color: Colors.black), // icon
                      Text("Staff", style: TextStyle(color: Colors.black87)), // text
                    ],
                  ),
                ),
              ),
            ):Container(),
            isAdmin?Container(
              margin: EdgeInsets.fromLTRB(0,0,10,0),
              child: Material(
                color: Colors.white, // button color
                child: InkWell(
                  splashColor: Colors.green, // splash color
                  onTap: () {

                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Θα λάβετε την αναφορά στη διεύθυνση email σας όταν δημιουργηθεί."),
                            content: Container(
                              height:10,
                            ),
                            actions: <Widget>[
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[

                                    RaisedButton.icon(
                                      onPressed: () {
                                        receptRequest();
                                        Navigator.push(context,
                                            CupertinoPageRoute(builder: (context) => editOrders()));
                                      },
                                      icon: Icon(Icons.check), label: Text("Ναί"),color: Colors.blue,
                                      textColor: Colors.white,
                                      disabledColor: Colors.blue,
                                      disabledTextColor: Colors.white,
                                      padding: EdgeInsets.fromLTRB(10,10,10,10),
                                      splashColor: Colors.blueAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(7.0),
                                      ),
                                    ),

                                  ]),
                            ],
                          );
                        }
                    );

                  }, // button pressed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.receipt_long, size: 18.0, color: Colors.black), // icon
                      Text("Recept", style: TextStyle(color: Colors.black87)), // text
                    ],
                  ),
                ),
              ),
            ):Container(),
          ]
      ),
      body:SingleChildScrollView(
          physics: ScrollPhysics(),
          child:Center(
              child: Column(
                  children: <Widget>[
                    Text('Οι παραγγελίες σας \n\r(' + orderComment + ')', style: TextStyle(fontSize: 20.0,color: Colors.black87,fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                    SizedBox(height: 20.0),
                    Text('Filters', style: TextStyle(fontSize: 15.0,color: Colors.black87,),textAlign: TextAlign.center,),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            child: Text('Σήμερα', style: TextStyle(fontSize: 12.0,color: Colors.black87,)),
                            onPressed: () {
                              orderListComplite = false;
                              timePeriodOrders = 0;
                              setState(() {});
                              _sendRequestOrdersList(filterOrders);
                            },
                          ),
                          FlatButton(
                            child: Text('Εχθές', style: TextStyle(fontSize: 12.0,color: Colors.black87,)),
                            onPressed: () {
                              orderListComplite = false;
                              timePeriodOrders = 1;
                              setState(() {});
                              _sendRequestOrdersList(filterOrders);
                            },
                          ),
                          FlatButton(

                            child: Text('Μήνας', style: TextStyle(fontSize: 12.0,color: Colors.black87,)),
                            onPressed: () {
                              orderListComplite = false;
                              timePeriodOrders = 2;
                              setState(() {});
                              _sendRequestOrdersList(filterOrders);
                            },
                          ),

                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FlatButton(
                            child: Text('Τέταρτο', style: TextStyle(fontSize: 12.0,color: Colors.black87,)),
                            onPressed: () {
                              orderListComplite = false;
                              timePeriodOrders = 3;
                              setState(() {});
                              _sendRequestOrdersList(filterOrders);
                            },
                          ),
                          FlatButton(
                            child: Text('Ετος', style: TextStyle(fontSize: 12.0,color: Colors.black87,)),
                            onPressed: () {
                              orderListComplite = false;
                              timePeriodOrders = 4;
                              setState(() {});
                              _sendRequestOrdersList(filterOrders);
                            },
                          ),
                          FlatButton(
                            child: Text('Τα παντα', style: TextStyle(fontSize: 12.0,color: Colors.black87,)),
                            onPressed: () {
                              orderListComplite = false;
                              timePeriodOrders = 5;
                              setState(() {});
                              _sendRequestOrdersList(filterOrders);
                            },
                          ),
                        ]),
                    SizedBox(height: 1.0, width: MediaQuery.of(context).size.width - 80,
                      child: const DecoratedBox(
                        decoration: const BoxDecoration(
                          color: Colors.black,
                        ),
                      ),),
                    //кнопки фильтра
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          isAdmin||isManager?FlatButton(
                            color: Colors.yellow,
                            textColor: Colors.black,
                            padding: EdgeInsets.all(8.0),
                            splashColor: Colors.blueAccent,
                            onPressed: () {orderListComplite = false; filterOrders = 0; setState(() {}); _sendRequestOrdersList(0); orderComment='Αποδεκτό';},
                            child: Text(
                              "Αποδεκτό",
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ):Container(),
                          isAdmin||isManager?FlatButton(
                            color: Colors.blue,
                            textColor: Colors.white,
                            padding: EdgeInsets.all(8.0),
                            splashColor: Colors.blueAccent,
                            onPressed: () {orderListComplite = false; filterOrders = 2; setState(() {}); _sendRequestOrdersList(2); orderComment='Προετοιμασία';},
                            child: Text(
                              "Προετοιμασία",
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ):Container(),
                          isAdmin||isManager?FlatButton(
                            color: Colors.lightGreenAccent,
                            textColor: Colors.black,
                            padding: EdgeInsets.all(8.0),
                            splashColor: Colors.blueAccent,
                            onPressed: () {orderListComplite = false; filterOrders = 3; setState(() {}); _sendRequestOrdersList(3); orderComment='Έτοιμο για έκδοση';},
                            child: Text(
                              "Έτοιμο για έκδοση",
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ):Container(),

                        ]),
                    isAdmin||isManager?Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            color: Colors.green,
                            textColor: Colors.white,
                            padding: EdgeInsets.all(8.0),
                            splashColor: Colors.blueAccent,
                            onPressed: () {orderListComplite = false; filterOrders = 4; setState(() {}); _sendRequestOrdersList(4); orderComment='Ολοκληρώθηκε';},
                            child: Text(
                              "Ολοκληρώθηκε",
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ),
                          FlatButton(
                            color: Colors.red,
                            textColor: Colors.black,
                            padding: EdgeInsets.all(8.0),
                            splashColor: Colors.blueAccent,
                            onPressed: () {orderListComplite = false;filterOrders = 1; setState(() {}); _sendRequestOrdersList(1); orderComment='Ακυρώθηκε';},
                            child: Text(
                              "Ακυρώθηκε",
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ),
                        ]):Container(),
                    SizedBox(height: 20.0),
                    //конец кнопок фильтра
                    orderListComplite?ListView.builder(
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
                                                parsedJsonHistory[index]['deliveryType'] == 2?Text('Κράτηση:\n', style: TextStyle(fontSize: 12.0,color: Colors.black87)):parsedJsonHistory[index]['deliveryType'] == 3?Text('Ελάτε για\n παραγγελία: ', style: TextStyle(fontSize: 12.0,color: Colors.black87)):Text('Αναμονή\nπαράδοσης', style: TextStyle(fontSize: 12.0,color: Colors.black87)),

                                                parsedJsonHistory[index]['deliveryType'] == 2 || parsedJsonHistory[index]['deliveryType'] == 3?Text('${parsedJsonHistory[index]['dateOrder']}', style: TextStyle(fontSize: 12.0,color: Colors.black87)):Text(''),
                                                parsedJsonHistory[index]['deliveryType'] == 3?Text('  ${parsedJsonHistory[index]['timeOrder']}', style: TextStyle(fontSize: 12.0,color: Colors.black87,)):Text(''),
                                              ]),
                                          parsedJsonHistory[index]['deliveryType'] == 1?Container(margin: EdgeInsets.fromLTRB(10,0,10,0),child:Icon(Icons.local_shipping, size: 30.0,))
                                              :parsedJsonHistory[index]['deliveryType'] == 2?Container(margin: EdgeInsets.fromLTRB(10,0,10,0),child:Icon(Icons.directions_run,size: 30.0,))
                                              :parsedJsonHistory[index]['deliveryType'] == 3?Container(margin: EdgeInsets.fromLTRB(10,0,10,0),child:Icon(Icons.local_dining , size: 30.0,))
                                              :Container(),
                                          //Container(
                                          //  width: 140,
                                          Expanded(
                                              child: Text('${parsedJsonHistory[index]['client']}', style: TextStyle(fontSize: 20.0,color: Colors.black87,))
                                          ),
                                        ]
                                    ),
                                  ),
                                  Text('Ordered: ${parsedJsonHistory[index]['ratingOrdered']} Rjected: ${parsedJsonHistory[index]['ratingRejected']}', style: TextStyle(fontSize: 15.0,color: Colors.black87,),textAlign: TextAlign.center,),

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
                                  SizedBox(height: 10.0),
                                  SizedBox(height: 1.0, width: MediaQuery.of(context).size.width - 80,
                                    child: const DecoratedBox(
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                      ),
                                    ),),
                                 SizedBox(height: 10.0),
                                  RaisedButton.icon(
                                    onPressed: (){
                                      messageListComplite = false;
                                      msgcount = 0;
                                      toIn = parsedJsonHistory[index]['clientID'];
                                      setState(() {});
                                      Navigator.push(context,
                                          CupertinoPageRoute(builder: (context) => messenger()));

                                    },
                                    icon: Icon(Icons.message), label: Text("Send message"),color: Colors.green,
                                    textColor: Colors.white,
                                    disabledColor: Colors.blue,
                                    disabledTextColor: Colors.white,
                                    padding: EdgeInsets.fromLTRB(50,10,50,10),
                                    splashColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                    ),
                                  ),
                                  //Icon(Icons.phone),
                                  SizedBox(height: 10.0),
                                  GestureDetector(
                                      onTap: () {
                                        callClient(parsedJsonHistory[index]['clientPhone']);
                                      },
                                      child:
                                      Text(parsedJsonHistory[index]['clientPhone'],
                                          style: TextStyle(fontSize: 17.0,color: Colors.blue,))),

                                  //Icon(Icons.local_post_office),
                                  SizedBox(height: 10.0),
                                  Text(parsedJsonHistory[index]['clientAddress'],
                                      style: TextStyle(fontSize: 17.0,color: Colors.black87,)),

                                  SizedBox(height: 10.0),
                                  SizedBox(height: 1.0, width: MediaQuery.of(context).size.width - 80,
                                    child: const DecoratedBox(
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                      ),
                                    ),),
                                  SizedBox(height: 10.0),
                                  //кнопочки
                                  //если побрабатывается то или принять или отклонить
                                  parsedJsonHistory[index]['statusOrder'] == 0?Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        FlatButton(
                                          color: Colors.red,
                                          textColor: Colors.black,
                                          padding: EdgeInsets.all(8.0),
                                          splashColor: Colors.blueAccent,
                                          onPressed: () {_turnOrder(parsedJsonHistory[index]['orderId'],1); orderComment='Ακυρώθηκε';},
                                          child: Text(
                                            "Ακυρώθηκε",
                                            style: TextStyle(fontSize: 12.0),
                                          ),
                                        ),
                                        FlatButton(
                                          color: Colors.blue,
                                          textColor: Colors.black,
                                          padding: EdgeInsets.all(8.0),
                                          splashColor: Colors.blueAccent,
                                          onPressed: () {_turnOrder(parsedJsonHistory[index]['orderId'],2); orderComment='Προετοιμασία';},
                                          child: Text(
                                            "Προετοιμασία",
                                            style: TextStyle(fontSize: 12.0),
                                          ),
                                        ),
                                      ]):
                                  //если готовится, то передать в доставку
                                  parsedJsonHistory[index]['statusOrder'] == 2?
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        FlatButton(
                                          color: Colors.red,
                                          textColor: Colors.black,
                                          padding: EdgeInsets.all(8.0),
                                          splashColor: Colors.blueAccent,
                                          onPressed: () {_turnOrder(parsedJsonHistory[index]['orderId'],1); orderComment='Ακυρώθηκε';},
                                          child: Text(
                                            "Ακυρώθηκε",
                                            style: TextStyle(fontSize: 12.0),
                                          ),
                                        ),
                                        FlatButton(
                                          color: Colors.lightGreenAccent,
                                          textColor: Colors.black,
                                          padding: EdgeInsets.all(8.0),
                                          splashColor: Colors.blueAccent,
                                          onPressed: () {_turnOrder(parsedJsonHistory[index]['orderId'],3); orderComment='Έτοιμο για έκδοση';},
                                          child: Text(
                                            "Έτοιμο για έκδοση",
                                            style: TextStyle(fontSize: 12.0),
                                          ),
                                        )]):
                                  //если доставляется, то завершить
                                  parsedJsonHistory[index]['statusOrder'] == 3?
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        FlatButton(
                                          color: Colors.red,
                                          textColor: Colors.black,
                                          padding: EdgeInsets.all(8.0),
                                          splashColor: Colors.blueAccent,
                                          onPressed: () {_turnOrder(parsedJsonHistory[index]['orderId'],1); orderComment='Ακυρώθηκε';},
                                          child: Text(
                                            "Ακυρώθηκε",
                                            style: TextStyle(fontSize: 12.0),
                                          ),
                                        ),
                                        FlatButton(
                                          color: Colors.green,
                                          textColor: Colors.white,
                                          padding: EdgeInsets.all(8.0),
                                          splashColor: Colors.blueAccent,
                                          onPressed: () {_turnOrder(parsedJsonHistory[index]['orderId'],4); orderComment='Ολοκληρώθηκε';},
                                          child: Text(
                                            "Ολοκληρώθηκε",
                                            style: TextStyle(fontSize: 12.0),
                                          ),
                                        )]):Container(),

                                  SizedBox(height: 20.0),
                                ]
                            )
                                :Container(
                                child:Text('\nΔεν υπάρχουν παραγγελίες που απαιτούν δράση\n', style: TextStyle(fontSize: 20.0,color: Colors.black87),textAlign: TextAlign.center,)
                            ),
                          );
                        }
                    ):Container(
                        width: 50.0,
                        height: 50.0,
                        margin: EdgeInsets.fromLTRB(10,50,0,0),
                        child:CircularProgressIndicator(strokeWidth: 4.0,
                          valueColor : AlwaysStoppedAnimation(Colors.green),)) // отображаем что-то пока история грузится

                  ]))),
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
