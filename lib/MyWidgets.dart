import 'dart:io';
import 'package:fexm/datas/kullanicidata.dart';
import 'package:fexm/datas/sirketdata.dart';
import 'package:fexm/datas/urundata.dart';
import 'package:fexm/mCustomWIdgets/PhotoShowRoom.dart';
import 'package:fexm/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'mCustomWIdgets/CircularImageInternet.dart';

typedef IntFunc = void Function(int);

class MyWidgets {
  Future<Sirketdata> sirketFinder(String ureticiUid)async{
    DataSnapshot snap=await FirebaseDatabase.instance.reference().child('Hesaplar').child('SirketBilgileri').child(ureticiUid).once();
    Map<dynamic,dynamic> sirketdata=snap.value;
    return Sirketdata(sirketdata['u_aktif'],sirketdata['u_res'],sirketdata['u_isim'],sirketdata['u_konum'],sirketdata['u_eposta'],sirketdata['u_tel'],sirketdata['u_web'],sirketdata['u_unvanmeslek'],sirketdata['u_odemegecerlimi'],sirketdata['u_sirketpuan'],);
  }
 Urundata urunFinder(String urunisim){
   Urundata returnedurundat;
    urunler.forEach((urundat){
      String keycode=urundat.urunisim+urundat.ureticiuid.substring(0,3);
      if(keycode==urunisim){
        returnedurundat=urundat;
      }
    });
    return returnedurundat;
  }
  Future<Kullanicidata>kullaniciFinder(String kullaniciuid)async{
    DataSnapshot snap=await FirebaseDatabase.instance.reference().child('Hesaplar').child('KullaniciBilgileri').child(kullaniciuid).once();
    Map<dynamic,dynamic> kullanicidata=snap.value;
    Map<dynamic,dynamic> adresD=kullanicidata['k_Adres'];
    Map<String,String> adresdata= {
      'il':adresD['il'],
      'ilce':adresD['ilce'],
      'mahalle':adresD['mahalle'],
      'adres1':adresD['adres1'],
      'adres2':adresD['adres2'],
    };
    return Kullanicidata(kullanicidata['k_Res'], kullanicidata['k_Isim'], kullanicidata['k_Eposta'], kullanicidata['k_Tel'],adresdata, kullanicidata['k_unvanmeslek'], kullanicidata['k_Dogumtarihi'], kullanicidata['k_AbonelikTipi']);
  }
  photoDialogCreater(BuildContext context,List<String> urls){
    showDialog(
        context: context,
        child: AlertDialog(
          elevation: 0,
          contentPadding: EdgeInsets.all(0),
          backgroundColor: Colors.transparent,
          content:PhotoShowRoom(uRls: urls,)
        ));
  }
  mKatagorimVertical(String katagoriadi, String baslik1, String baslik2,
      String urunsay, String katres) {
    var katagori = SizedBox(
        key: Key(katagoriadi),
        child: Center(
          child: Column(
            children: <Widget>[
              CircularImageInternet(url: katres),
              Container(
                width: 50,
                child: Text(katagoriadi,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis),
              ),
              Container(
                width: 50,
                child: Text(urunsay + ' ürün kayıtlı.',
                    style: TextStyle(
                        color: Primaryclor,
                        fontSize: 8,
                        fontWeight: FontWeight.w100),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis),
              )
            ],
          ),
        ));

    return katagori;
  }

