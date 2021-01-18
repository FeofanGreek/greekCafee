import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greek_cafe/rules.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:http/http.dart' as http;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'historyScreen.dart';
import 'main.dart';

String Uname, Uphone, Uaddress, UfromFile, partnerCode, partnerCodeStatus, phoneStatus = '', token;
bool partnerCodeChecked = false;
bool clientPhoneChecked = false;
bool sendSms = true;

int timeCounterInternal = 60;

bool ordersListComplite = false;

//gеременные для прав доступа
bool isAdmin = false;
bool isCooker = false;
bool isDeliver = false;
bool isManager = false;

//для файрбейз
FirebaseMessaging _fcm = FirebaseMessaging();
StreamSubscription iosSubscription;

class profileView extends StatefulWidget {

  @override
  _profileScreenState createState() => _profileScreenState();
}

//таймер баттон
enum ButtonType { RaisedButton, FlatButton, OutlineButton }

const int aSec = 1;
int timeCounter = 0;
const String secPostFix = 's';
const String labelSplitter = ":";

class TimerButton extends StatefulWidget {
  final String label;
  final int timeOutInSeconds;
  final VoidCallback onPressed;
  final Color color;
  final Color disabledColor;
  final TextStyle activeTextStyle;
  final TextStyle disabledTextStyle;
  final ButtonType buttonType;

  const TimerButton({
    Key key,
    @required this.label,
    @required this.onPressed,
    @required this.timeOutInSeconds,
    this.color = Colors.blue,
    this.disabledColor,
    this.buttonType = ButtonType.RaisedButton,
    this.activeTextStyle = const TextStyle(color: Colors.white),
    this.disabledTextStyle = const TextStyle(color: Colors.black45),
  })  : assert(label != null),
        assert(activeTextStyle != null),
        assert(disabledTextStyle != null),
        super(key: key);

  @override
  _TimerButtonState createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton> {

  bool timeUpFlag = false;
  String get _timerText => '$timeCounter$secPostFix';

  @override
  void initState() {

    super.initState();
    timeCounter = widget.timeOutInSeconds;
    _timerUpdate();
  }

  _timerUpdate() {
    Timer(const Duration(seconds: aSec), () async {
      setState(() {
        timeCounter--;
      });
      if (timeCounter != 0)
        _timerUpdate();
      else
        timeUpFlag = true;
    });
  }

  Widget _buildChild() {
    return Container(
      child: timeUpFlag
          ? Text(
        'Επανάληψη SMS',
        style: (widget.buttonType == ButtonType.OutlineButton)
            ? widget.activeTextStyle.copyWith(color: widget.color)
            : widget.activeTextStyle,
      )
          : Text(
        'Βεβαιώνω' + labelSplitter + _timerText,
        style: widget.disabledTextStyle,
      ),
    );
  }

  _onPressed() async {
    if(timeCounter > 0){
      if (widget.onPressed != null) widget.onPressed();
    }
    else
    {
      if (widget.onPressed != null) widget.onPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.buttonType) {
      case ButtonType.RaisedButton:
        return RaisedButton(
          disabledColor: widget.disabledColor,
          color: widget.color,
          onPressed: _onPressed,
          child: _buildChild(),
        );
        break;
      case ButtonType.FlatButton:
        return FlatButton(
          color: widget.color,
          disabledColor: widget.disabledColor,
          onPressed: _onPressed,
          child: _buildChild(),
        );
        break;
      case ButtonType.OutlineButton:
        return OutlineButton(
          borderSide: BorderSide(
            color: widget.color,
          ),
          disabledBorderColor: widget.disabledColor,
          onPressed: _onPressed,
          child: _buildChild(),
        );
        break;
    }

    return Container();
  }
}
//timer button

class _profileScreenState extends State<profileView> {

  final _codeController = TextEditingController();


  TextEditingController _controllerName, _controllerPhone, _controllerAddress, _controllerPartnerCode ;
  var maskFormatterPhone = new MaskTextInputFormatter(mask: '+## (###) ###-##-##', filter: { "#": RegExp(r'[0-9]') });

