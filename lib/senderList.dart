import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'main.dart';
import 'messenger.dart';


bool senderListComplite = false;
ScrollController scrollController = ScrollController();

class senderList extends StatefulWidget {
  @override
  _SenderListScreenState createState() => _SenderListScreenState();
}

class _SenderListScreenState extends State<senderList> {

  //получаем список сообщений
  senderList() async {
    try {
      var response = await http.post('https://koldashev.ru/GreekCafeAPI.php',
          headers: {"Accept": "application/json"},
          body: jsonEncode(<String, dynamic>{
            "login": "$IdRestaurant",
            "subject" : "senderList"
          })
      );
      var senderListJsonData = response.body;
      senderListParsedJson = json.decode(senderListJsonData);
      senderListComplite = true;
    } catch (error) {

      senderListComplite = false;
    }
    setState(() {});
  }
  //получаем список сообщений

  TextEditingController _controllerMessage ;

  @override
  void initState() {
    super.initState();
    senderList();
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 1),
            () =>
            scrollController.animateTo(scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 500), curve: Curves.ease));

    return Scaffold(
        backgroundColor: Color(0xFFffffff),
        appBar:AppBar(
          elevation: 0.0,
          title: Text(
            'Sender list',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFFffffff),
          brightness: Brightness.light,
          leading: Container(
            //margin: EdgeInsets.fromLTRB(50,0,10,0),
            child: Material(
              color: Colors.white, // button color
              child: InkWell(
                splashColor: Colors.green, // splash color
                onTap: () {
                  senderListComplite = false;
                  Navigator.pop(context,
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
            controller: scrollController,
            physics: ScrollPhysics(),
            child:Center(
                child: Column(
                    children: <Widget>[
                      senderListComplite?ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:  senderListParsedJson.length,//messageParsedJson
                          itemBuilder: (BuildContext context, int index) {

                            return Container(
                                child: Column(
                                    children: <Widget>[
                                      Container(
                                          padding: EdgeInsets.fromLTRB(10,10,10,10),
                                          alignment: Alignment(0.0, 0.0),
                                          margin: EdgeInsets.fromLTRB(10,10,10,10),
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

                                          child: Column(
                                              children: <Widget>[
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Container(
                                                          margin: EdgeInsets.fromLTRB(0,0,10,0),
                                                          width: MediaQuery.of(context).size.width - 120,
                                                          child:Text('${ senderListParsedJson[index]['senderName']}   ',
                                                        style: TextStyle(fontSize: 20.0, color: Colors.black),textAlign: TextAlign.left,)),
                                                Container(
                                                    width: 60,
                                                    child: RaisedButton.icon(
                                                      onPressed: (){
                                                        senderListComplite = false;
                                                        messageListComplite = false;
                                                        toIn = senderListParsedJson[index]['fromOut'];
                                                        setState(() {});
                                                        Navigator.push(context,
                                                            CupertinoPageRoute(builder: (context) => messenger()));

                                                      },
                                                      icon: Icon(Icons.send), label: Text(""),color: Colors.green,
                                                      textColor: Colors.white,
                                                      disabledColor: Colors.green,
                                                      disabledTextColor: Colors.white,
                                                      padding: EdgeInsets.fromLTRB(10,18,0,18),
                                                      splashColor: Colors.blueAccent,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(30.0),
                                                      ),
                                                    )),
                                                 ]),
                                              ]
                                          )
                                      ),
                                    ]
                                )
                            );
                          }
                      ):Container(
                          width: 50.0,
                          height: 50.0,
                          margin: EdgeInsets.fromLTRB(10,50,0,0),
                          child:CircularProgressIndicator(strokeWidth: 4.0,
                            valueColor : AlwaysStoppedAnimation(Colors.green),)),

                    ]))),
     );
  }
}

