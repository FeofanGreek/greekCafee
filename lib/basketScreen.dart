import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:greek_cafe/profileScreen.dart';
import 'package:jiffy/jiffy.dart';
import 'package:http/http.dart' as http;


import 'historyScreen.dart';
import 'main.dart';


final List<String> CartName = [];
final List<String> CartIngri = [];
final List<int> CartValue = [];
final List<int> CartValueFull = [];
final List<double> CartPrice = [];
final List<double> CartPriceFull = [];
final List<int> CartId = [];

String methodDelivery = "Διεύθυνση παράδοσης";
String dateDelivery = "Ορίστε ημερομηνία";
String dateDeliverySend = "";
String timeDelivery = "Ορίστε ώρα";
int deliveryType = 1;
bool sendBascket = true;



class CartView extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

//для тайм пикера без секунд
class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime currentTime, LocaleType locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }

  @override
  String leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "";
  }

  @override
  String rightDivider() {
    return ":";
  }

  @override
  List<int> layoutProportions() {
    return [1, 1, 0];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        this.currentLeftIndex(),
        this.currentMiddleIndex(),
        this.currentRightIndex())
        : DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        this.currentLeftIndex(),
        this.currentMiddleIndex(),
        this.currentRightIndex());
  }
}// для таймпикера без секунд

class _CartScreenState extends State<CartView> {

  bool isClosed = false;
  bool isClosed2 = false;


