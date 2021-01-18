import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greek_cafe/profileScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';
import 'messenger.dart';



class rulesPage extends StatefulWidget {
  @override
  _RulesPageScreenState createState() => _RulesPageScreenState();
}

class _RulesPageScreenState extends State<rulesPage> {


  @override
  void initState() {
    super.initState();
  }

  callClient(url) async {

    if (await canLaunch('tel://$url')) {
      await launch('tel://$url');
    } else {
      throw 'Невозможно набрать номер $url';
    }
    print('пробуем позвонить');
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFffffff),
      appBar:AppBar(
        elevation: 0.0,
        title: Text(
          'Privacy Policy',
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
                    Container(
                        margin: EdgeInsets.fromLTRB(0,0,0,0),
                        width: MediaQuery.of(context).size.width - 10,
                        child:Text('Privacy Policy\n\n'+
                            'This privacy policy has been compiled to better serve those who are concerned with how their \'Personally Identifiable Information\' (PII) is being used online. PII, as described in US privacy law and information security, is information that can be used on its own or with other information to identify, contact, or locate a single person, or to identify an individual in context. Please read our privacy policy carefully to get a clear understanding of how we collect, use, protect or otherwise handle your Personally Identifiable Information in accordance with our website.\n\n'+

                            'WHAT PERSONAL INFORMATION DO WE COLLECT FROM THE PEOPLE THAT VISIT OUR BLOG, WEBSITE OR APP?\n\n'+
                            'When ordering or registering on our site, as appropriate, you may be asked to enter your name, phone number or other details to help you with your experience.\n\n'+

                            'WHEN DO WE COLLECT INFORMATION?\n\n'+
                            'We collect information from you when you register on our app or enter information on our app.\n\n'+

                            'HOW DO WE USE YOUR INFORMATION?\n\n'+
                            'We may use the information we collect from you when you register, make a purchase, sign up for our newsletter, respond to a survey or marketing communication, or use certain other app features in the following ways:\n'+
                            'To personalize your experience and to allow us to deliver the type of content and product offerings in which you are most interested.\n'+
                            'To allow us to better service you in responding to your customer service requests.\n'+
                            'To send periodic push-notifications regarding your order or other products and services.\n\n'+

                            'HOW DO WE PROTECT YOUR INFORMATION?\n\n'+
                            'Our app is scanned on a regular basis for security holes and known vulnerabilities in order to make your visit to our app as safe as possible.\n'+

                            'We use regular Malware Scanning. Your personal information is contained behind secured networks and is only accessible by a limited number of persons who have special access rights to such systems, and are required to keep the information confidential. In addition, all sensitive/credit information you supply is encrypted via Secure Socket Layer (SSL) technology. We implement a variety of security measures when a user places an order enters, submits, or accesses their information to maintain the safety of your personal information. All transactions are processed through a gateway provider and are not stored or processed on our servers.\n\n'+

                            'DO WE USE \'COOKIES\'?\n\n'+
                            'No!\n\n'+

                            '    THIRD-PARTY DISCLOSURE\n\n'+
                            '    We do not sell, trade, or otherwise transfer to outside parties your Personally Identifiable Information.\n\n'+

                            'THIRD-PARTY LINKS\n\n'+
                            'We do not include or offer third-party products or services on our app.\n\n'+


                            'You will be notified of any Privacy Policy changes:\n'+
                            'On our Privacy Policy Page\n'+
                            'Can change your personal information:\n'+
                            'By logging in to your account\n\n'+


                            'DOES OUR SITE ALLOW THIRD-PARTY BEHAVIORAL TRACKING?\n\n'+
                            'It\'s also important to note that we do not allow third-party behavioral tracking\n\n'+

                            'COPPA (CHILDREN ONLINE PRIVACY PROTECTION ACT)\n\n'+
                          'When it comes to the collection of personal information from children under the age of 13 years old, the Children\'s Online Privacy Protection Act (COPPA) puts parents in control. The Federal Trade Commission, United States\' consumer protection agency, enforces the COPPA Rule, which spells out what operators of websites and online services must do to protect children\'s privacy and safety online. We do not specifically market to children under the age of 13 years old.\n\n'+

                          'FAIR INFORMATION PRACTICES\n\n'+
                          'The Fair Information Practices Principles form the backbone of privacy law in the United States and the concepts they include have played a significant role in the development of data protection laws around the globe. Understanding the Fair Information Practice Principles and how they should be implemented is critical to comply with the various privacy laws that protect personal information.\n\n'+

                          'In order to be in line with Fair Information Practices we will take the following responsive action, should a data breach occur: We will notify you via PUSH within 7 business days\n\n'+

                          'We also agree to the Individual Redress Principle which requires that individuals have the right to legally pursue enforceable rights against data collectors and processors who fail to adhere to the law. This principle requires not only that individuals have enforceable rights against data users, but also that individuals have recourse to courts or government agencies to investigate and/or prosecute non-compliance by data processors.\n\n'+

                          'CONTACTING US\n\n'+
                          'If there are any questions regarding this privacy policy, you may contact us using the information below.\n\n',
                          style: TextStyle(fontSize: 15.0, color: Colors.black),textAlign: TextAlign.left,)),
                    GestureDetector(
                        onTap: () {
                         // callClient('+79163181500');
                        },
                        child:
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.phone),
                              Text('  +7 916 318-15-00', style: TextStyle(fontSize: 15.0,color: Colors.blue,fontWeight: FontWeight.bold,))
                            ]
                        )),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.alternate_email),
                          Text('  dmitry@koldashev.ru')
                        ]
                    ),
                    SizedBox(height: 20.0),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton.icon(
                            onPressed: () {
                              Navigator.push(context,
                                  CupertinoPageRoute(builder: (context) => MainScreen()));
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
                              Navigator.push(context,
                                  CupertinoPageRoute(builder: (context) => profileView()));
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
                    SizedBox(height: 20.0),
                  ]))),
    );
  }
}