  //otp
  Future<bool> loginUser(String phone, BuildContext context) async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async{
          Navigator.of(context).pop();
          UserCredential result = await _auth.signInWithCredential(credential);

          User user = result.user;
          //print('подписались ${result.user}');
          if(user != null){
            // все прям ок
            clientPhoneChecked = true;
            phoneStatus = '\nΟ αριθμός τηλεφώνου επαληθεύτηκε\n';
            Uphone = _controllerPhone.text;
            setState(() {});
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => profileView()));
          }else{
            clientPhoneChecked = false;
            sendSms = true;
            phoneStatus = '\nΛάθος αριθμός τηλεφώνου\n';
            setState(() {});
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => profileView()));
          }

          //This callback would gets called when verification is done automaticlly
        },
        verificationFailed: (exception){
          phoneStatus = '\nΜη έγκυρη μορφή αριθμού τηλεφώνου\n';
          clientPhoneChecked = false;
          sendSms = true;
          setState(() {});
          print('ошибка верификации');
          print(exception);
        },
        codeSent: (String verificationId, [int forceResendingToken]){
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("Έχεις τον κωδικό;"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: _codeController,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    //кнопка повтора смс
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton.icon(
                            onPressed: () {
                              sendSms = true;
                              Navigator.push(context,
                                  CupertinoPageRoute(builder: (context) => profileView()));
                            }
                            , icon: Icon(Icons.keyboard_backspace_rounded), label: Text("Οχι"),color: Colors.blue,
                            textColor: Colors.white,
                            disabledColor: Colors.blue,
                            disabledTextColor: Colors.white,
                            splashColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                          ),
                          Text('  '),
                          //кнопка повтора смс
                          TimerButton(
                            label: "Επανάληψη SMS",
                            timeOutInSeconds: 60,
                            onPressed: () async{
                              if(timeCounter > 0){
                                final code = _codeController.text.trim();
                                // ignore: deprecated_member_use
                                AuthCredential credential = PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: code);
                                UserCredential result = await _auth.signInWithCredential(credential);
                                User user = result.user;

                                if(user != null){
                                  //все прям ок
                                  clientPhoneChecked = true;
                                  sendSms = false;
                                  phoneStatus = '\nΟ αριθμός τηλεφώνου επαληθεύτηκε\n';
                                  Uphone = _controllerPhone.text;
                                  setState(() {});
                                  Navigator.push(context,
                                      CupertinoPageRoute(builder: (context) => profileView()));
                                }
                                else {
                                  clientPhoneChecked = false;
                                  sendSms = true;
                                  phoneStatus =
                                  '\nΛάθος αριθμός τηλεφώνου\n';
                                  setState(() {});
                                  Navigator.push(context,
                                      CupertinoPageRoute(
                                          builder: (context) =>
                                              profileView()));
                                }
                              }
                              else {
                                loginUser(phone, context);

                                setState(() {});
                              }
                            },
                            disabledColor: Colors.red,
                            color: Colors.blue,
                            disabledTextStyle: TextStyle(fontSize: 15.0),
                            activeTextStyle: TextStyle(fontSize: 15.0, color: Colors.white),

                          ),
                        ]),

                  ],
                );
              }
          );
        },
        codeAutoRetrievalTimeout: (String verificationId){
          phoneStatus = '\nΟ κωδικός έληξε\n';
          clientPhoneChecked = false;
          sendSms = true;
          setState(() {});
        }
    );
  }
  //otp


  @override
  void initState() {

    _controllerName = TextEditingController(text: Uname);
    _controllerPhone = TextEditingController(text: Uphone);
    _controllerAddress = TextEditingController(text: Uaddress);

    //для файрбейз

    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        // save the token  OR subscribe to a topic here
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
      _fcm.configure();
    }

    Firebase.initializeApp().whenComplete(() {
    });
    super.initState();

  }//initState


  @override
  Widget build(BuildContext context) {

    dellAccount() async{
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/profile.txt');

      var profile = jsonEncode(<String, dynamic>{"name": "","phone": "", "addres":""});
      await file.writeAsString(profile);
      ProfileComplite = false;
      clientPhoneChecked = false;
      sendSms = true;
      readProfile();
      setState(() {});
      Navigator.push(context,
          CupertinoPageRoute(builder: (context) => profileView()));
    }

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
                    SizedBox(height: 20.0),
                    Text('Τα δεδομένα σου', style: TextStyle(fontSize: 18.0,color: Colors.black87,fontWeight: FontWeight.bold,)),
                    !clientPhoneChecked?
                    Container(
                        padding: EdgeInsets.fromLTRB(40,10,40,5),
                        child: Text('Για να κάνετε παραγγελίες, επιβεβαιώστε τον αριθμό του κινητού σας τηλεφώνου.', style: TextStyle(fontSize: 16.0,color: Colors.black87,))):Container(),
                    !clientPhoneChecked?
                    Container(
                        padding: EdgeInsets.fromLTRB(40,10,40,5),
                        child:TextFormField(
                          enabled: sendSms?true:false,
                          inputFormatters: [maskFormatterPhone],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText: "Κινητό τηλέφωνο",
                            suffixIcon: IconButton(
                              onPressed: () => _controllerPhone.clear(),
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
                          onChanged: (value){Uphone = value;},
                          // ignore: deprecated_member_use
                          autovalidate: true,
                          controller: _controllerPhone,
                        )):
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('$Uphone', style: TextStyle(fontSize: 18.0,color: Colors.black87,fontWeight: FontWeight.bold,),textAlign: TextAlign.right,),
                          FlatButton.icon(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Όταν αλλάζετε τον αριθμό τηλεφώνου, το ιστορικό παραγγελιών θα διαγραφεί!"),
                                      content: Container(
                                        height:10,
                                      ),
                                      actions: <Widget>[
                                        Row(
                                            children: <Widget>[
                                              RaisedButton.icon(
                                                onPressed: () {
                                                  Navigator.push(context,
                                                      CupertinoPageRoute(builder: (context) => profileView()));
                                                },
                                                icon: Icon(Icons.cancel), label: Text("Οχι"),color: Colors.blue,
                                                textColor: Colors.white,
                                                disabledColor: Colors.blue,
                                                disabledTextColor: Colors.white,
                                                padding: EdgeInsets.fromLTRB(10,10,10,10),
                                                splashColor: Colors.blueAccent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(7.0),
                                                ),
                                              ),

                                              Text("  "),
                                              RaisedButton.icon(
                                                onPressed: () {
                                                  dellAccount();
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

                            },
                            icon: Icon(Icons.delete_forever),
                            label: Text(""),
                            color: Colors.white,
                            textColor: Colors.red,
                            disabledColor: Colors.blue,
                            disabledTextColor: Colors.black,
                            padding: EdgeInsets.fromLTRB(0,0,0,0),
                            minWidth: 20,
                          ),
                        ]),
                    Container(
                      child:Text('$phoneStatus', style: TextStyle(fontSize: 18.0,color: Colors.black87,fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                    ),
                    sendSms?Container(
                      child:!clientPhoneChecked?RaisedButton.icon(
                        onPressed: () {
                          String phone = _controllerPhone.text.trim();
                          phone = phone.replaceAll(' ','');
                          phone = phone.replaceAll('-','');
                          phone = phone.replaceAll('(','');
                          phone = phone.replaceAll(')','');
                          loginUser(phone, context);
                          sendSms = false; setState(() {});
                        }, icon: Icon(Icons.check), label: Text("Λήψη SMS"),color: Colors.blue,
                        textColor: Colors.white,
                        disabledColor: Colors.blue,
                        disabledTextColor: Colors.white,
                        padding: EdgeInsets.fromLTRB(50,10,50,10),
                        splashColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                      ):Container(),):Container(),
                    clientPhoneChecked?Container(
                        child: TextFormField(decoration: InputDecoration(hintText: "Το όνομα σου", focusedBorder: OutlineInputBorder(
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
                            return 'Συμπληρώστε την ενότητα Όνομα';
                          }
                          return null;
                        },
                          onChanged: (value){Uname = value;},
                          // ignore: deprecated_member_use
                          autovalidate: true,
                          controller: _controllerName,),
                        padding: EdgeInsets.fromLTRB(40,10,40,5)
                    ):Container(),


                    clientPhoneChecked?Container(
                      //margin: EdgeInsets.fromLTRB(0,0,10,MediaQuery.of (context) .viewInsets.bottom),
                      child: TextFormField(
                        controller: _controllerAddress,
                        // ignore: deprecated_member_use
                        autovalidate: true,
                        maxLines: 3, decoration: InputDecoration(hintText: "Επιπλέον πληροφορίες", focusedBorder: OutlineInputBorder(
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
                          return 'Συμπληρώστε την ενότητα Επιπλέον πληροφορίες';
                        }
                        return null;
                      },
                        onChanged: (value){Uaddress = value;},
                      ),
                      padding: EdgeInsets.fromLTRB(40,10,40,5),
                    ):Container(),
                    SizedBox(height: 10.0),
                    clientPhoneChecked?RaisedButton.icon(onPressed: (){
                      updateProfile();
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context) => MainScreen()));
                    }, icon: Icon(Icons.send), label: Text("Σειρά"),color: Colors.blue,
                      textColor: Colors.white,
                      disabledColor: Colors.blue,
                      disabledTextColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(50,10,50,10),
                      splashColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                    ):Container(),
                    SizedBox(height: 20.0),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) => rulesPage()));
                        },
                        child:
                              Text('Privacy Policy', style: TextStyle(fontSize: 15.0,color: Colors.blue,fontWeight: FontWeight.bold,))
                         ),
                    SizedBox(height: 20.0),
                    Container(
                      child:Image.asset('images/bonApetit.png',  height: 120, fit:BoxFit.fill,),
                      alignment: Alignment(0.00, 0.0),
                      padding: EdgeInsets.fromLTRB(0,0,0,5),
                    ),

                  ]))),

    );
  }
}