  void Closed(int typeDev) {
    if((typeDev == 1) || (typeDev == 2)){
      setState(() {
        isClosed = true;
      });
    } else {setState(() {
      isClosed = false;
    });}
    if(typeDev == 2){setState(() {
      isClosed2 = true;
    });} else {setState(() {
      isClosed2 = false;
    });}
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
          ProfileComplite?Container(
            margin: EdgeInsets.fromLTRB(0,0,10,0),
            child: Material(
              color: Colors.white, // button color
              child: InkWell(
                splashColor: Colors.green, // splash color
                onTap: () { Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => HistoryView()));}, // button pressed
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.history, size: 18.0, color: Colors.black), // icon
                    Text("History", style: TextStyle(color: Colors.black87)), // text
                  ],
                ),
              ),
            ),
          ):Container(),
        ],
      ),
      body:SingleChildScrollView(
          physics: ScrollPhysics(),
          child:Center(

              child: Column(
                  children: <Widget>[
                   Text('Προεπιλογή', style: TextStyle(fontSize: 20.0,color: Colors.black87,fontWeight: FontWeight.bold,)),
                    Transform.rotate(
                        angle: 3.1458,
                        child:Container(
                          child:Image.asset('images/spaceImage.png',   fit:BoxFit.fill,),
                          alignment: Alignment(0.00, 0.0),
                          padding: EdgeInsets.fromLTRB(0,0,0,5),
                        )),
                    SizedBox(height: 20.0),
                     ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: CartValue.length,
                        itemBuilder: (BuildContext context, int index) {

                          return Container(
                              child: Column(
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.fromLTRB(50,0,10,5),
                                        alignment: Alignment(-1.0, 0.0),
                                        child:Text('${CartName[index]}', style: TextStyle(fontSize: 20.0,color: Colors.black87,fontWeight: FontWeight.bold,))),
                                    Container(
                                        margin: EdgeInsets.fromLTRB(50,0,10,10),
                                        alignment: Alignment(-1.0, 0.0),
                                        child:Text('${CartIngri[index]}', style: TextStyle(fontSize: 17.0,color: Colors.black87,))),
                                    CartValue[index]!=0?Text('Ένα μέρος', style: TextStyle(fontSize: 14.0,color: Colors.black87,)):Container(),
                                    CartValue[index]!=0?Row(
                                        children: <Widget>[
                                          Container(
                                              margin: EdgeInsets.fromLTRB(50,0,0,10),
                                              padding: EdgeInsets.fromLTRB(0,8,0,0),
                                              alignment: Alignment(-1.0, 0.0),
                                              child:Text('${CartPrice[index].toString()}€ ', style: TextStyle(fontSize: 20.0,color: Colors.black87,fontWeight: FontWeight.bold,))),

                                          ButtonTheme(
                                          minWidth: 20,
                                              child: FlatButton.icon(icon: Icon(Icons.add), label: Text(""),
                                                textColor: Colors.green,
                                                disabledColor: Colors.blue,
                                                disabledTextColor: Colors.green,
                                                //padding: EdgeInsets.fromLTRB(0,20,100,10),
                                                splashColor: Colors.blueAccent,
                                                onPressed: (){
                                                      ChangeValuePlus(CartId[index]);
                                                      CartValue[index]++;
                                                      setState(() {});
                                                            },
                                              ),
                                          ),
                                          Text('${CartValue[index]}', style: TextStyle(fontSize: 20.0,color: Colors.black87,fontWeight: FontWeight.bold,)),
                                          ButtonTheme(
                                            minWidth: 20,
                                              child: FlatButton.icon(icon: Icon(Icons.remove), label: Text(""),
                                                textColor: Colors.redAccent,
                                                disabledColor: Colors.blue,
                                                disabledTextColor: Colors.redAccent,
                                                splashColor: Colors.blueAccent,
                                                onPressed: (){
                                                if(CartValue[index] > 0) {
                                                  ChangeValueMinus(CartId[index]);
                                                  CartValue[index]--;
                                                  setState(() {});
                                                }
                                                      },
                                              ),
                                          ),
                                          ButtonTheme(
                                             minWidth: 20,

                                              child: FlatButton.icon(icon: Icon(Icons.clear), label: Text(""),
                                                textColor: Colors.grey,
                                                disabledColor: Colors.blue,
                                                disabledTextColor: Colors.grey,
                                                splashColor: Colors.blueAccent,

                                                onPressed: (){
                                                  DellBlude(CartId[index]);
                                                  CartValue[index]=0;
                                                  setState(() {});
                                                  PrintBasket ();
                                                },
                                              ),
                                          ),
                                        ]): Container(),
                                    CartValueFull[index]!=0?Text('Πλήρες πιάτο', style: TextStyle(fontSize: 14.0,color: Colors.black87,)):Container(),
                                    CartValueFull[index]!=0?Row(
                                        children: <Widget>[
                                          Container(
                                              margin: EdgeInsets.fromLTRB(50,0,0,10),
                                              padding: EdgeInsets.fromLTRB(0,8,0,0),
                                              alignment: Alignment(-1.0, 0.0),
                                              child:Text('${CartPriceFull[index].toString()}€ ', style: TextStyle(fontSize: 20.0,color: Colors.black87,fontWeight: FontWeight.bold,))),

                                          ButtonTheme(
                                            minWidth: 20,
                                            child: FlatButton.icon(icon: Icon(Icons.add), label: Text(""),
                                              textColor: Colors.green,
                                              disabledColor: Colors.blue,
                                              disabledTextColor: Colors.green,
                                              //padding: EdgeInsets.fromLTRB(0,20,100,10),
                                              splashColor: Colors.blueAccent,
                                              onPressed: (){
                                                ChangeValueFullPlus(CartId[index]);
                                                CartValueFull[index]++;
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                          Text('${CartValueFull[index]}', style: TextStyle(fontSize: 20.0,color: Colors.black87,fontWeight: FontWeight.bold,)),
                                          ButtonTheme(
                                            minWidth: 20,
                                            child: FlatButton.icon(icon: Icon(Icons.remove), label: Text(""),
                                              textColor: Colors.redAccent,
                                              disabledColor: Colors.blue,
                                              disabledTextColor: Colors.redAccent,
                                              splashColor: Colors.blueAccent,
                                              onPressed: (){
                                                if(CartValueFull[index] > 0) {
                                                  ChangeValueFullMinus(CartId[index]);
                                                  CartValueFull[index]--;
                                                  setState(() {});
                                                }
                                              },
                                            ),
                                          ),
                                          ButtonTheme(
                                            minWidth: 20,

                                            child: FlatButton.icon(icon: Icon(Icons.clear), label: Text(""),
                                              textColor: Colors.grey,
                                              disabledColor: Colors.blue,
                                              disabledTextColor: Colors.grey,
                                              splashColor: Colors.blueAccent,

                                              onPressed: (){
                                                DellBludeFull(CartId[index]);
                                                CartValueFull[index]=0;
                                                setState(() {});
                                                PrintBasket ();
                                              },
                                            ),
                                          ),
                                        ]): Container(),
                                    SizedBox(height: 5.0),
                                    SizedBox(height: 2.0, width: MediaQuery.of(context).size.width - 50,
                                      child: const DecoratedBox(
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                        ),
                                      ),),
                                    SizedBox(height: 20.0),
                                  ]
                              )
                          );
                        }
                    ),
                    Text('Συνολικό ποσό ${double.parse((eatTotalPriceList.toStringAsFixed(2)))}€ ', style: TextStyle(fontSize: 20.0,color: Colors.black87,fontWeight: FontWeight.bold,)),
                    Transform.rotate(
                        angle: 3.1458,
                        child:Container(
                          child:Image.asset('images/spaceImage.png',   fit:BoxFit.fill,),
                          alignment: Alignment(0.00, 0.0),
                          padding: EdgeInsets.fromLTRB(0,0,0,5),
                        )),
                    Text('Μέθοδος λήψης', style: TextStyle(fontSize: 18.0,color: Colors.black87,fontWeight: FontWeight.bold,)),
                    SizedBox(height: 10.0),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                            ButtonTheme(
                              minWidth: 20,
                              child: FlatButton.icon(icon: Icon(Icons.local_shipping, size: 42.0,), label: Text(""),
                                textColor: !isClosed & !isClosed2 ? Colors.blue : Colors.grey,
                                disabledColor: Colors.blue,
                                disabledTextColor: Colors.green,
                                padding: EdgeInsets.fromLTRB(10,0,0,0),
                                splashColor: Colors.blueAccent,
                                onPressed: (){Closed(0); methodDelivery = "Διεύθυνση παράδοσης";},
                              ),
                            ),
                              Text('Διανομή', style: TextStyle(fontSize: 12.0,color: Colors.black87)),
                          ]),
                          Column(
                              children: <Widget>[
                                ButtonTheme(
                                  minWidth: 20,
                                  child: FlatButton.icon(icon: Icon(Icons.directions_run,size: 42.0,), label: Text(""),
                                    textColor: isClosed & !isClosed2 ? Colors.blue : Colors.grey,
                                    //textColor: Colors.green,
                                    disabledColor: Colors.blue,
                                    disabledTextColor: Colors.green,
                                    padding: EdgeInsets.fromLTRB(12,0,0,0),
                                    splashColor: Colors.blueAccent,
                                    onPressed: (){Closed(1);methodDelivery = "Η ημερομηνία και η ώρα θα διαρκέσουν";deliveryType = 2;},
                                  ),
                                ),
                                Text('Παίρνω', style: TextStyle(fontSize: 12.0,color: Colors.black87)),
                              ]),
                          Column(
                              children: <Widget>[
                                ButtonTheme(
                                  minWidth: 20,
                                  child: FlatButton.icon(icon: Icon(Icons.local_dining , size: 42.0,), label: Text(""),
                                    textColor: isClosed & isClosed2 ? Colors.blue : Colors.grey,
                                    disabledColor: Colors.blue,
                                    disabledTextColor: Colors.green,
                                    padding: EdgeInsets.fromLTRB(8,0,0,0),
                                    splashColor: Colors.blueAccent,
                                    onPressed: (){Closed(2);methodDelivery = "Πίνακας αποθεματικών ημερομηνίας και ώρας";deliveryType = 3;},
                                  ),
                                ),
                                Text('Αποθεματικό', style: TextStyle(fontSize: 12.0,color: Colors.black87)),
                              ]),
                        ]),
                    SizedBox(height: 20.0),
                    Text('Τα δεδομένα σου', style: TextStyle(fontSize: 18.0,color: Colors.black87,fontWeight: FontWeight.bold,)),
                    Container(
                        child: TextFormField(
                          initialValue: "$Uname",
                          decoration: InputDecoration(hintText: "Το όνομα σου", focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.blue,
                          ),
                        ), enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),), /*validator: (value){if (value.isEmpty) return 'Логин не введен';}, */
                            onChanged: (value){Uname = value;},
                            autovalidate: true),
                        padding: EdgeInsets.fromLTRB(40,10,40,5)
                    ),
                    Container(
                          padding: EdgeInsets.fromLTRB(20,20,20,10),

                          child: Text('$methodDelivery', style: TextStyle(fontSize: 18.0,color: Colors.black87,fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                    ),
                        !isClosed?Container(
                        child: TextFormField(
                            initialValue: "$Uaddress",
                            maxLines: 3,
                            decoration: InputDecoration(hintText: "Διεύθυνση παράδοσης", focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.blue,
                          ),
                        ), enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),), /*validator: (value){if (value.isEmpty) return 'Логин не введен';},*/
                            // ignore: deprecated_member_use
                            onChanged: (value){Uaddress = value;},autovalidate: true ),
                        padding: EdgeInsets.fromLTRB(40,10,40,5)
                    ):Column(
                      children: <Widget>[
                      isClosed2?FlatButton(
                          onPressed: () {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime.now(),
                                maxTime: Jiffy(DateTime.now()).add(years: 3),
                                onChanged: (date) {}, onConfirm: (date) {
                                  String monthBolb = '';
                                  String dayBolb = '';
                                  if(date.month < 10){monthBolb = '0';}
                                  if(date.day < 10){dayBolb = '0';}
                                  dateDelivery = dayBolb + date.day.toString()+"."+ monthBolb + date.month.toString()+"."+ date.year.toString();
                                  dateDeliverySend = date.year.toString()+"." + date.month.toString()+"." + date.day.toString();
                                  setState(() {});
                                }, currentTime: DateTime.now(), locale: LocaleType.en);

                          },
                          child: Text(
                            '$dateDelivery',
                            //style: TextStyle(color: Colors.green),
                            style: TextStyle(fontSize: 18.0,color: Colors.green,fontWeight: FontWeight.bold,),
                          )):Container(),
                        FlatButton(
                            onPressed: () {
                              DatePicker.showPicker(context, showTitleActions: true, onChanged: (date) {}, onConfirm: (date) {
                                String minuteBolb = '';
                                String hourBolb = '';
                                if(date.minute < 10){minuteBolb = '0';}
                                if(date.hour < 10){hourBolb = '0';}
                                timeDelivery = hourBolb + date.hour.toString()+":" + minuteBolb + date.minute.toString();
                                setState(() {});
                              }, pickerModel: CustomPicker(currentTime: DateTime.now()),
                                  locale: LocaleType.en);

                            },
                            child: Text(
                              '$timeDelivery',
                              //style: TextStyle(color: Colors.green),
                              style: TextStyle(fontSize: 18.0,color: Colors.green,fontWeight: FontWeight.bold,),
                            )),

                    ]),
                    SizedBox(height: 10.0),
                    sendBascket?RaisedButton.icon(
                      onPressed: (){
                        sendBascket = false; setState(() {});
                        if(dateDeliverySend == ''){dateDeliverySend = DateTime.now().year.toString()+"." + DateTime.now().month.toString()+"." + DateTime.now().day.toString();}
                        if(timeDelivery == "Ορίστε ώρα"){timeDelivery = DateTime.now().hour.toString()+":" + DateTime.now().minute.toString()+":00";}
                        updateProfile();
                        // сюда вставляем отправку заказа на сервер
                        makeOrder();
                        },
                      icon: Icon(Icons.send),
                      label: Text("Σειρά"),
                      color: Colors.blue,
                      textColor: Colors.white,
                      disabledColor: Colors.blue,
                      disabledTextColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(50,10,50,10),
                      splashColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0),
                      ),

                    ):Container(
                        width: 50.0,
                        height: 50.0,
                        margin: EdgeInsets.fromLTRB(10,50,0,0),
                        child:CircularProgressIndicator(strokeWidth: 4.0,
                          valueColor : AlwaysStoppedAnimation(Colors.green),)),
                    SizedBox(height: 20.0),
                    Container(
                      child:Image.asset('images/bonApetit.png',  height: 120, fit:BoxFit.fill,),
                      alignment: Alignment(0.00, 0.0),
                      padding: EdgeInsets.fromLTRB(0,0,0,5),
                    ),

                  ]))),
    );
  }

  makeOrder() async {

    try {
      var response = await http.post('https://koldashev.ru/GreekCafeAPI.php',
          headers: {"Accept": "application/json"},
          body: jsonEncode(<String, dynamic>{
            "login": "$IdRestaurant",
            "subject" : "makeOrder",
            "client" : "$Uname", // желательно для общения
            "clientPhone" : "$Uphone", // сейчас используем как ИД пользователя
            "clientAddress" : "$Uaddress", // нужно для доставки
            "orderDate" : "$dateDeliverySend", // нужно
            "orderTime" : "$timeDelivery",//нужно
            "deliveryType" : "$deliveryType", //тип доставки блюда
            "bludeID" : CartId, // ИД блюда
            "bludeValue" : CartValue, // количесвто стандартных порций
            "bludeValueFull" : CartValueFull, // количество полных порций
            "bludePrice" : CartPrice, // фиксируем цену для дальнейшего разбирательства
            "bludePriceFull" : CartPriceFull // фиксируем полную цену для дальнейшего разбирательства
          })
      );
      CartName.clear();
      CartIngri.clear();
      CartValue.clear();
      CartPrice.clear();
      CartValueFull.clear();
      CartPriceFull.clear();
      CartId.clear();
      eatTotalPriceList = 0.00;
      NullingMenu ();
      textMainScreen = 'Ευχαριστώ! Η παραγγελία σας έχει ήδη αρχίσει να προετοιμάζεται.\n\n Κατά τη διάρκεια της προετοιμασίας και της παράδοσης, θα σας ειδοποιήσουμε.';
          Navigator.push(context,
          CupertinoPageRoute(builder: (context) => MainScreen()));
            print(response.body);
    } catch (error) {}

  }

}

