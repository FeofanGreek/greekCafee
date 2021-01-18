import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greek_cafe/profileScreen.dart';
import 'package:http/http.dart' as http;

import 'dart:io' show Platform;


import 'main.dart';
int msgcount = 0;
String messageTxt;
bool messageListComplite = false;
bool stopRefresh = false;

ScrollController scrollController = ScrollController();

class messenger extends StatefulWidget {
  @override
  _MessengerScreenState createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<messenger> {

  sendMessage() async {
    var manager;
    if (isAdmin | isManager) {
      manager = 1;
    } else {
      manager = 0;
    }
    try {
      var response = await http.post('https://koldashev.ru/GreekCafeAPI.php',
          headers: {"Accept": "application/json"},
          body: jsonEncode(<String, dynamic>{
            "login": "$IdRestaurant",
            "phone": "$Uphone",
            "name": "$Uname",
            "toIn": "$toIn",
            "manager": manager,
            "message": "$messageTxt",
            "subject": "sendMessage"
          })
      );
    } catch (error) {}
    if (this.mounted) {
      _controllerMessage.clear();
      //notReadMessage();
      AudioCache player = new AudioCache();
      const alarmAudioPath = "out.mp3";
      player.play(alarmAudioPath);

    }
  }

  //получаем список сообщений
  messageList() async {
    try {
      var manager;
      if (isAdmin | isManager) {
        manager = 1;
      } else {
        manager = 0;
      }
      var response = await http.post('https://koldashev.ru/GreekCafeAPI.php',
          headers: {"Accept": "application/json"},
          body: jsonEncode(<String, dynamic>{
            "login": "$IdRestaurant",
            "phone": "$Uphone",
            "toIn": "$toIn",
            "manager": manager,
            "subject": "messageList"
          })
      );
      var messageJsonData = response.body;
      messageParsedJson = json.decode(messageJsonData);
      messageListComplite = true;
    } catch (error) {
      messageListComplite = false;
    }
    if (this.mounted) {
      setState(() {});
     }
    print(msgcount);

    if(msgcount < messageParsedJson.length ) {
      msgcount = messageParsedJson.length;
      _start = 1;
      startTimer();
      if(messageParsedJson[msgcount-1]['senderName']!=Uname){
      AudioCache player = new AudioCache();
      const alarmAudioPath = "in.mp3";
      player.play(alarmAudioPath);
      }
    }  else {}
  }

  //получаем список сообщений

  TextEditingController _controllerMessage;

  Timer timer;

  @override
  void initState() {
    super.initState();
    _controllerMessage = TextEditingController(text: messageTxt);
    stopRefresh = false;
    timer = new Timer.periodic(Duration(seconds: 3), (timer) {
    if (stopRefresh) {
        timer.cancel();
    }
    messageList();
  });
  }


  Timer _timer;
  int _start = 1;

  @override
  void startTimer() {
    //print('пробуем прокрутить экран');
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {

          if (Platform.isAndroid) {
            setState(() {
              timer.cancel();
            });
          } else if (Platform.isIOS) {
            if (this.mounted) {
            setState(() {timer.cancel();});
            }
          }

        } else {
          if (scrollController.hasClients) {
            scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          }


          if (Platform.isAndroid) {
            setState(() {
              _start--;
            });
          } else if (Platform.isIOS) {
            if (this.mounted) {
              setState(() {_start--;});
            }
          }

        }
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(0xFFffffff),
        appBar:AppBar(
            elevation: 0.0,
            title: Text(
              'Messenger',
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
                    messageListComplite = false;
                    stopRefresh = true;
                    msgcount = 0;
                    setState(() {});
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
                      messageListComplite?ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:  messageParsedJson.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                child: messageParsedJson[index]['iduser']!=0?
                                Column(
                                    children: <Widget>[
                                      Container(
                                          padding: EdgeInsets.fromLTRB(10,10,10,10),
                                          alignment: Alignment(0.0, 0.0),
                                          margin: messageParsedJson[index]['senderName']!=Uname?EdgeInsets.fromLTRB(10,10,80,10):EdgeInsets.fromLTRB(80,10,10,10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(7.0),
                                            color: messageParsedJson[index]['senderName']!=Uname?Colors.white:Color.fromRGBO(	224, 238, 224, 1),
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
                                                Text('${ messageParsedJson[index]['senderName']}\n',
                                                  style: TextStyle(fontSize: 12.0, color: Colors.black),textAlign: TextAlign.left,),]),
                                                Text('${ messageParsedJson[index]['text']}',
                                                  style: TextStyle(fontSize: 15.0, color: Colors.black),textAlign: TextAlign.justify,),
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: <Widget>[
                                                      Text('${ messageParsedJson[index]['messDate']}',
                                                        style: TextStyle(fontSize: 10.0, color: Colors.black),textAlign: TextAlign.justify,),
                                                      messageParsedJson[index]['status']==3?
                                                      Icon(Icons.done_all, size: 15.0, color: Colors.blueAccent)
                                                          :messageParsedJson[index]['status']==2?
                                                      Icon(Icons.done, size: 15.0, color: Colors.blueAccent):Icon(Icons.done, size: 15.0, color: Colors.grey),

                                                    ]
                                                )
                                              ]
                                          )
                                      ),
                                ]
                              ):Container(
                                    child:Text('\nΓράψτε το πρώτο σας μήνυμα, η γνώμη σας είναι πολύ σημαντική!\n', style: TextStyle(fontSize: 20.0,color: Colors.black87),textAlign: TextAlign.center,)
                                )
                            );
                          },

                      ):Container(
                          width: 50.0,
                          height: 50.0,
                          margin: EdgeInsets.fromLTRB(10,50,0,0),
                          child:CircularProgressIndicator(strokeWidth: 4.0,
                            valueColor : AlwaysStoppedAnimation(Colors.green),)),
                      ]))),

        bottomNavigationBar: BottomAppBar(
            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0,0,10,MediaQuery.of (context) .viewInsets.bottom),
                                    width: MediaQuery.of(context).size.width - 80,
                                    child: TextFormField(

                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        onPressed: () => _controllerMessage.clear(),
                                        icon: Icon(Icons.clear),
                                      ),
                                      hintText: "Το μήνυμά σου", focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                      ),
                                    ), enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),),
                                    onChanged: (value){messageTxt = value;},
                                      onTap: () {
                                        scrollController.animateTo(scrollController.position.maxScrollExtent,
                                            duration: Duration(milliseconds: 500), curve: Curves.ease);
                                      },
                                    // ignore: deprecated_member_use
                                    autovalidate: true,
                                    controller: _controllerMessage,),),
                                Container(
                                    margin: EdgeInsets.fromLTRB(0,0,0,MediaQuery.of (context) .viewInsets.bottom),
                                    width: 60,
                                      child: RaisedButton.icon(
                                          onPressed: (){
                                            AudioCache player = new AudioCache();
                                            const alarmAudioPath = "out.mp3";
                                            player.play(alarmAudioPath);
                                          sendMessage ();
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
                          ],
                        ),
          )
    );
  }
}