  mKatagorimHorizontal(String katagoriadi, String baslik1, String baslik2,
      String urunsay, String katres) {
    var katagori = Column(
      key: Key(katagoriadi),
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 100,
              child: Text(katagoriadi,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis),
            ),
            Container(
              width: 15,
            ),
            Container(
              width: 200,
              child: Text(baslik1,
                  style: TextStyle(
                      color: Primaryclor,
                      fontSize: 14,
                      fontWeight: FontWeight.w100),
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: 20,
            )
          ],
        ),
        Divider(
          thickness: 1,
          color: AccentHard,
        )
      ],
    );

    return katagori;
  }

  yIldizlar(double puan) {
    var icon = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          puan > 1
              ? Icons.star
              : (puan > 0.5 ? Icons.star_half : Icons.star_border),
          color: Primaryclor,
          size: 10,
        ),
        Icon(
          puan > 2
              ? Icons.star
              : (puan > 1.5 ? Icons.star_half : Icons.star_border),
          color: Primaryclor,
          size: 10,
        ),
        Icon(
          puan > 3
              ? Icons.star
              : (puan > 2.5 ? Icons.star_half : Icons.star_border),
          color: Primaryclor,
          size: 10,
        ),
        Icon(
          puan > 4
              ? Icons.star
              : (puan > 3.5 ? Icons.star_half : Icons.star_border),
          color: Primaryclor,
          size: 10,
        ),
        Icon(
            puan > 4.8
                ? Icons.star
                : (puan > 4.5 ? Icons.star_half : Icons.star_border),
            color: Primaryclor,
            size: 10),
      ],
    );
    return icon;
  }

  mCircularImage(File file, double widh, double heigh,
      EdgeInsetsGeometry padding) {
    var circular = Container(
      width: widh,
      height: heigh,
      padding: padding,
      child: CircleAvatar(
        backgroundImage: FileImage(file),
        backgroundColor: Colors.transparent,
        minRadius: 90,
        maxRadius: 150,
      ),
    );
    return circular;
  }


  mEditorButton(String text,
      IconData _ic,
      VoidCallback onclick,
      Color color, double height, double widht, double iconsize,
      double fontsize, EdgeInsetsGeometry margin) {
    var boxButton = InkWell(onTap: onclick, child: Container(
      margin: margin,
      height: height,
      width: widht,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Icon(_ic, color: color, size: iconsize,),
        Text(text, style: TextStyle(color: color, fontSize: fontsize),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,)
      ],),
    ),);
    return boxButton;
  }

  mTextWithanimation(double _ofsetx,
      double _opaticy,
      String text,
      bool visible,
      Color textcolor,
      double textsize,
      TextAlign orientation,
      double widh,
      double heigh,
      EdgeInsetsGeometry padding) {
    var mtext = Visibility(
      visible: visible,
      child: Opacity(
        opacity: _opaticy,
        child: Transform.translate(
            offset: Offset(_ofsetx, 0),
            child: Container(
              width: widh,
              height: heigh,
              padding: padding,
              child: Text(
                text,
                style: TextStyle(
                  color: textcolor,
                  fontSize: textsize,
                ),
                textAlign: orientation,
              ),
            )),
      ),
    );
    return mtext;
  }

  mRadioButton(String text,
      int id,
      int rGid,
      IntFunc onclick,
      Color color,
      Color colordivider,
      Color textcolor,
      double textsize,
      double widh,
      double heighdivider,
      EdgeInsetsGeometry paddingtext) {
    var button = Container(
        width: widh,
        color: color,
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              Container(padding: paddingtext,
                  width: widh - 70,
                  child: Text(text, style: TextStyle(color: textcolor,
                      fontSize: textsize,
                      fontFamily: 'Helvectira',
                      fontWeight: FontWeight.w200),)),
              Radio(value: id, groupValue: rGid, onChanged: (ind) {
                onclick(id);
              },)
            ],
          ),
          Divider(color: colordivider, height: heighdivider,)
        ],)
    );
    return button;
  }

  bool conroltext(TextEditingController tCnt, int tType) {
    switch (tType) {
      case 0:
        {
          return tCnt.text.isEmpty ? true : false;
        }
      case 1:
        {
          return (tCnt.text.isEmpty ||
              tCnt.text.length != 10 ||
              tCnt.text[0] == '0');
        }
      case 2:
        {
          return (tCnt.text.isEmpty ||
              !tCnt.text.contains('@') ||
              !tCnt.text.contains('.'));
        }
      default:
        return false;
    }
  }

  splashscreen(bool splashVisib, bool logoVisib, bool textVisib,
      bool progressVisib, String text, BuildContext cont) {
    var splash = Visibility(
        visible: splashVisib,
        child: Container(
          height: MediaQuery
              .of(cont)
              .size
              .height,
          width: MediaQuery
              .of(cont)
              .size
              .width,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Visibility(
                    visible: logoVisib,
                    child: Image(
                      image: AssetImage('assets/matbaacim_t.png'),
                      width: 250,
                    )),
                Visibility(
                  visible: logoVisib,
                  child: Container(
                    height: 15,
                  ),
                ),
                Visibility(
                  visible: textVisib,
                  child: Text(text),
                ),
                Visibility(
                  visible: progressVisib,
                  child: Container(
                    height: 10,
                  ),
                ),
                Visibility(
                  visible: progressVisib,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.orange,
                    valueColor: AlwaysStoppedAnimation<Color>(Primaryclor),
                  ),
                ),
              ],
            ),
          ),
        ));
    return splash;
  }
}

class Radiomodel {
  String text;
  int index;

  Radiomodel({this.text, this.index});
}
