
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greek_cafe/profileScreen.dart';

import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'editOrders.dart';
import 'main.dart';

var parsedJsonStaffList;
bool staffListComplite = false;

class manageStaff extends StatefulWidget {


  @override
  _manageStaffState createState() => _manageStaffState();
}

class _manageStaffState extends State<manageStaff> {


  var _controllerSearchPhone = TextEditingController();
  var maskFormatterPhone = new MaskTextInputFormatter(mask: '+## (###) ###-##-##', filter: { "#": RegExp(r'[0-9]') });

  @override
  void initState() {
    super.initState();
    _staffList();
  }

  editStaff(user, role) async {
    try {

      if(isAdmin) {
      var response = await http.post('https://koldashev.ru/GreekCafeAPI.php',
          headers: {"Accept": "application/json"},
          body: jsonEncode(<String, dynamic>{
            "login": "$IdRestaurant",
            "user" : "$user",
            "role" : role,
            "subject": "editStaff"
          })
      );
      }
    } catch (error) {}
    Navigator.push(context,
        CupertinoPageRoute(builder: (context) => manageStaff()));
  }

  @override
  searchStaff(user) async {
    //print(user);
    try {

      if(isAdmin) {
        var response = await http.post('https://koldashev.ru/GreekCafeAPI.php',
            headers: {"Accept": "application/json"},
            body: jsonEncode(<String, dynamic>{
              "login": "$IdRestaurant",
              "user" : "$user",
              "subject": "searchStaff"
            })
        );
        var jsonStaffList = response.body;
        parsedJsonStaffList = json.decode(jsonStaffList);
      }
    } catch (error) {}

    staffListComplite = true;
    setState(() {});
  }