NullingMenu (){
  var oneCount = parsedJson[0]['menuClient'].length;
  for(int i=0; i < oneCount; i++) {
    var twoCount = parsedJson[0]['menuClient'][i]['groupMember'].length;
    for(int ii=0; ii < twoCount; ii++) {
        parsedJson[0]['menuClient'][i]['groupMember'][ii]['value']=0;
        parsedJson[0]['menuClient'][i]['groupMember'][ii]['valueFull']=0;
    }
  }

}

PrintBasket (){
  CartName.clear();
  CartIngri.clear();
  CartValue.clear();
  CartValueFull.clear();
  CartPrice.clear();
  CartPriceFull.clear();
  CartId.clear();
  var oneCount = parsedJson[0]['menuClient'].length;
  for(int i=0; i < oneCount; i++) {
    var twoCount = parsedJson[0]['menuClient'][i]['groupMember'].length;
    for(int ii=0; ii < twoCount; ii++) {
      if((parsedJson[0]['menuClient'][i]['groupMember'][ii]['value'] > 0) || (parsedJson[0]['menuClient'][i]['groupMember'][ii]['valueFull'] > 0)) {
        CartPrice.add(parsedJson[0]['menuClient'][i]['groupMember'][ii]['priceBlude'].toDouble());
        CartPriceFull.add(parsedJson[0]['menuClient'][i]['groupMember'][ii]['priceBludeFull'].toDouble());
        CartValue.add(parsedJson[0]['menuClient'][i]['groupMember'][ii]['value']);
        CartValueFull.add(parsedJson[0]['menuClient'][i]['groupMember'][ii]['valueFull']);
        CartName.add(parsedJson[0]['menuClient'][i]['groupMember'][ii]['nameBlude']);
        CartIngri.add(parsedJson[0]['menuClient'][i]['groupMember'][ii]['ingridientBlude']);
        CartId.add(parsedJson[0]['menuClient'][i]['groupMember'][ii]['id_blude']);
      }

     }
  }

}

