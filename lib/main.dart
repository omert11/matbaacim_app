import 'dart:async';
import 'package:fexm/datas/editoraddData.dart';
import 'package:fexm/datas/katagoridata.dart';
import 'package:fexm/datas/kullanicidata.dart';
import 'package:fexm/datas/sirketdata.dart';
import 'package:fexm/datas/urundata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fexm/SignDart.dart';
import 'Anasayfa.dart';
import 'Kayitol.dart';
var kullaniciUid = "";
Kullanicidata kullaniciData;
const String versioncode='1.0.0';
const String versioncodeE='0.0.1';
Sirketdata sirketData;
const Primaryclor = Colors.deepOrangeAccent;
const AccentLight = Color(0xFFF5F5F5);
const AccentHard = Color(0xFFE6E6E6);
const BlackLight = Color(0xFF292929);
const BlackLight_h = Color(0xFF363636);
const BlackLight_t = Color(0xFF333333);
var katagoriler = <Katagoridata>[];
var sepetimBekleyen = <SepetBekleyenData>[];
var sepetim=<SepetData>[];
var urunler = <Urundata>[];
List<Urundata> murunYarim = <Urundata>[];
int siralamasecili = 0;
int katagorisecili = -1;
int renksecili = 0;
int tassecili = 0;
int kargosecili = 0;
int urtimyrsecili = 0;
double fiyatk = 0;
double fiyatb = 0;
int firmasecili = 0;
String kelimesecili = '';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    theme: ThemeData(fontFamily: 'muli'),
    home: FutureBuilder<FirebaseUser>(
        future: FirebaseAuth.instance.currentUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else if (snapshot.data == null)
                return Giris();
              else
                kullaniciUid = snapshot.data.uid;
              return Kayitol();
          }
        }),
    routes: <String, WidgetBuilder>{
      "/kayit": (BuildContext context) => Kayitol(),
      "/giris": (BuildContext context) => Giris(),
      "/anasayfa": (BuildContext context) => Anasayfa(),
      //add more routes here
    },
  ));
}

class Giris extends StatefulWidget {
  @override
  _Giris createState() => _Giris();
}

class _Giris extends State<Giris> {
  Future<bool> _loginUser() async {
    final api = await FBApi.signInWithGoogle();
    if (api != null) {
      kullaniciUid = api.firebaseUser.uid;
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "",
      home: Scaffold(
        body: Container(
          padding: EdgeInsets.all(0),
          child: Center(
              child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Center(
                      child: Image(
                          image: AssetImage('assets/girisback.png'),
                          fit: BoxFit.fill)),
                  Center(
                      child: Container(
                    padding: EdgeInsets.only(top: 350),
                    child: Text(
                      'Tasarla,hazırla,görüntüle ve sipariş ver',
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
                ],
              ),
              Center(
                  child: Container(
                      padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                      child: Text(
                        'Giriş tuşuna bastığınızda Gizlilik Politikası ve Kullanıcı Sözleşmesini kabul etmiş olursunuz.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10, color: Colors.black54),
                      ))),
              Center(
                  child: Container(
                padding: EdgeInsets.only(top: 30),
                child: ButtonTheme(
                  minWidth: 250,
                  height: 40,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: RaisedButton(
                    onPressed: () async {
                      bool b = await _loginUser();
                      if (b == true) {
                        Navigator.of(context).pushNamed('/kayit');
                      } else {
                        print("Giris Basarisiz");
                      }
                    },
                    child: Text('GİRİŞ YAP',
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                    color: Primaryclor,
                    highlightColor: Colors.deepOrangeAccent,
                  ),
                ),
              )),
              Center(
                  child: Container(
                      padding: EdgeInsets.only(top: 25, left: 20, right: 20),
                      child: Text(
                        'Gizlilik Politikası ve Kullanıcı Sözleşmesi',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15, color: Colors.deepOrangeAccent),
                      ))),
            ],
          )),
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}


