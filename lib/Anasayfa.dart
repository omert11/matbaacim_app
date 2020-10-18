import 'dart:io';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fexm/EditorStarter.dart';
import 'package:fexm/SignDart.dart';
import 'package:fexm/SiparisGelen.dart';
import 'package:fexm/datas/editoraddData.dart';
import 'package:fexm/datas/sirketdata.dart';
import 'package:fexm/mCustomWIdgets/CircularImageInternet.dart';
import 'package:fexm/mCustomWIdgets/CostomButton.dart';
import 'package:fexm/mCustomWIdgets/SepetBox.dart';
import 'package:fexm/mCustomWIdgets/UrunCell.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'dart:async';
import 'Filter.dart';
import 'MyWidgets.dart';
import 'SiparisDetay.dart';
import 'TabCicular.dart';
import 'UrunDetay.dart';
import 'datas/SiparisDetayim.dart';
import 'datas/filterdata.dart';
import 'datas/katagoridata.dart';
import 'datas/kullanicidata.dart';
import 'datas/urundata.dart';
import 'mCustomWIdgets/HorizontalIconButton.dart';
import 'mCustomWIdgets/SplashScreen.dart';
import 'main.dart';

class Anasayfa extends StatefulWidget {
  @override
  _Anasayfa createState() => _Anasayfa();
}

