import 'package:fexm/Editor.dart';
import 'package:fexm/MyWidgets.dart';
import 'package:fexm/SiparisDetay.dart';
import 'package:fexm/mCustomWIdgets/CostomButton.dart';
import 'package:flutter/material.dart';
import 'datas/urundata.dart';
import 'package:fexm/main.dart';

class UrunDetay extends StatefulWidget {
  final Urundata uData;
  final bool duzenlenir;

  UrunDetay(this.duzenlenir, this.uData);

  @override
  _UrunDetay createState() => _UrunDetay(duzenlenir, uData);
}

class _UrunDetay extends State<UrunDetay> {
  Urundata uData;
  bool duzenlenir;
  bool mUrun;

  _UrunDetay(this.duzenlenir, this.uData);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.grey,
                height: 360,
                width: 360,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Image.network(
                        uData.urunres,
                        width: 360,
                      ),
                    ),
                    Positioned(
                      left: 25,
                      top: 35,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context, null);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 5, left: 5),
                  child: Text(uData.urunisim,
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500))),
              Container(
                  margin: EdgeInsets.only(top: 2, left: 5),
                  child: Text(
                    uData.baslik1,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
                  )),
              Container(
                  margin: EdgeInsets.only(top: 2, left: 5),
                  child: Text(
                    uData.baslik2,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200),
                  )),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Row(
                  children: <Widget>[],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        MyWidgets().yIldizlar(uData.deger),
                        Text(
                          uData.deger.toString(),
                          style: TextStyle(color: Primaryclor),
                        ),
                        Container(
                          height: 5,
                        ),
                        Text(
                          uData.degerlendirensay + ' kişi değerlendirdi',
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w200),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          uData.fiyat.toStringAsFixed(2) + ' ₺',
                          style: TextStyle(color: Primaryclor),
                        ),
                        Container(
                          height: 5,
                        ),
                        Text(
                          'Birim fiyat',
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w200),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.timelapse,
                              color: Primaryclor,
                              size: 18,
                            ),
                            Container(
                              width: 5,
                            ),
                            Text(uData.ulasmasur + ' Gün'),
                          ],
                        ),
                        Container(
                          height: 5,
                        ),
                        Text(
                          'Ortalama ulaşma süresi',
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w200),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, top: 15, right: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Şu bilgilere göre gönderilecek',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54),
                        ),
                        Container(
                          height: 5,
                        ),
                        Text(
                          kullaniciData.kAdres['il'] +
                              ',' +
                              kullaniciData.kAdres['ilce'],
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: Colors.black54),
                        )
                      ],
                    ),
                    InkWell(
                      child: Text(
                        'DEĞİŞTİR',
                        style: TextStyle(fontSize: 15, color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 90),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Center(
                      child: CostomButton(
                        text: 'Promosyon Kodu Kullan',
                        onclick: () {},
                        backgroundcolor: Colors.white,
                        pressclor: Colors.grey,
                        textcolor: BlackLight,
                        widh: 300,
                        padding: EdgeInsets.all(5),
                        textsize: 16,
                        radius: 10,
                      ),
                    ),
                    Center(
                      child: CostomButton(
                        text: uData.tasarim == 0
                            ? 'Tasarla veya Sipariş Ver'
                            : uData.tasarim == 1 ? 'Tasarla' : 'Sipariş Ver',
                        onclick: () {
                          switch (uData.tasarim) {
                            case 0:
                              {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          'Matbaacım',
                                          style: TextStyle(color: Primaryclor),
                                        ),
                                        contentTextStyle: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black54),
                                        content: Text(
                                            'Tasarımı kendiniz yapabilir yada özel bir tasarım yaptırmayı tercih edebilirsiniz.'),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text(
                                              'Kendim yapacağım',
                                              style:
                                                  TextStyle(color: Primaryclor),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Editor(isCreated: false,uData: uData)),
                                              );
                                            },
                                          ),
                                          FlatButton(
                                            child: Text(
                                              'Şirket yapsın',
                                              style:
                                                  TextStyle(color: Primaryclor),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SiparisDetay(uData:uData)),
                                              );
                                            },
                                          ),
                                        ],
                                      );
                                    });
                                break;
                              }
                            case 1:
                              {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Editor(isCreated: false,uData: uData)),
                                );
                                break;
                              }
                            case 2:
                              {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SiparisDetay(uData:uData)),
                                );
                                break;
                              }
                          }
                        },
                        backgroundcolor: Colors.green,
                        pressclor: Colors.lightGreen,
                        textcolor: Colors.white,
                        widh: 300,
                        padding: EdgeInsets.all(5),
                        textsize: 16,
                        radius: 10,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
