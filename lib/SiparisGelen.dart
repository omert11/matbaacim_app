import 'package:fexm/MyWidgets.dart';
import 'package:fexm/datas/SiparisDetayim.dart';
import 'package:fexm/datas/editoraddData.dart';
import 'package:fexm/datas/urundata.dart';
import 'package:fexm/mCustomWIdgets/CostomButton.dart';
import 'package:fexm/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'mCustomWIdgets/CircularImageInternet.dart';

class SiparisGelen extends StatefulWidget {
  SiparisGelen({@required this.gelenlerS});

  final List<SiparisDetayim> gelenlerS;

  @override
  _SiparisGelen createState() => _SiparisGelen();
}

class _SiparisGelen extends State<SiparisGelen> {
  String siralamaSekli = 'Tarih';
  String siralamaSub = 'Tümü';
  List<SiparisDetayim> gelenlerS = <SiparisDetayim>[];

  @override
  void initState() {
    gelenlerS.addAll(widget.gelenlerS);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(top: 40, bottom: 10),
              width: 360,
              color: Colors.blueAccent,
              child: Row(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: 20,
                  ),
                  Text('Gelen Siparişler',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                ],
              )),
          Container(
            width: 360,
            padding: EdgeInsets.all(10),
            color: Colors.blueAccent.withAlpha(180),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Şuna Göre Sıralanıyor: $siralamaSekli',
                  style: TextStyle(color: Colors.white),
                ),
                Container(
                  padding: EdgeInsets.all(3),
                  margin: EdgeInsets.only(right: 10),
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Text(
                        siralamaSub,
                      ),
                      Icon(Icons.arrow_drop_down)
                    ],
                  ),
                )
              ],
            ),
          ),
          gelenlerS.isEmpty
              ? Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Icon(
                          Icons.local_shipping,
                          color: Colors.blueAccent.withAlpha(180),
                          size: 90,
                        ),
                        Text(
                          'Şuanda  bir siparişini bulamadık.',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          'Daha fazla sipariş almak istiyorsan ürün eklemeyi dene.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    )
                  ],
                )
              : Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: gelenlerS.length,
                      itemBuilder: (BuildContext context, int index) {
                        SiparisDetayim detaydata = gelenlerS[index];
                        Urundata uData =
                            MyWidgets().urunFinder(detaydata.urunKod);
                        return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SiparisGelenDetay(
                                          uData: uData, sData: detaydata)));
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Image.network(
                                        uData.urunres,
                                        width: 70,
                                        height: 70,
                                      ),
                                      Container(
                                        width: 5,
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            uData.urunisim +
                                                '(${detaydata.siparisciData.kIsim})',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            '${detaydata.siprisDate.day}/${detaydata.siprisDate.month}/${detaydata.siprisDate.year}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300),
                                          ),
                                          detaydata.picRes != null
                                              ? Text(
                                                  'Özel tasarım var',
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.w100,
                                                      fontSize: 12),
                                                )
                                              : Text(
                                                  'Özel tasarım yok',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.w100,
                                                      fontSize: 12),
                                                ),
                                          Text(
                                            'Adet:${detaydata.istekcevaplari['Adet']}',
                                            style: TextStyle(
                                                color: Colors.blueAccent,
                                                fontWeight: FontWeight.w100,
                                                fontSize: 12),
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ));
                      }),
                )
        ],
      ),
    );
  }
}

class SiparisGelenDetay extends StatefulWidget {
  const SiparisGelenDetay({
    @required this.uData,
    @required this.sData,
  });

  final Urundata uData;
  final SiparisDetayim sData;

  @override
  _SiparisGelenDetay createState() => _SiparisGelenDetay();
}

class _SiparisGelenDetay extends State<SiparisGelenDetay> {
  Urundata uData;
  SiparisDetayim sData;