class _Anasayfa extends State<Anasayfa> with SingleTickerProviderStateMixin {
  cikis() async {
    final api = FBApi.singOutGoogleAndFirebase();
    Navigator.of(context).pushNamed(api);
  }
  String username = 'matbaacimapp@gmail.com';
  String password = 'sapanca7';
  var _pages = <Widget>[];
  Animation<double> animation;
  AnimationController controller;
  PageController contpage = PageController();
  bool visibleArrowback = false;
  bool visibleisLoaind = false;
  bool visibleText = true;
  bool visibleKatagori = true;
  bool visibleFilter = false;
  bool visibleUrun = false;
  bool visibleUrunarrow = false;
  bool visibleSerch = true;
  double opactyArrow = 0;
  double opactytext = 0;
  double opactysearch = 1;
  double ofsetxArrow = 0;
  double widhtext = 0;
  String bUrunsay = '0';
  String bFiltsay = '0';
  String loadingProgressT = '0';
  double _ofsetxsearch = 0;
  int positionAnimation = 0;
  int page = 0;
  int _indexnow = 0;
  var katagoriListVertical = <Widget>[];
  var katagoriListHorizontal = <Widget>[];
  var urunListHorizontal = <Urundata>[];
  List<SiparisDetayim> gelenlerS = <SiparisDetayim>[];
  var katagorilerF = <Katagoridata>[];
  var urunlerF = <Urundata>[];
  var cSearch = TextEditingController();
  @override
  void initState() {
    sepetCek();
    sepetBekleyenCek();
    katagoriCek();
    siparislerimiCek();
    urunCek();
    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_indexnow == 0) {
        if (page <= 1) {
          page++;
        } else {
          page = 0;
        }
        contpage.animateToPage(page,
            duration: Duration(milliseconds: 350), curve: Curves.easeInCirc);
      }
    });
    controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    animation = Tween<double>(begin: 0, end: 500).animate(controller);
    animation.addListener(() {
      setState(() {
        switch (positionAnimation) {
          case 0:
            {
              double animated = animation.value;
              opactysearch = 1 - (animated / 500);
              opactytext = (animated / 500);
              _ofsetxsearch = animated / 5;
              widhtext = animated / 5 * 2;
              if (animation.isCompleted) {
                positionAnimation = 101;
                animation =
                    Tween<double>(begin: 0, end: 500).animate(controller);
                controller.reset();
                controller.forward();
              }
              break;
            }
          case 1:
            {
              double animated = animation.value;
              ofsetxArrow = -(100 - animated / 5);
              opactyArrow = (animated / 500);
              if (animation.isCompleted) {
                positionAnimation = 102;
                animation =
                    Tween<double>(begin: 500, end: 0).animate(controller);
                controller.reset();
                controller.forward();
              }
              break;
            }
          case 101:
            {
              double animated = animation.value;
              ofsetxArrow = -(100 - animated / 5);
              opactyArrow = (animated / 500);
              if (animation.isCompleted) {
                positionAnimation = 1;
              }
              break;
            }
          case 102:
            {
              visibleArrowback = false;
              double animated = animation.value;
              opactysearch = 1 - (animated / 500);
              opactytext = (animated / 500);
              _ofsetxsearch = animated / 5;
              widhtext = animated / 5 * 2;
              if (animation.isCompleted) {
                positionAnimation = 0;
              }
              break;
            }
        }
      });
    });
    _pager(0);
    cSearch.addListener(() {
      var mText = cSearch.text;
      kelimesecili = mText;
      if (visibleFilter) {
        filtrele(Filterdata(siralamasecili, katagorisecili, renksecili,
            tassecili, katagorisecili, fiyatk, fiyatb, kelimesecili));
      } else {
        katagorilerF.clear();
        katagoriler.forEach((eached) {
          if (eached.katagori.toUpperCase().contains(mText.toUpperCase()) ||
              eached.baslik1.toUpperCase().contains(mText.toUpperCase()) ||
              eached.baslik2.toUpperCase().contains(mText.toUpperCase())) {
            katagorilerF.add(eached);
          }
        });
        if (katagorilerF.length != 0) {
          setState(() {
            visibleKatagori = true;
          });
          katagoriOlusturS();
        } else if (mText.isNotEmpty) {
          setState(() {
            visibleKatagori = false;
            _pager(_indexnow);
          });
        }
      }
    });
    super.initState();
  }
  siparislerimiCek() {
    DatabaseReference refS = FirebaseDatabase.instance.reference().child(
        'SiparisGiden').child(kullaniciUid);
    refS.onValue.listen((yearColumn){
      gelenlerS.clear();
      if((yearColumn.snapshot.value as Map<dynamic, dynamic>)!=null) {
        (yearColumn.snapshot.value as Map<dynamic, dynamic>).forEach((year,
            monthColumn) {
          (monthColumn as Map<dynamic, dynamic>).forEach((month, dayColumn) {
            (dayColumn as Map<dynamic, dynamic>).forEach((day, uidColumn) {
              (uidColumn as Map<dynamic, dynamic>).forEach((uid, urunColumn) {
                (urunColumn as Map<dynamic, dynamic>).forEach((urunkod,
                    onData) async {
                  List<EditoraddData> addingData = <EditoraddData>[];
                  if ((onData['screenResources'] as List<dynamic>) != null) {
                    (onData['screenResources'] as List<dynamic>).forEach((
                        eachSres) {
                      Map<dynamic, dynamic> onResources = eachSres;
                      if (onResources['type'] == 1) {
                        addingData.add(EditoraddData.text(
                            onResources['type'],
                            onResources['x'].toDouble(),
                            onResources['y'].toDouble(),
                            onResources['mText'],
                            onResources['mColor'],
                            onResources['mFontSize'].toDouble(),
                            onResources['mFontStyle'],
                            onResources['mFontweight']));
                      } else {
                        addingData.add(EditoraddData.image(
                            onResources['type'], onResources['x'].toDouble(),
                            onResources['y'].toDouble(),
                            onResources['mImageSclae'].toDouble(),
                            onResources['imagePath']));
                      }
                    });
                  }
                  Kullanicidata kData = await MyWidgets().kullaniciFinder(uid);
                  DateTime dat = DateTime.utc(
                      int.parse(year), int.parse(month), int.parse(day));
                  setState(() {
                    gelenlerS.add(SiparisDetayim(
                        kData,
                        dat,
                        addingData,
                        onData['istekcevaplari'],
                        onData['picres'],
                        onData['urunKat'],
                        urunkod));
                  });
                });
              });
            });
          });
        });
      }
      _pager(_indexnow);
    });
  }
  sendMail() {
    final smtpServer = gmail(username, password);
    final dat = DateTime.now();
    setState(() {
      visibleisLoaind = true;
    });
    double progressState = 100 / sepetim.length;
    sepetim.forEach((ecdSepet) async {
      Urundata udata = MyWidgets().urunFinder(ecdSepet.uruncode);
      Sirketdata sdata = await MyWidgets().sirketFinder(udata.ureticiuid);
      sendSiparis(udata.ureticiuid, ecdSepet.uruncode, dat);
      String body =
          'Şiparişiniz için istediğiniz bilgiler altta özet geçilmiştir.\nDaha detaylı bilgi için lütfen ugulamamızı ziyaret edin.\n';
      int k = 0;
      ecdSepet.soru.forEach((eachedS) {
        body += '$eachedS : ${ecdSepet.cevap[k]}\n';
        k++;
      });
      sepetimBekleyen.forEach((eachedSb) {
        if (eachedSb.urunI == ecdSepet.uruncode) {
          body += 'Tasarım yapılmış;\nTasarım ön izleme:${eachedSb.sRes}\n';
          int indexResour=0;
          eachedSb.screenResources.forEach((eaSr) async {
            if (eaSr.type == 1) {
              body += 'Text(${eaSr.mText})\n'
                  '-X pozisyonu(${eaSr.positionx})\n'
                  '-Y pozisyonu(${eaSr.positiony})\n'
                  '-Yazı puntosu(${eaSr.mFontSize})\n'
                  '-Yazı genişliği(${eaSr.mFontweight})\n'
                  '-Yazı stili(${eaSr.mFontStyle})\n'
                  '-Yazi rengi(${eaSr.mColor})\n';
            } else {
              resimyukle(udata.ureticiuid,eaSr.imagePath, eachedSb.urunI,indexResour,dat);
              body += 'Image\n'
                  '-X pozisyonu(${eaSr.positionx})\n'
                  '-Y pozisyonu(${eaSr.positiony})\n'
                  'Resim büyütme kat sayısı(${eaSr.positiony})\n'
                  'Resim: Detay için uygulamadan bakın lütfen.';
            }
            indexResour++;
          });
        }
      });

      final message = Message()
        ..from = Address(username, 'Matbaacım App')
        ..recipients.add(sdata.uEposta)
        ..subject =
            '${udata.urunisim} ürününüz için ${kullaniciData.kIsim} tarafından bir siparişiniz var.'
        ..text = body;
      try {
        final sendReport = await send(message, smtpServer);
        print('Message sent: ' + sendReport.toString());
      } on MailerException catch (e) {
        print('Message not sent.${e.toString()}');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }
      double onProgress = double.parse(loadingProgressT) + progressState;
      setState(() {
        loadingProgressT = onProgress.toStringAsFixed(2);
      });
      if (onProgress > 95) {
        sepettemizle();
      }
    });
  }

  sendSiparis(String ureticiuid, String uruncode, DateTime dat) {
    DatabaseReference savRef = FirebaseDatabase.instance
        .reference()
        .child('SiparisGiden')
        .child(ureticiuid)
        .child(dat.year.toString())
        .child(dat.month.toString())
        .child(dat.day.toString())
        .child(kullaniciUid)
        .child(uruncode);
    FirebaseDatabase.instance
        .reference()
        .child('Editored')
        .child('Sepetler')
        .child(kullaniciUid)
        .child(uruncode)
        .once()
        .then((vale) {

      FirebaseDatabase.instance
          .reference()
          .child('Sepetler')
          .child(kullaniciUid)
          .child(uruncode)
          .once()
          .then((val) {
            Map<dynamic,dynamic> valeM=vale.value;
            Map<dynamic,dynamic> valM=val.value;
            if(valeM!=null){
            valM.addAll(valeM);}
        savRef.set(valM);
      });
    });
  }

  resimyukle(String ureticiuid,String path, String uruncode,int index,DateTime dat)  {
    DatabaseReference savRef = FirebaseDatabase.instance
        .reference()
        .child('SiparisGiden')
        .child(ureticiuid)
        .child(dat.year.toString())
        .child(dat.month.toString())
        .child(dat.day.toString())
        .child(kullaniciUid)
        .child(uruncode);
    File upload = File(path);
    StorageUploadTask task=FirebaseStorage.instance
        .ref()
        .child('KullaniciDatasi')
        .child(kullaniciUid)
        .child('editting')
        .child(path.hashCode.toString())
        .putFile(upload);
    task.onComplete.then((onVal){
      onVal.ref.getDownloadURL().then((onVale){
        savRef.child('screenResources').child(index.toString()).child('imagePath').set(onVale);
      });
    });
  }

  sepettemizle() {
    DatabaseReference mref = FirebaseDatabase.instance
        .reference()
        .child('Sepetler')
        .child(kullaniciUid);
    mref.once().then((onval) {
      var task = FirebaseDatabase.instance
          .reference()
          .child('GecmisSiparis')
          .child(kullaniciUid)
          .push()
          .set(onval.value);
      task.whenComplete(() {
        mref.remove().whenComplete(() {
          setState(() {
            visibleisLoaind = false;
            loadingProgressT = '0';
          });
        });
      });
    });
  }

  katBulYolla(String kat) {
    int index = 0;
    katagoriler.forEach((eached) {
      if (eached.katagori == kat) {
        katagorisecili = index;
      } else {
        index++;
      }
    });
    filterSayisiHsp();
  }

  sepetBekleyenCek() {
    DatabaseReference mref = FirebaseDatabase.instance
        .reference()
        .child('Editored')
        .child('Sepetler')
        .child(kullaniciUid);
    mref.onValue.listen((ondata) {
      sepetimBekleyen.clear();
      Map<dynamic, dynamic> sepet = ondata.snapshot.value;
      if (sepet != null) {
        sepet.forEach((urunIs, sepetteki) {
          Map<dynamic, dynamic> sepetMap = sepetteki;
          if (sepetMap['screenResources'] != null) {
            List<dynamic> resources = sepetMap['screenResources'];
            var mreslist = <EditoraddData>[];
            resources.forEach((valres) {
              int type = valres['type'];
              if (type == 1) {
                mreslist.add(EditoraddData.text(
                    type,
                    valres['x'].toDouble(),
                    valres['y'].toDouble(),
                    valres['mText'],
                    valres['mColor'],
                    valres['mFontSize'].toDouble(),
                    valres['mFontStyle'],
                    valres['mFontweight']));
              } else if (type == 2) {
                mreslist.add(EditoraddData.image(
                    type,
                    valres['x'].toDouble(),
                    valres['y'].toDouble(),
                    valres['mImageSclae'].toDouble(),
                    valres['imagePath']));
              }
            });
            sepetimBekleyen.add(SepetBekleyenData(
                urunIs.toString(), sepetMap['picres'], mreslist));
          }
        });
      }
      _pager(_indexnow);
    });
  }

  katAc(String kIsim) {
    katBulYolla(kIsim);
    urunlerF.clear();
    urunler.forEach((eached) {
      if (eached.bulundugukatagori == kIsim) {
        urunlerF.add(eached);
      }
    });
    setState(() {
      visibleUrun = true;
      visibleFilter = true;
      visibleUrunarrow = true;
      visibleKatagori = false;
      urunOlustur(urunlerF);
      _pager(1);
      _indexnow = 1;
    });
  }

  katKapat() {
    setState(() {
      visibleUrun = false;
      visibleUrunarrow = false;
      visibleFilter = false;
      visibleKatagori = true;
      _pager(1);
      _indexnow = 1;
    });
  }

  String sepetToplamHesapla() {
    String donecek = '0.00';
    double toplam = 0;
    if (sepetim.isNotEmpty) {
      sepetim.forEach((e) {
        int adet = int.parse(e.adet);
        double fiyat = MyWidgets().urunFinder(e.uruncode).fiyat;
        toplam += adet * fiyat;
      });
      donecek = toplam.toStringAsFixed(2);
    }
    return donecek;
  }

  sepetCek() {
    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child('Sepetler')
        .child(kullaniciUid);
    ref.onValue.listen((val) {
      sepetim.clear();
      Map<dynamic, dynamic> sepetimdekiler = val.snapshot.value;
      if (sepetimdekiler != null) {
        sepetimdekiler.forEach((key, valuee) {
          Map<dynamic, dynamic> database = valuee;
          if(database['istekcevaplari']!=null){
          String nameUrun = key;
          List<String> cevaplist = <String>[];
          List<String> sorulist = <String>[];
          Map<dynamic, dynamic> cevaps = database['istekcevaplari'];
          cevaps.forEach((k, v) {
            String soru = k;
            String cevap = v;
            cevaplist.add(cevap);
            sorulist.add(soru);
          });
          SepetData datasending =
              SepetData(cevaplist, sorulist, nameUrun, cevaps['Adet']);
          sepetim.add(datasending);}
        });
      }
      _pager(_indexnow);
    });
  }

  filterSayisiHsp() {
    var integr = 0;
    if (katagorisecili != -1) integr++;
    if (renksecili != 0) integr++;
    if (tassecili != 0) integr++;
    if (kargosecili != 0) integr++;
    if (fiyatk != 0 || fiyatb != 0) integr++;
    setState(() {
      bFiltsay = integr.toString();
    });
  }

  filterAcar(BuildContext context, int fPos) async {
    Filterdata result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Filter(fPos)),
    );
    filtrele(result);
  }

  List<Urundata> listFilter(List<Urundata> list, int fil) {
    var urunlerG = <Urundata>[];
    switch (fil) {
      case -1:
        {
          list.forEach((eached) {
            if (eached.urunisim
                    .toLowerCase()
                    .contains(kelimesecili.toLowerCase()) ||
                eached.baslik1
                    .toLowerCase()
                    .contains(kelimesecili.toLowerCase()) ||
                eached.baslik2
                    .toLowerCase()
                    .contains(kelimesecili.toLowerCase())) {
              urunlerG.add(eached);
            }
          });
          if (urunlerG.length != 0) {
            setState(() {
              visibleUrun = true;
            });
          } else if (kelimesecili.isNotEmpty) {
            setState(() {
              visibleUrun = false;
              _pager(_indexnow);
            });
          }
          return urunlerG;
        }
      case 0:
        {
          list.forEach((eached) {
            if (eached.bulundugukatagori ==
                katagoriler[katagorisecili].katagori) urunlerG.add(eached);
          });
          return urunlerG;
        }
      case 1:
        {
          list.forEach((eached) {
            if (eached.renk == renksecili) urunlerG.add(eached);
          });
          return urunlerG;
        }
      case 2:
        {
          list.forEach((eached) {
            if (eached.tasarim == tassecili) urunlerG.add(eached);
          });
          return urunlerG;
        }
      case 3:
        {
          list.forEach((eached) {
            if (eached.kargo == kargosecili) urunlerG.add(eached);
          });
          return urunlerG;
        }
      case 4:
        {
          list.forEach((eached) {
            if (fiyatb != 0) {
              if (eached.fiyat >= fiyatk && eached.fiyat <= fiyatb)
                urunlerG.add(eached);
            } else {
              if (eached.fiyat >= fiyatk) urunlerG.add(eached);
            }
          });
          return urunlerG;
        }
      default:
        return urunlerG;
    }
  }

  filtrele(Filterdata data) {
    var urunlerFilt = <Urundata>[];
    if (data.kelimekodu != '') {
      urunlerFilt = listFilter(urunler, -1);
    } else {
      visibleUrun = true;
      urunlerFilt.addAll(urunler);
    }
    if (data.katagori != -1) {
      urunlerFilt = listFilter(urunlerFilt, 0);
    }
    if (data.renk != 0) {
      urunlerFilt = listFilter(urunlerFilt, 1);
    }
    if (data.tasarim != 0) {
      urunlerFilt = listFilter(urunlerFilt, 2);
    }
    if (data.kargo != 0) {
      urunlerFilt = listFilter(urunlerFilt, 3);
    }
    if (data.fiyk != 0 || data.fiyb != 0) {
      urunlerFilt = listFilter(urunlerFilt, 4);
    }
    urunlerFilt.sort((a, b) {
      switch (data.siralama) {
        case 0:
          {
            return a.fiyat.compareTo(b.fiyat);
          }
        case 1:
          {
            return b.fiyat.compareTo(a.fiyat);
          }
        case 2:
          {
            return b.deger.compareTo(a.deger);
          }
        case 3:
          {
            return a.deger.compareTo(b.deger);
          }
        case 4:
          {
            return a.urunisim.compareTo(b.urunisim);
          }
        default:
          {
            return a.urunisim.compareTo(b.urunisim);
          }
      }
    });
    urunOlustur(urunlerFilt);
  }

  urunDetay(String index) {
    urunler.forEach((eached) {
      if (eached.urunisim == index) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UrunDetay(false, eached)),
        );
      }
    });
  }

  _pager(int index) {
    setState(() {
      switch (index) {
        case 0:
          {
            _pages = <Widget>[
              Container(
                height: 200,
                child: PageView(
                  controller: contpage,
                  children: <Widget>[
                    Image(
                        image: AssetImage('assets/rek1.jpg'), fit: BoxFit.fill),
                    Image(
                        image: AssetImage('assets/rek2.jpg'), fit: BoxFit.fill),
                    Image(
                        image: AssetImage('assets/rek3.jpg'), fit: BoxFit.fill),
                  ],
                  scrollDirection: Axis.horizontal,
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Primaryclor, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  children: <Widget>[
                    Text('Popüler Katagoriler'),
                    Container(
                      height: 20,
                    ),
                    SizedBox(
                        height: 130,
                        child: ScrollConfiguration(
                          behavior: MyBehavior(),
                          child: GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                childAspectRatio: 1,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: katagoriListVertical.length,
                              itemBuilder: (BuildContext ctxt, int index) {
                                var view = katagoriListVertical[index];
                                return InkWell(
                                  child: view,
                                  onTap: () {
                                    katAc(view.key.toString().substring(
                                        3, view.key.toString().length - 3));
                                  },
                                );
                              }),
                        )),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Image.asset('assets/rek3.jpg'),
              ),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                width: double.infinity,
                height: 130,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Primaryclor, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  children: <Widget>[Text('Haftanın çok satanları')],
                ),
              ),
            ];
            break;
          }
        case 1:
          {
            _pages = <Widget>[
              Visibility(
                visible: visibleFilter,
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      Divider(
                        height: 1,
                        color: Colors.black54,
                      ),
                      Container(
                        height: 5,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15, right: 5),
                        child: Row(
                          children: <Widget>[
                            Container(
                                width: 130,
                                child: Text(
                                  bUrunsay + ' adet ürün bulundu.',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w300),
                                  overflow: TextOverflow.ellipsis,
                                )),
                            InkWell(
                              onTap: () {
                                filterAcar(context, 0);
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.sort_by_alpha,
                                    color: Primaryclor,
                                  ),
                                  Container(
                                    width: 5,
                                  ),
                                  Text(
                                    'Sırala',
                                    style: (TextStyle(color: Primaryclor)),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 15,
                            ),
                            Text(
                              '|',
                              style: TextStyle(
                                  fontSize: 35, fontWeight: FontWeight.w100),
                            ),
                            Container(
                              width: 15,
                            ),
                            InkWell(
                              onTap: () {
                                filterAcar(context, 1);
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.filter_list, color: Primaryclor),
                                  Container(
                                    width: 5,
                                  ),
                                  Text(
                                    'Filtrele($bFiltsay)',
                                    style: (TextStyle(color: Primaryclor)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 5,
                      ),
                      Divider(
                        height: 1,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: visibleKatagori,
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Katagoriler',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  color: AccentHard,
                ),
              ),
              Visibility(
                visible: visibleKatagori,
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: katagoriListHorizontal.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext ctxt, int index) {
                        var view = katagoriListHorizontal[index];
                        return InkWell(
                          child: view,
                          onTap: () {
                            katAc(view.key
                                .toString()
                                .substring(3, view.key.toString().length - 3));
                          },
                        );
                      }),
                ),
              ),
              Visibility(
                visible: visibleUrun,
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      Visibility(
                        visible: visibleUrunarrow,
                        child: InkWell(
                          onTap: () {
                            katKapat();
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Primaryclor,
                          ),
                        ),
                      ),
                      Container(
                        width: 10,
                      ),
                      Text(
                        'Ürünler',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                  color: AccentHard,
                ),
              ),
              Visibility(
                visible: visibleUrun,
                child: Container(
                    margin: EdgeInsets.all(10),
                    child: ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: urunListHorizontal.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext ctxt, int index) {
                            Urundata f = urunListHorizontal[index];
                            void onClick(){
                              urunDetay(f.urunisim);
                            }
                            return UrunCell(directionisV: false,uData: f,onClick: onClick,);
                          }),
                    )),
              ),
            ];
            break;
          }
        case 2:
          {
            _pages = <Widget>[
              Center(
                  child: Text(
                'Sepetim (${sepetim.length})',
                style: TextStyle(color: Primaryclor, fontSize: 18),
              )),
              Container(
                height: 20,
              ),
              sepetim.isEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.shopping_cart,
                                  color: Primaryclor,
                                  size: 50,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Sepetinizde şuan ürün bulunmuyor.',
                                      style: TextStyle(color: Primaryclor),
                                    ),
                                    Text(
                                      'Hemen bir kaç ürüne göz at !',
                                      style: TextStyle(color: Primaryclor),
                                    ),
                                  ],
                                )
                              ],
                            )),
                        Container(
                          width: 360,
                          color: AccentHard,
                          padding: EdgeInsets.all(10),
                          child: Text('Sepetimde Neden Ürün Yok ?'),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 15, left: 5),
                            child: Text('Sepetinize eklediğiniz ürünün;')),
                        Container(
                            margin: EdgeInsets.only(left: 10, top: 5),
                            child: Text('-Ürün güncellenmiş olablir.')),
                        Container(
                            margin: EdgeInsets.only(left: 10, top: 5),
                            child: Text('-Ürün kaldırılmış olablir.'))
                      ],
                    )
                  : Container(
                      child: Column(
                      children: <Widget>[
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: sepetim.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext ctxt, int index) {
                              SepetData s = sepetim[index];
                              Urundata u = MyWidgets().urunFinder(s.uruncode);
                              void onAdetChange(i) {
                                FirebaseDatabase.instance
                                    .reference()
                                    .child('Sepetler')
                                    .child(kullaniciUid)
                                    .child(s.uruncode)
                                    .child('istekcevaplari')
                                    .child('Adet')
                                    .set(i.toString());
                              }

                              void mSil() {
                                FirebaseDatabase.instance
                                    .reference()
                                    .child('Sepetler')
                                    .child(kullaniciUid)
                                    .child(s.uruncode)
                                    .remove();
                              }

                              void mDuzenle() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SiparisDetay(
                                            uData: u,
                                            isbeforeEdited: true,
                                            duzenlecenek: s,
                                          )),
                                );
                              }

                              return SepetBox(
                                sepetData: s,
                                uData: u,
                                btnDz: mDuzenle,
                                onAdetChange: onAdetChange,
                                btnSil: mSil,
                              );
                            }),
                        Text(
                          'Tahmini Toplam: ${sepetToplamHesapla()} ₺',
                          style: TextStyle(
                              fontSize: 18, color: Colors.deepOrangeAccent),
                        ),
                        CostomButton(
                          onclick: () {
                            sendMail();
                          },
                          text: 'Siparişi onayla',
                          backgroundcolor: Colors.deepOrangeAccent,
                        )
                      ],
                    )),
            ];
            break;
          }
        case 3:
          {
            _pages = <Widget>[
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            InkWell(onTap:(){MyWidgets().photoDialogCreater(context, <String>[sirketData.uRes]);},child: CircularImageInternet(url: sirketData.uRes,widh: 125,heigh: 125,)),
                            Container(
                              width: 125,
                              child: Text(
                                sirketData.uIsim,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: Colors.black),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              width: 125,
                              child: Text(
                                sirketData.uUnvanmeslek,
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 10),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Container(
                                      height: 30,
                                    ),
                                    Container(
                                      width: 75,
                                      child: Text(
                                        'Ürün Sayısı',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 10),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      width: 75,
                                      child: Text(
                                        '0',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 10,
                                            color: Primaryclor),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Container(
                                      height: 30,
                                    ),
                                    Container(
                                      width: 75,
                                      child: Text(
                                        'Alınan Sipariş',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 10),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      width: 75,
                                      child: Text(
                                        '0',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 10,
                                            color: Primaryclor),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Container(
                                      height: 30,
                                    ),
                                    Container(
                                      width: 75,
                                      child: Text(
                                        'Derecelendirme',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 10),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      width: 75,
                                      child: Text(
                                        sirketData.uSirketpuan.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 10,
                                            color: Primaryclor),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            CostomButton(
                              text: 'Bilgileri Düzenle',
                              onclick: () {},
                              backgroundcolor: Colors.deepOrange.withAlpha(200),
                              pressclor: Colors.deepOrangeAccent,
                              textcolor: Colors.white,
                              textsize: 12,
                              widh: 150,
                              padding: EdgeInsets.only(top: 20),
                            )
                          ],
                        ),
                      ],
                    ),
                    CostomButton(
                      onclick: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SiparisGelen(gelenlerS: gelenlerS,)));
                      },
                      text: 'Gelen Siparişler(${gelenlerS.length})',
                      backgroundcolor: Colors.blueAccent,
                      widh: 300,
                      pressclor: Colors.lightBlueAccent,
                    )
                  ],
                ),
              ),
              TabCircular(context)
            ];
            break;
          }
        case 4:
          {
            _pages = <Widget>[
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(bottom: 10, top: 10),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      InkWell(onTap:(){MyWidgets().photoDialogCreater(context,<String>[kullaniciData.kRes]);},child: CircularImageInternet(url: kullaniciData.kRes,widh: 125,heigh: 125,border: true,)),
                      Container(
                        width: 125,
                        child: Text(
                          kullaniciData.kIsim,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: 125,
                        child: Text(
                          kullaniciData.kUnvanmeslek,
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 10),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 2,
              ),
              HorizontalIconButtton(
                onclick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditorStarter()),
                  );
                },
                text: 'Yarım Kalanlar',
                paddingtext: EdgeInsets.all(10),
                notification: sepetimBekleyen.isNotEmpty,
                notificationtext: sepetimBekleyen.length.toString(),
              ),
              HorizontalIconButtton(
                onclick: () {},
                text: 'Aldıklarım',
                paddingtext: EdgeInsets.all(10),
              ),
              HorizontalIconButtton(
                onclick: () {},
                text: 'Favorilerim',
                paddingtext: EdgeInsets.all(10),
              ),
              HorizontalIconButtton(
                onclick: () {},
                text: 'Mesajlarım',
                paddingtext: EdgeInsets.all(10),
              ),
              HorizontalIconButtton(
                onclick: () {},
                text: 'Bilgilerim',
                paddingtext: EdgeInsets.all(10),
              ),
              HorizontalIconButtton(
                onclick: () {},
                text: 'Yardım&Destek',
                paddingtext: EdgeInsets.all(10),
              ),
              HorizontalIconButtton(
                onclick: () {},
                text: 'Bildirim Ayarları',
                paddingtext: EdgeInsets.all(10),
              ),
              HorizontalIconButtton(
                onclick: () {
                  cikis();
                },
                text: 'Çıkış Yap',
                paddingtext: EdgeInsets.all(10),
              ),
            ];
            break;
          }
        default:
          {
            _pages = <Widget>[];
            break;
          }
      }
    });
  }

  katagoriOlustur() {
    katagoriListVertical.clear();
    katagoriListHorizontal.clear();
    setState(() {
      katagoriler.forEach((f) {
        katagoriListVertical.add(MyWidgets().mKatagorimVertical(
            f.katagori, f.baslik1, f.baslik2, f.toplamurun, f.katalogres));
        katagoriListHorizontal.add(MyWidgets().mKatagorimHorizontal(
            f.katagori, f.baslik1, f.baslik2, f.toplamurun, f.katalogres));
      });
      _pager(_indexnow);
    });
  }

  katagoriOlusturS() {
    katagoriListHorizontal.clear();
    setState(() {
      katagorilerF.forEach((f) {
        katagoriListHorizontal.add(MyWidgets().mKatagorimHorizontal(
            f.katagori, f.baslik1, f.baslik2, f.toplamurun, f.katalogres));
      });
      _pager(_indexnow);
    });
  }

  urunOlustur(List<Urundata> urunListim) {
    urunListHorizontal.clear();
    filterSayisiHsp();
    setState(() {
      bUrunsay = urunListim.length.toString();
      urunListim.forEach((f) {
        urunListHorizontal.add(f);
      });
      _pager(_indexnow);
    });
  }

  urunCek() {
    var ref = FirebaseDatabase.instance.reference().child("Urunler");
    ref.onValue.listen((onData) {
      urunler.clear();
      murunYarim.clear();
      Map<dynamic, dynamic> valuesust = onData.snapshot.value;
      valuesust.forEach((keyu, valu) {
        var katagori = valu as Map<dynamic, dynamic>;
        katagori.forEach((key, val) {
          var deger = val as Map<dynamic, dynamic>;
          if (deger['tasarim'] != null) {
            var data = Urundata.finaly(
              deger['urunres'],
              deger['urunisim'],
              deger['baslik1'],
              deger['baslik2'],
              deger['deger'].toDouble(),
              deger['degerlendirensay'],
              deger['ulasmasur'],
              deger['oncelik'],
              deger['ureticiuid'],
              deger['ureticiisim'],
              deger['ureticires'],
              deger['bulundugukatagori'],
              deger['fiyat'].toDouble(),
              deger['kargo'],
              deger['renk'],
              deger['tasarim'],
              deger['sampleres'],
            );
            urunler.add(data);
          } else if (deger['ureticiuid'] == kullaniciUid) {
            var data = Urundata.halfed(
                deger['urunres'],
                deger['urunisim'],
                deger['baslik1'],
                deger['baslik2'],
                deger['deger'].toDouble(),
                deger['degerlendirensay'],
                deger['ulasmasur'],
                deger['oncelik'],
                deger['ureticiuid'],
                deger['ureticiisim'],
                deger['ureticires'],
                deger['bulundugukatagori'],
                deger['fiyat'].toDouble());
            murunYarim.add(data);
          }
        });
      });
      filtrele(Filterdata(siralamasecili, katagorisecili, renksecili, tassecili,
          kargosecili, fiyatk, fiyatb, kelimesecili));
    });
  }

  katagoriCek() {
    var ref = FirebaseDatabase.instance.reference().child("Katagoriler");
    ref.onValue.listen((onData) {
      katagoriler.clear();
      Map<dynamic, dynamic> values = onData.snapshot.value;
      values.forEach((key, val) {
        var deger = val as Map<dynamic, dynamic>;
        var data = Katagoridata(
            deger['katalogres'],
            deger['katagori'],
            deger['baslik1'],
            deger['baslik2'],
            deger['toplamurun'],
            deger['toplamurun']);
        katagoriler.add(data);
      });
      katagoriOlustur();
    });
  }

  forwardAnim() {
    switch (positionAnimation) {
      case 0:
        {
          setState(() {
            visibleArrowback = true;
            _indexnow = 1;
            _pager(1);
          });
          animation = Tween<double>(begin: 0, end: 500).animate(controller);
          controller.reset();
          controller.forward();
          break;
        }
      case 1:
        {
          FocusScope.of(context).requestFocus(FocusNode());
          setState(() {
            cSearch.text = '';
          });
          animation = Tween<double>(begin: 500, end: 0).animate(controller);
          controller.reset();
          controller.forward();
          break;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: MaterialApp(
          home: Scaffold(
            backgroundColor: AccentLight,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Visibility(
                    visible: visibleArrowback,
                    child: Opacity(
                      opacity: opactyArrow,
                      child: Transform.translate(
                        offset: Offset(ofsetxArrow, 0),
                        child: Container(
                          padding: EdgeInsets.only(right: 60),
                          child: GestureDetector(
                            onTap: () {
                              forwardAnim();
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Primaryclor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 25.0,
                                        spreadRadius: 1.0)
                                  ],
                                ),
                                width: 30,
                                height: 30,
                                child: Center(
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: visibleText,
                    child: Opacity(
                      opacity: opactytext,
                      child: Transform.translate(
                        offset: Offset(0, 0),
                        child: Container(
                          width: widhtext,
                          child: TextField(
                            controller: cSearch,
                            style: TextStyle(color: Primaryclor),
                            decoration: InputDecoration(
                                hintText: "Ne arıyorsunuz.",
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Primaryclor.withAlpha(180))),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: visibleSerch,
                    child: Opacity(
                      opacity: opactysearch,
                      child: Transform.translate(
                        offset: Offset(_ofsetxsearch, 0),
                        child: GestureDetector(
                          onTap: () {
                            forwardAnim();
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                color: Primaryclor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 25.0,
                                      spreadRadius: 1.0)
                                ],
                              ),
                              width: 35,
                              height: 35,
                              child: Center(
                                child: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                              )),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            bottomNavigationBar: CurvedNavigationBar(
              color: Colors.white,
              index: _indexnow,
              buttonBackgroundColor: Colors.grey.withAlpha(180),
              backgroundColor: Primaryclor.withAlpha(80),
              items: <Widget>[
                Icon(
                  Icons.home,
                  size: 30,
                  color:_indexnow==0?Primaryclor:Colors.grey,
                ),
                Icon(
                  Icons.list,
                  size: 30,
                  color: _indexnow==1?Primaryclor:Colors.grey,
                ),
                Icon(
                  Icons.shopping_cart,
                  size: 30,
                  color: _indexnow==2?Primaryclor:Colors.grey,
                ),
                Icon(
                  Icons.business,
                  size: 30,
                  color: _indexnow==3?Primaryclor:Colors.grey,
                ),
                Icon(
                  Icons.person,
                  size: 30,
                  color: _indexnow==4?Primaryclor:Colors.grey,
                ),
              ],
              height: 50,
              onTap: (index) {
                if (positionAnimation == 1) {
                  forwardAnim();
                }
                _indexnow = index;
                _pager(index);
              },
            ),
            body: SingleChildScrollView(
                child: visibleisLoaind
                    ? SplashScreen(
                        contex: context,
                        backgroundcolor: Colors.white,
                        logocolor: Primaryclor,
                        subcolor: Colors.black,
                        textprogress: loadingProgressT,
                      )
                    : Column(
                        children: _pages,
                      )),
          ),
        ));
  }
}