ChangeValueMinus(int idBl){
  var oneCount = parsedJson[0]['menuClient'].length;
  for(int i=0; i < oneCount; i++) {
    var twoCount = parsedJson[0]['menuClient'][i]['groupMember'].length;
    for(int ii=0; ii < twoCount; ii++) {
      if(parsedJson[0]['menuClient'][i]['groupMember'][ii]['id_blude'] == idBl) {
            parsedJson[0]['menuClient'][i]['groupMember'][ii]['value']--;
            eatTotalPriceList = eatTotalPriceList - parsedJson[0]['menuClient'][i]['groupMember'][ii]['priceBlude'];
      }
    }
  }
}
ChangeValuePlus(int idBl){
  var oneCount = parsedJson[0]['menuClient'].length;
  for(int i=0; i < oneCount; i++) {
    var twoCount = parsedJson[0]['menuClient'][i]['groupMember'].length;
    for(int ii=0; ii < twoCount; ii++) {
      if(parsedJson[0]['menuClient'][i]['groupMember'][ii]['id_blude'] == idBl) {
        parsedJson[0]['menuClient'][i]['groupMember'][ii]['value']++;
        eatTotalPriceList = eatTotalPriceList + parsedJson[0]['menuClient'][i]['groupMember'][ii]['priceBlude'];
      }
    }
  }
}
DellBlude(int idBl){
  var oneCount = parsedJson[0]['menuClient'].length;
  for(int i=0; i < oneCount; i++) {
    var twoCount = parsedJson[0]['menuClient'][i]['groupMember'].length;
    for(int ii=0; ii < twoCount; ii++) {
      if(parsedJson[0]['menuClient'][i]['groupMember'][ii]['id_blude'] == idBl) {
        eatTotalPriceList = eatTotalPriceList - (parsedJson[0]['menuClient'][i]['groupMember'][ii]['priceBlude'] * parsedJson[0]['menuClient'][i]['groupMember'][ii]['value']);
        parsedJson[0]['menuClient'][i]['groupMember'][ii]['value']=0;
      }
    }
  }
}
ChangeValueFullMinus(int idBl){
  var oneCount = parsedJson[0]['menuClient'].length;
  for(int i=0; i < oneCount; i++) {
    var twoCount = parsedJson[0]['menuClient'][i]['groupMember'].length;
    for(int ii=0; ii < twoCount; ii++) {
      if(parsedJson[0]['menuClient'][i]['groupMember'][ii]['id_blude'] == idBl) {
        parsedJson[0]['menuClient'][i]['groupMember'][ii]['valueFull']--;
        eatTotalPriceList = eatTotalPriceList - parsedJson[0]['menuClient'][i]['groupMember'][ii]['priceBludeFull'];
      }
    }
  }
}
ChangeValueFullPlus(int idBl){
  var oneCount = parsedJson[0]['menuClient'].length;
  for(int i=0; i < oneCount; i++) {
    var twoCount = parsedJson[0]['menuClient'][i]['groupMember'].length;
    for(int ii=0; ii < twoCount; ii++) {
      if(parsedJson[0]['menuClient'][i]['groupMember'][ii]['id_blude'] == idBl) {
        parsedJson[0]['menuClient'][i]['groupMember'][ii]['valueFull']++;
        eatTotalPriceList = eatTotalPriceList + parsedJson[0]['menuClient'][i]['groupMember'][ii]['priceBludeFull'];
      }
    }
  }
}
DellBludeFull(int idBl){
  var oneCount = parsedJson[0]['menuClient'].length;
  for(int i=0; i < oneCount; i++) {
    var twoCount = parsedJson[0]['menuClient'][i]['groupMember'].length;
    for(int ii=0; ii < twoCount; ii++) {
      if(parsedJson[0]['menuClient'][i]['groupMember'][ii]['id_blude'] == idBl) {
        eatTotalPriceList = eatTotalPriceList - (parsedJson[0]['menuClient'][i]['groupMember'][ii]['priceBludeFull'] * parsedJson[0]['menuClient'][i]['groupMember'][ii]['valueFull']);
        parsedJson[0]['menuClient'][i]['groupMember'][ii]['valueFull']=0;
      }
    }
  }
}