@override
readProfile() async {
  token = await _fcm.getToken();
  try {    final Directory directory = await getApplicationDocumentsDirectory();
  final File fileL = File('${directory.path}/profile.txt');

  UfromFile = await fileL.readAsString();
  var nameUs = json.decode(UfromFile);
  Uname = nameUs['name'];
  Uphone = nameUs['phone'];
  Uaddress = nameUs['addres'];


  } catch (error) {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/profile.txt');

    await file.writeAsString('');
    //print('ошибка $error');
  }
  if(Uname.length >1){if(Uphone.length > 5){if(Uaddress.length >5){ProfileComplite = true;clientPhoneChecked = true;
  textMainScreen = '    Απαλλαγείτε από περιττές λειτουργίες! Ο διευθυντής, ο σεφ και ο παράδοση βλέπουν και επεξεργάζονται ολόκληρη την παραγγελία απευθείας στην εφαρμογή.\n'+
  '     Το τηλέφωνό σας είναι πάντα δωρεάν, δεν υπάρχουν περιττά χαρτιά και λάθη.\n'+
  '    Λάβετε παραγγελίες και συνοδεύστε την εκτέλεσή τους απευθείας στην εφαρμογή από οπουδήποτε.\n'+
  '    Μάθετε πόσο πιστός είναι κάθε πελάτης σε εσάς.\n'+
  '    Εξοικονομήστε χρήματα στις τηλεφωνικές κλήσεις επικοινωνώντας μέσα στην εφαρμογή.\n'+
  '    Διαχειριστείτε υπαλλήλους και παρακολουθήστε την απόδοσή τους για εσάς.\n'+
  '    Δώστε αποστολές εξ αποστάσεως.\n'+
  '    Λάβετε αναφορές για δημοφιλή πιάτα, τον αριθμό των παραγγελιών και την ταχύτητα του προσωπικού σας.\n'+
  '    Διαχειριστείτε το μενού, τη σύνθεση και τις τιμές του OnLine.\n'+
  '    Γνωρίστε όλους τους πελάτες σας και ενημερώστε τους αμέσως για τρέχουσες διαφημιστικές καμπάνιες.\n'+
  '    Αποδοχή πληρωμής (πρόσθετη ενότητα).';

  }}}

}

updateProfile() async {

  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/profile.txt');

  var profile = jsonEncode(<String, dynamic>{"name": "$Uname","phone": "$Uphone", "addres":"$Uaddress", });
  await file.writeAsString(profile);
  saveDeviceToken(); //записываем токен в базу
  readProfile();
}

//получаем токен файрбейз и записываем его в базу
saveDeviceToken() async {
  String fcmToken = await _fcm.getToken();
  if (fcmToken != null) {
    //print("Получили токен : $fcmToken");
    try {
      var response = await http.post('https://koldashev.ru/GreekCafeAPI.php',
          headers: {"Accept": "application/json"},
          body: jsonEncode(<String, dynamic>{
            "login": "$IdRestaurant",
            "phone" : "$Uphone",
            "name" : "$Uname",
            "token" : "$fcmToken",
            "subject" : "tokenWrite"
          })
      );
      //print(response.body);
    } catch (error) {}
  }
}



