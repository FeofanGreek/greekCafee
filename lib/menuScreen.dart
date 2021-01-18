
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter/services.dart';
import 'package:greek_cafe/rules.dart';
import 'package:greek_cafe/senderList.dart';

import 'package:greek_cafe/profileScreen.dart';

import 'historyScreen.dart';
import 'main.dart';
import 'package:greek_cafe/basketScreen.dart';

import 'messenger.dart';


class ScreenMenu extends StatefulWidget {
  final int eatSlide;
  ScreenMenu({Key key, this.title, @required this.eatSlide}) : super(key: key);
  final String title;

  @override
  _MainScreenState createState() => _MainScreenState(eatSlide: eatSlide);
}

class _MainScreenState extends State<ScreenMenu> with SingleTickerProviderStateMixin {


  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
    new AnimationController(vsync: this, duration: Duration(seconds: 3));
    _animationController.addListener(() => setState(() {}));
    if(eatTotalPriceList>0){
      TickerFuture tickerFuture = _animationController.repeat();
    tickerFuture.timeout(Duration(seconds:  1), onTimeout:  () {
      _animationController.forward(from: 1);
      _animationController.stop(canceled: true);
    });}

  }

  final int eatSlide;
  _MainScreenState({
    @required this.eatSlide,
  });

  @override
  Widget build(BuildContext context) {

    final List<Widget> imageSliders = imgList.map((item) => GestureDetector(
      onTap: () {
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) => ScreenMenu(eatSlide: imgList.indexOf(item))));
      },
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Stack(
              children: <Widget>[
                Image.network(item, fit: BoxFit.cover, width: 1000.0),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(200, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Text(
                      '${parsedJson[0]['menuClient'][imgList.indexOf(item)]['nameGroupBlude']}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    )).toList();

    return Scaffold(
      backgroundColor: Color(0xFFffffff),
      appBar:AppBar(
        elevation: 0.0,
        title: Text(
          '${parsedJson[0]['menuClient'][eatSlide]['nameGroupBlude']}',
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
         ]
      ),

        body:SingleChildScrollView(
                          physics: ScrollPhysics(),
                  child:Center(
                              child: Column(
                                  children: <Widget>[
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
                                        itemCount: parsedJson[0]['menuClient'][eatSlide]['groupMember'].length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Container(
                                            //margin: EdgeInsets.fromLTRB(50,0,0,10),
                                            //alignment: Alignment(-1.0, 0.0),
                                              child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                        margin: EdgeInsets.fromLTRB(50,0,10,5),
                                                        alignment: Alignment(-1.0, 0.0),
                                                        child:Text('${parsedJson[0]['menuClient'][eatSlide]['groupMember'][index]['nameBlude']}', style: TextStyle(fontSize: 20.0,color: Colors.black87,fontWeight: FontWeight.bold,))),
                                                    Container(
                                                        margin: EdgeInsets.fromLTRB(50,0,10,10),
                                                        alignment: Alignment(-1.0, 0.0),
                                                        child:Text('${parsedJson[0]['menuClient'][eatSlide]['groupMember'][index]['ingridientBlude']}', style: TextStyle(fontSize: 17.0,color: Colors.black87,))),
                                                    Text('Ένα μέρος', style: TextStyle(fontSize: 14.0,color: Colors.black87,)),
                                                    Row(
                                                        children: <Widget>[
                                                          Container(
                                                              margin: EdgeInsets.fromLTRB(50,0,0,10),
                                                              padding: EdgeInsets.fromLTRB(0,8,0,0),
                                                              alignment: Alignment(-1.0, 0.0),
                                                              child:Text('${parsedJson[0]['menuClient'][eatSlide]['groupMember'][index]['priceBlude'].toString()}€ ', style: TextStyle(fontSize: 20.0,color: Colors.black87,fontWeight: FontWeight.bold,),
                                                              )
                                                          ),

                                                            FlatButton.icon(icon: Icon(Icons.add), label: Text(""),
                                                            textColor: Colors.green,
                                                            disabledColor: Colors.blue,
                                                            disabledTextColor: Colors.green,
                                                            //padding: EdgeInsets.fromLTRB(0,20,100,10),
                                                            splashColor: Colors.blueAccent,
                                                            onPressed: (){//_incrementCounter();
                                                                          parsedJson[0]['menuClient'][eatSlide]['groupMember'][index]['value'] = parsedJson[0]['menuClient'][eatSlide]['groupMember'][index]['value'] + 1;
                                                                          eatTotalPriceList = eatTotalPriceList+parsedJson[0]['menuClient'][eatSlide]['groupMember'][index]['priceBlude'];
                                                                          setState(() {});
                                                                          TickerFuture tickerFuture = _animationController.repeat();
                                                                          tickerFuture.timeout(Duration(seconds:  1), onTimeout:  () {
                                                                            _animationController.forward(from: 1);
                                                                            _animationController.stop(canceled: true);
                                                                          });
                                                                        },
                                                          ),
                                                          Text('${parsedJson[0]['menuClient'][eatSlide]['groupMember'][index]['value']}', style: TextStyle(fontSize: 20.0,color: Colors.black87,fontWeight: FontWeight.bold,)),
                                                          FlatButton.icon(icon: Icon(Icons.remove), label: Text(""),
                                                            textColor: Colors.redAccent,
                                                            disabledColor: Colors.blue,
                                                            disabledTextColor: Colors.redAccent,
                                                            //padding: EdgeInsets.fromLTRB(0,20,100,10),
                                                            splashColor: Colors.blueAccent,
                                                            onPressed: (){
                                                                          if(parsedJson[0]['menuClient'][eatSlide]['groupMember'][index]['value'] != 0){
                                                                            parsedJson[0]['menuClient'][eatSlide]['groupMember'][index]['value'] --;
                                                                            eatTotalPriceList = eatTotalPriceList-parsedJson[0]['menuClient'][eatSlide]['groupMember'][index]['priceBlude'];
                                                                          }
                                                                          setState(() {});
                                                                       },
                                                          ),
                                                        ]),

                                                    ////////////
                                                    parsedJson[0]['menuClient'][eatSlide]['groupMember'][index]['priceBludeFull']!=0.00?Text('Πλήρες πιάτο', style: TextStyle(fontSize: 14.0,color: Colors.black87,)):Container(),
                                                    parsedJson[0]['menuClient'][eatSlide]['groupMember'][index]['priceBludeFull']!=0.00?Row(
                                                          children: <Widget>[
                                                            Container(
                                                                margin: EdgeInsets.fromLTRB(
                                                                    50, 0, 0, 10),
                                                                padding: EdgeInsets.fromLTRB(
                                                                    0, 8, 0, 0),
                                                                alignment: Alignment(-1.0, 0.0),
                                                                child: Text(
                                                                    '${parsedJson[0]['menuClient'][eatSlide]['groupMember'][index]['priceBludeFull']
                                                                        .toString()}€ ',
                                                                    style: TextStyle(
                                                                      fontSize: 20.0,
                                                                      color: Colors.black87,
                                                                      fontWeight: FontWeight
                                                                          .bold,))),
                                                            FlatButton.icon(
                                                              icon: Icon(Icons.add),
                                                              label: Text(""),
                                                              textColor: Colors.green,
                                                              disabledColor: Colors.blue,
                                                              disabledTextColor: Colors.green,

                                                              splashColor: Colors.blueAccent,
                                                              onPressed: () { //_incrementCounter();
                                                                parsedJson[0]['menuClient'][eatSlide]['groupMember'][index]['valueFull'] =
                                                                    parsedJson[0]['menuClient'][eatSlide]['groupMember'][index]['valueFull'] +
                                                                        1;
                                                                eatTotalPriceList =
                                                                    eatTotalPriceList +
                                                                        parsedJson[0]['menuClient'][eatSlide]['groupMember'][index]['priceBludeFull'];
                                                                setState(() {});
                                                                TickerFuture tickerFuture = _animationController.repeat();
                                                                tickerFuture.timeout(Duration(seconds:  1), onTimeout:  () {
                                                                  _animationController.forward(from: 1);
                                                                  _animationController.stop(canceled: true);
                                                                });
                                                              },
                                                            ),
                                                            Text(
                                                                '${parsedJson[0]['menuClient'][eatSlide]['groupMember'][index]['valueFull']}',
                                                                style: TextStyle(fontSize: 20.0,
                                                                  color: Colors.black87,
                                                                  fontWeight: FontWeight
                                                                      .bold,)),
                                                            FlatButton.icon(
                                                              icon: Icon(Icons.remove),
                                                              label: Text(""),
                                                              textColor: Colors.redAccent,
                                                              disabledColor: Colors.blue,
                                                              disabledTextColor: Colors
                                                                  .redAccent,
                                                              //padding: EdgeInsets.fromLTRB(0,20,100,10),
                                                              splashColor: Colors.blueAccent,
                                                              onPressed: () {
                                                                if (parsedJson[0]['menuClient'][eatSlide]['groupMember'][index]['valueFull'] !=
                                                                    0) {
                                                                  parsedJson[0]['menuClient'][eatSlide]['groupMember'][index]['valueFull'] --;
                                                                  eatTotalPriceList =
                                                                      eatTotalPriceList -
                                                                          parsedJson[0]['menuClient'][eatSlide]['groupMember'][index]['priceBludeFull'];
                                                                }
                                                                setState(() {});
                                                                //PrintBasket ();
                                                              },
                                                            ),
                                                          ]): Container(),

                                                    ///////////////
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
                                    //Text('Total ${double.parse((eatTotalPriceList.toStringAsFixed(2)))}', style: TextStyle(fontSize: 20.0,color: Colors.black87,fontWeight: FontWeight.bold,)),
                                    SizedBox(height: 20.0),
                                    Container(
                                      child:Image.asset('images/bonApetit.png',  height: 120, fit:BoxFit.fill,),
                                      alignment: Alignment(0.00, 0.0),
                                      padding: EdgeInsets.fromLTRB(0,0,0,5),
                                    ),
                          ]))),
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
            bottomNavigationBar: BottomAppBar(child:CarouselSlider(
              options: CarouselOptions(
                initialPage: eatSlide,
                autoPlay: false,
                aspectRatio: 2.0,
                enlargeCenterPage: true,
              ),
              items: imageSliders,
            ),)
    );
  }
}