  @override
  void initState() {
    uData = widget.uData;
    sData = widget.sData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
      Container(
          padding: EdgeInsets.only(top: 40, bottom: 10),
          width: 360,
          color: Colors.blueAccent,
          child: Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              Container(
                width: 20,
              ),
              Text('${sData.siparisciData.kIsim}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600))
            ],
          )),
      Container(
        width: 360,
        padding: EdgeInsets.all(10),
        color: Colors.blueAccent.withAlpha(180),
        child: Center(
          child: Text(
            '${sData.siprisDate.day}/${sData.siprisDate.month}/${sData.siprisDate.year}--${uData.urunisim}',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      CircularImageInternet(
        url: sData.siparisciData.kRes,
        widh: 120,
        heigh: 120,
        padding: EdgeInsets.all(10),
      ),
      Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.blueAccent, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              sData.siparisciData.kEposta,
              style: TextStyle(color: Colors.blueAccent, fontSize: 20),
            ),
            Container(
              width: 5,
            ),
            Icon(
              Icons.email,
              color: Colors.blueAccent,
            )
          ],
        ),
      ),
      Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.green, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  sData.siparisciData.kTel,
                  style: TextStyle(color: Colors.green, fontSize: 20),
                ),
                Container(
                  width: 5,
                ),
                Icon(
                  Icons.phone,
                  color: Colors.green,
                )
              ],
            ),
            Text(
              'Hemen Aramak İçin Dokun',
              style: TextStyle(color: Colors.green),
            )
          ],
        ),
      ),
      CostomButton(
        onclick: () {},
        text: 'Hemen Mesaj At',
        backgroundcolor: Colors.green,
        pressclor: Colors.greenAccent,
      ),
      Container(
        height: 1,
        color: BlackLight,
        margin: EdgeInsets.all(10),
      ),
      Container(
          width: 360,
          child: Container(
              child: Text(
            '${sData.siparisciData.kAdres['adres1']} ${sData.siparisciData.kAdres['adres2']}',
            textAlign: TextAlign.center,
          ))),
      Container(
          width: 360,
          child: Text(
              '${sData.siparisciData.kAdres['mahalle']} ${sData.siparisciData.kAdres['ilce']}',
              textAlign: TextAlign.center)),
      Text('${sData.siparisciData.kAdres['il']}', textAlign: TextAlign.center),
      Container(
        height: 1,
        color: BlackLight,
        margin: EdgeInsets.all(10),
      ),
      Container(
          width: 360,
          color: AccentLight,
          padding: EdgeInsets.all(5),
          child: Text(
            'Sipariş Detayları',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          )),
      Container(
          child: sData.picRes != null
              ? Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: <Widget>[
                      Text('Tasarım Detayları'),
                      Container(
                        height: 10,
                      ),
                      Image.network(
                        sData.picRes,
                        width: 100,
                        height: 100,
                      ),
                      Container(
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: sData.screenResources.length,
                              itemBuilder: (BuildContext context, int index) {
                                EditoraddData srResData =
                                    sData.screenResources[index];
                                return srResData.type == 1
                                    ? Container(
                                        margin: EdgeInsets.all(10),
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.blueAccent
                                                    .withAlpha(160),
                                                width: 2),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              'Metin; ${srResData.mText}',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Container(
                                              height: 10,
                                            ),
                                            Text(
                                                'Metin Boyutu; ${srResData.mFontSize.toStringAsFixed(2)}'),
                                            Text(
                                                'Metin Kalınlık; ${srResData.mFontweight}'),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text('Metin Renk;'),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 10),
                                                  width: 15,
                                                  height: 15,
                                                  color:
                                                      Color(srResData.mColor),
                                                ),
                                              ],
                                            ),
                                            Text(
                                                'Koordinatlar; X:${srResData.positionx.toStringAsFixed(3)} Y:${srResData.positiony.toStringAsFixed(3)}')
                                          ],
                                        ),
                                      )
                                    : Container(
                                        margin: EdgeInsets.all(10),
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.blueAccent
                                                    .withAlpha(160),
                                                width: 2),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Column(
                                          children: <Widget>[
                                            Text('Resim',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            Image.network(
                                              srResData.imagePath,
                                              width: 70,
                                              height: 70,
                                            ),
                                            Text(
                                                'Resim büyütme katsayısı ${srResData.mImageSclae.toStringAsFixed(3)}'),
                                            Text(
                                                'Koordinatlar; X:${srResData.positionx.toStringAsFixed(3)} Y:${srResData.positiony.toStringAsFixed(3)}')
                                          ],
                                        ));
                              }))
                    ],
                  ),
                )
              : Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.indigo, width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.edit,
                        color: Colors.indigo,
                        size: 40,
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            'Ürün için özel bir tasarım yapılmamış.',
                            style: TextStyle(color: Colors.indigo),
                          ),
                          Text(
                            'Tasarım detayları için müşteri ile görüşün.',
                            style: TextStyle(color: Colors.indigo),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
      Container(
          child: Column(children: <Widget>[
        Text('Sipariş İstekleriniz'),
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: sData.istekcevaplari.length,
            itemBuilder: (BuildContext context, int index) {
              var soru = sData.istekcevaplari.keys;
              var cevap = sData.istekcevaplari.values;
              return Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Colors.blueAccent.withAlpha(160), width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Text(
                    '${soru.elementAt(index)} : ${cevap.elementAt(index)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ));
            })
      ])),
    ])));
  }
}