  _staffList() async {
    try {

      if(isAdmin) {
        var response = await http.post('https://koldashev.ru/GreekCafeAPI.php',
            headers: {"Accept": "application/json"},
            body: jsonEncode(<String, dynamic>{
              "login": "$IdRestaurant",
              "subject": "staffList"
            })
        );

        var jsonStaffList = response.body;
        parsedJsonStaffList = json.decode(jsonStaffList);
        }
    } catch (error) {
      //print(error);
    }
    staffListComplite = true;
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
                orderListComplite = false;
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => editOrders()));}, // button pressed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.playlist_add_check, size: 18.0, color: Colors.black), // icon
                  Text("Orders", style: TextStyle(color: Colors.black87)), // text
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
                    Text('Staff controlling', style: TextStyle(fontSize: 20.0,color: Colors.black87,fontWeight: FontWeight.bold,)),
                    SizedBox(height: 20.0),

                    //форма поиска
                    //при вводе номера по достижении 10 цифр искать и выводить список, его можно отредактить на условия
                    Container(
                        margin: EdgeInsets.fromLTRB(30,0,30,30),
                             child:TextFormField(
                                  enabled: true,
                                  inputFormatters: [maskFormatterPhone],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(hintText: "Κινητό τηλέφωνο",
                                    suffixIcon: IconButton(
                                      onPressed: () => _controllerSearchPhone.clear(),
                                      icon: Icon(Icons.clear),
                                    ),
                                    focusedBorder: OutlineInputBorder(
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
                                  ),), validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Συμπληρώστε την ενότητα Κινητό τηλέφωνο';
                                  }
                                  return null;
                                },
                                  onChanged: (value){
                                    if((value.length>16) & (value.length<19)){
                                      //функция поиска без опций администрирования
                                      searchStaff(value);
                                      }
                                    },
                                  // ignore: deprecated_member_use
                                  autovalidate: true,
                                  controller: _controllerSearchPhone,
                                ),

                      ),
                    SizedBox(height: 1.0, width: MediaQuery.of(context).size.width - 80,
                      child: const DecoratedBox(
                        decoration: const BoxDecoration(
                          color: Colors.black,
                        ),
                      ),),
                    //форма поиска
                    staffListComplite?ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: parsedJsonStaffList.length,
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
                              child: parsedJsonStaffList[index]['iduser']!=0?Column(
                                  children: <Widget>[
                                    SizedBox(height: 20.0),
                                    Container(
                                      child: Text('${parsedJsonStaffList[index]['name']}', style: TextStyle(fontSize: 20.0,color: Colors.black87)),
                                    ),
                                 Column(
                                      children: <Widget>[
                                    SizedBox(height: 1.0, width: MediaQuery.of(context).size.width - 80,
                                      child: const DecoratedBox(
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                        ),
                                      ),),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(20,10,20,10),
                                                  child:Text('${parsedJsonStaffList[index]['phone']}', style: TextStyle(fontSize: 20.0,color: Colors.black87),textAlign: TextAlign.center,),
                                    ),
                                    SizedBox(height: 1.0, width: MediaQuery.of(context).size.width - 80,
                                      child: const DecoratedBox(
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                        ),
                                      ),),
                                        Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Column(
                                              children: <Widget>[
                                                ButtonTheme(
                                                  minWidth: 20,
                                                  child: FlatButton.icon(icon: Icon(Icons.local_shipping, size: 42.0,), label: Text(""),
                                                    textColor: parsedJsonStaffList[index]['deliver'] == 1 ? Colors.blue : Colors.grey,
                                                    disabledColor: Colors.blue,
                                                    disabledTextColor: Colors.green,
                                                    padding: EdgeInsets.fromLTRB(10,0,0,0),
                                                    splashColor: Colors.blueAccent,
                                                    onPressed: (){
                                                      //parsedJsonStaffList[index]['buttonClick'] =0;
                                                    editStaff(parsedJsonStaffList[index]['iduser'], 1);
                                                    },
                                                  ),
                                                ),
                                                Text('Deliver', style: TextStyle(fontSize: 12.0,color: Colors.black87)),
                                              ]),
                                          Column(
                                              children: <Widget>[
                                                ButtonTheme(
                                                  minWidth: 20,
                                                  child: FlatButton.icon(icon: Icon(Icons.directions_run,size: 42.0,), label: Text(""),
                                                    textColor: parsedJsonStaffList[index]['manager'] == 1 ? Colors.blue : Colors.grey,
                                                    disabledColor: Colors.blue,
                                                    disabledTextColor: Colors.green,
                                                    padding: EdgeInsets.fromLTRB(12,0,0,0),
                                                    splashColor: Colors.blueAccent,
                                                    onPressed: (){
                                                      //parsedJsonStaffList[index]['buttonClick'] =0;
                                                    editStaff(parsedJsonStaffList[index]['iduser'], 2);
                                                    },
                                                  ),
                                                ),
                                                Text('Manager', style: TextStyle(fontSize: 12.0,color: Colors.black87)),
                                              ]),
                                          Column(
                                              children: <Widget>[
                                                ButtonTheme(
                                                  minWidth: 20,
                                                  child: FlatButton.icon(icon: Icon(Icons.local_dining , size: 42.0,), label: Text(""),
                                                    textColor: parsedJsonStaffList[index]['cooker'] == 1 ? Colors.blue : Colors.grey,
                                                    disabledColor: Colors.blue,
                                                    disabledTextColor: Colors.green,
                                                    padding: EdgeInsets.fromLTRB(8,0,0,0),
                                                    splashColor: Colors.blueAccent,
                                                    onPressed: (){
                                                      //parsedJsonStaffList[index]['buttonClick'] =0;
                                                    editStaff(parsedJsonStaffList[index]['iduser'], 3);
                                                    },
                                                  ),
                                                ),
                                                Text('Cooker', style: TextStyle(fontSize: 12.0,color: Colors.black87)),
                                              ]),
                                          parsedJsonStaffList[index]['cooker'] == 1 || parsedJsonStaffList[index]['manager'] == 1 || parsedJsonStaffList[index]['deliver'] == 1 ?Column(
                                              children: <Widget>[
                                                ButtonTheme(
                                                  minWidth: 20,
                                                  child: FlatButton.icon(icon: Icon(Icons.delete_forever , size: 42.0,), label: Text(""),
                                                    textColor: Colors.red,
                                                    disabledColor: Colors.blue,
                                                    disabledTextColor: Colors.green,
                                                    padding: EdgeInsets.fromLTRB(8,0,0,0),
                                                    splashColor: Colors.blueAccent,
                                                    onPressed: (){editStaff(parsedJsonStaffList[index]['iduser'], 0);},
                                                  ),
                                                ),
                                                Text('Dismiss', style: TextStyle(fontSize: 12.0,color: Colors.black87)),
                                              ]):Column(),
                                        ]),
                                    ]),
                                    SizedBox(height: 20.0),
                                  ]
                              ):Container(
                                  child:Text('\nΔεν έχει προστεθεί ακόμη προσωπικό\nΕάν ο υπάλληλός σας έχει εγκαταστήσει την εφαρμογή, απλώς ξεκινήστε να εισάγετε τον αριθμό κινητού τηλεφώνου του για να τον προσθέσετε στη λίστα.\n', style: TextStyle(fontSize: 20.0,color: Colors.black87),textAlign: TextAlign.center,)
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