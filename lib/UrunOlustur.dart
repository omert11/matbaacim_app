import 'dart:io';

import 'package:fexm/MyWidgets.dart';
import 'package:fexm/datas/istekdata.dart';
import 'package:fexm/datas/urundata.dart';
import 'package:fexm/mCustomWIdgets/CostomButton.dart';
import 'package:fexm/mCustomWIdgets/CostomTextField.dart';
import 'package:fexm/mCustomWIdgets/HorizontalIconButton.dart';
import 'package:fexm/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'mCustomWIdgets/CircularImageInternet.dart';

class UrunOlustur extends StatefulWidget {
  final String urunis;
  final bool yenimi;

  UrunOlustur(this.urunis, this.yenimi);

  @override
  _UrunOlustur createState() => _UrunOlustur(urunis, yenimi);
}

class _UrunOlustur extends State<UrunOlustur> {
  _UrunOlustur(this.urunis, this.yenimi);

  String urunis;
  bool yenimi;
  Urundata mData;
  String katagorishower = 'Henüz bir katagori seçmediniz.';
  var cUrunadi = TextEditingController();
  var cBaslik1 = TextEditingController();
  var cBaslik2 = TextEditingController();
  var cUlasmasur = TextEditingController();
  var cFiyat = TextEditingController();
  bool erroredRes = false;
  bool erroredKat = false;
  bool erroredIsim = false;
  bool erroredBas1 = false;
  bool erroredBas2 = false;
  bool erroredUlsur = false;
  bool erroredFiyat = false;
  bool visibOlustur = true;
  bool visibWaiter = false;
  bool once = false;
  bool isFileorUrl = true;
  Widget page;
  int secilikat;
  int secilirenk;
  int secilikarg;
  int secilitas;
  int pThis = 0;
  File image;
  File sampleimage;
  String imageurl;
  String tSecilirenk = 'Seçilmedi';
  String tSecilikarg = 'Seçilmedi';
  String tSecilitasarim = 'Seçilmedi';
  String tProggres = '';
  String tPossitive = 'Devam Et';
  String tNegative = 'İptal';
  String tBaslik = 'Ürün Oluştur';
  List<Widget> fonks = <Widget>[];
  List<Istekdata> fonkMir = <Istekdata>[];

  Future getImage() async {
    var imagee = await ImagePicker.pickImage(source: ImageSource.gallery);
    var imagge = await ImageCropper.cropImage(
        sourcePath: imagee.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Primaryclor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    setState(() {
      image = imagge;
      if (image != null) {
        erroredRes = true;
        paGer(0);
      } else {
        erroredRes = false;
        paGer(0);
      }
    });
  }

  saver(String sampleref) {
    var dataG = Urundata.finaly(
        mData.urunres,
        mData.urunisim,
        mData.baslik1,
        mData.baslik2,
        mData.deger,
        mData.degerlendirensay,
        mData.ulasmasur,
        mData.oncelik,
        mData.ureticiuid,
        mData.ureticiisim,
        mData.ureticires,
        mData.bulundugukatagori,
        mData.fiyat,
        kargosecili,
        renksecili,
        tassecili,
        sampleref);
    final nUrun = cUrunadi.text + kullaniciUid.substring(0, 3);
    var taskdata = FirebaseDatabase.instance
        .reference()
        .child('Urunler')
        .child(mData.bulundugukatagori)
        .child(nUrun)
        .set(dataG.toJson());
    taskdata.whenComplete(() {
      int index = 0;
      fonkMir.forEach((fonkAdd) {
        FirebaseDatabase.instance
            .reference()
            .child('Urunler')
            .child(mData.bulundugukatagori)
            .child(nUrun)
            .child('siparisistegim')
            .child(index.toString())
            .set(fonkAdd.toJson());
        if (fonkAdd == fonkMir.last) {
          Navigator.pop(context, null);
        } else {
          index++;
        }
      });
    });
  }

  devamEt() async {
    switch (pThis) {
      case 0:
        {
          setState(() {
            cFiyat.text.isEmpty ? erroredFiyat = true : erroredFiyat = false;
            cUlasmasur.text.isEmpty
                ? erroredUlsur = true
                : erroredFiyat = false;
            cBaslik1.text.isEmpty ? erroredBas1 = true : erroredFiyat = false;
            cBaslik2.text.isEmpty ? erroredBas2 = true : erroredFiyat = false;
            cUrunadi.text.isEmpty ? erroredIsim = true : erroredFiyat = false;
            paGer(0);
          });
          if (erroredKat &&
              erroredRes &&
              !erroredIsim &&
              !erroredBas1 &&
              !erroredBas2 &&
              !erroredUlsur &&
              !erroredFiyat) {
            try {
              var myF = double.parse(cFiyat.text);
              if (myF > 0) {
                setState(() {
                  visibOlustur = false;
                  visibWaiter = true;
                });
                final nUrun = cUrunadi.text + kullaniciUid.substring(0, 3);
                final nKatagori = katagoriler[secilikat].katagori;
                StorageUploadTask task = FirebaseStorage.instance
                    .ref()
                    .child('KatagoriDatasi')
                    .child(nKatagori)
                    .child(nUrun + '.png')
                    .putFile(image);
                task.events.listen((onData) {
                  setState(() {
                    double _progress =
                        (onData.snapshot.bytesTransferred.toDouble() /
                                onData.snapshot.totalByteCount.toDouble()) *
                            100;
                    tProggres = "%$_progress yüklendi.";
                  });
                });
                String url = await (await task.onComplete).ref.getDownloadURL();
                setState(() {
                  tProggres = "Kayıt tamamlanıyor lütfen bekleyiniz.";
                });
                mData = Urundata.halfed(
                    url,
                    cUrunadi.text,
                    cBaslik1.text,
                    cBaslik2.text,
                    0,
                    '0',
                    cUlasmasur.text,
                    10,
                    kullaniciUid,
                    sirketData.uIsim,
                    sirketData.uRes,
                    nKatagori,
                    double.parse(cFiyat.text));
                var taskdata = FirebaseDatabase.instance
                    .reference()
                    .child('Urunler')
                    .child(nKatagori)
                    .child(nUrun)
                    .set(mData.toJson());
                taskdata.whenComplete(() {
                  setState(() {
                    visibWaiter = false;
                    visibOlustur = true;

                    paGer(1);
                  });
                });
              } else {
                setState(() {
                  cFiyat.text = '';
                  paGer(0);
                });
              }
            } catch (s) {
              setState(() {
                cFiyat.text = '';
                paGer(0);
              });
            }
          }
          break;
        }
      case 1:
        {
          if (secilitas != null && secilikarg != null && secilirenk != null) {
            if (secilitas != 2) {
              paGer(3);
            } else {
              paGer(2);
            }
          }
          break;
        }
      case 2:
        {
          String sampleref;
          setState(() {
            visibOlustur = false;
            visibWaiter = true;
          });
          if (sampleimage != null) {
            StorageUploadTask mtask = FirebaseStorage.instance
                .ref()
                .child('UreticiDatasi')
                .child(kullaniciUid)
                .child(mData.urunisim + 'sample.png')
                .putFile(sampleimage);
            mtask.onComplete.then((val) async {
              sampleref = await val.ref.getDownloadURL();
              saver(sampleref);
            });
          } else {
            saver(sampleref);
          }
          break;
        }
      case 3:
        {
          if (sampleimage != null) {
            paGer(2);
          }
        }
    }
  }

  int _indexfinder(Istekdata istek) {
    int k = 0;
    bool aramada = true;
    fonkMir.forEach((eached) {
      if (eached == istek && aramada) {
        aramada = false;
      } else if (aramada) {
        k++;
      }
    });
    return k;
  }

  fonkEkler(Istekdata mFonkData) {
    fonkMir.add(mFonkData);
    switch (mFonkData.type) {
      case 0:
        {
          fonks.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CostomTextField(
                hint: mFonkData.istenecek,
                label: mFonkData.istenecek,
                widh: 270,
                padding: EdgeInsets.all(5),
                border: true,
                controller: null,
              ),
              InkWell(
                  onTap: () {
                    int removedind = _indexfinder(mFonkData);
                    fonks.removeAt(removedind);
                    fonkMir.removeAt(removedind);
                    paGer(2);
                  },
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.deepOrangeAccent,
                    size: 40,
                  ))
            ],
          ));
          break;
        }
      case 1:
        {
          fonks.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  width: 270,
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Primaryclor),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: <Widget>[
                      Text(
                        mFonkData.istenecek,
                        style: TextStyle(
                            fontSize: 16,
                            color: Primaryclor,
                            fontWeight: FontWeight.w700),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Image.asset(
                            'assets/matbaacim_t.png',
                            height: 100,
                            width: 100,
                          ),
                          RaisedButton(
                            onPressed: () {},
                            color: Colors.green,
                            focusColor: Colors.lightGreen,
                            child: Text(
                              'Resim Seç',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          )
                        ],
                      ),
                    ],
                  )),
              InkWell(
                  onTap: () {
                    int removedind = _indexfinder(mFonkData);
                    fonks.removeAt(removedind);
                    fonkMir.removeAt(removedind);
                    paGer(2);
                  },
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.deepOrangeAccent,
                    size: 40,
                  ))
            ],
          ));
          break;
        }
      case 2:
        {
          fonks.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 270,
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Primaryclor),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                margin: EdgeInsets.only(top: 5),
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(mFonkData.istenecek),
                    Switch(
                      onChanged: (inactive) {},
                      value: true,
                    ),
                  ],
                ),
              ),
              InkWell(
                  onTap: () {
                    int removedind = _indexfinder(mFonkData);
                    fonks.removeAt(removedind);
                    fonkMir.removeAt(removedind);
                    paGer(2);
                  },
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.deepOrangeAccent,
                    size: 40,
                  ))
            ],
          ));
          break;
        }
      case 3:
        {
          var lisofmRad = <Widget>[];
          int k = 0;
          mFonkData.list.forEach((eachedI) {
            lisofmRad.add(MyWidgets().mRadioButton(
                mFonkData.list[k],
                k,
                null,
                (d) {},
                Colors.transparent,
                AccentHard,
                Colors.black54,
                14,
                270,
                1,
                EdgeInsets.only(left: 10)));
            k++;
          });
          fonks.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  width: 270,
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Primaryclor),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: <Widget>[
                      Text(
                        mFonkData.istenecek,
                        style: TextStyle(
                            fontSize: 16,
                            color: Primaryclor,
                            fontWeight: FontWeight.w700),
                      ),
                      Column(
                        children: lisofmRad,
                      )
                    ],
                  )),
              InkWell(
                  onTap: () {
                    int removedind = _indexfinder(mFonkData);
                    fonks.removeAt(removedind);
                    fonkMir.removeAt(removedind);
                    paGer(2);
                  },
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.deepOrangeAccent,
                    size: 40,
                  ))
            ],
          ));
          break;
        }
    }
    paGer(2);
  }

  Future samplePicker() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    var imagge = await ImageCropper.cropImage(
        compressFormat: ImageCompressFormat.png,
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Düzenle',
            toolbarColor: Primaryclor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    setState(() {
      if (imagge != null) {
        sampleimage = imagge;
        paGer(3);
      }
    });
  }

  adder() async {
    Istekdata result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Fonkolusturucu(0)));
    if (result != null) {
      fonkEkler(result);
    }
  }

  katSeciciAcar() async {
    int result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => KatseciciFrag()),
    );
    if (result != null) {
      setState(() {
        secilikat = result;
        katagorishower = katagoriler[result].katagori;
        erroredKat = true;
        paGer(0);
      });
    } else {
      setState(() {
        secilikat = null;
        katagorishower = 'Henüz bir katagori seçmediniz.';
        erroredKat = false;
        paGer(0);
      });
    }
  }

  tiklananR(int id) {
    setState(() {
      secilirenk = id;
      tSecilirenk = id == 0
          ? 'Tümü'
          : id == 1
              ? 'Tek renk'
              : id == 2 ? 'Çift renk' : id == 3 ? 'Üç renk' : 'Dört renk';
      paGer(1);
    });
  }

  tiklananK(int id) {
    setState(() {
      secilikarg = id;
      tSecilikarg = id == 0 ? 'Tümü' : 'Ücretsiz kargo';
      paGer(1);
    });
  }

  tiklananT(int id) {
    setState(() {
      secilitas = id;
      tSecilitasarim = id == 0
          ? 'Tümü'
          : id == 1 ? 'Kullanıcı tarafından' : 'Şirket tarafından';
      paGer(1);
    });
  }

  paGer(int pag) {
    setState(() {
      switch (pag) {
        case 0:
          {
            pThis = 0;
            page = Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  CostomButton(
                    text: 'Resim seç',
                    onclick: () {
                      getImage();
                    },
                    backgroundcolor: Colors.deepOrangeAccent,
                    pressclor: Colors.deepOrangeAccent.withAlpha(30),
                    textsize: 10,
                    radius: 10,
                    widh: 150,
                    padding: EdgeInsets.all(3),
                  ),
                  Visibility(
                    visible: !erroredRes,
                    child: Text(
                      'Lütfen bir resim seçiniz',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(katagorishower,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Colors.red)),
                      CostomButton(
                        text: 'Katagori seç',
                        onclick: () {
                          katSeciciAcar();
                        },
                        backgroundcolor: Colors.deepOrangeAccent,
                        pressclor: Colors.deepOrangeAccent.withAlpha(30),
                        textsize: 10,
                        radius: 10,
                        widh: 150,
                        padding: EdgeInsets.all(3),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: !erroredKat,
                    child: Text(
                      'Lütfen bir katagori seçiniz',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  CostomTextField(
                    hint: 'Kullanıcıların göreceği isimi giriniz.',
                    label: 'Ürün adı',
                    errored: erroredIsim,
                    errortext: cUrunadi.text.isEmpty
                        ? 'Ürün adı zorunlu alandır'
                        : 'Ürünle aynı isimde başka bir ürün var',
                    controller: cUrunadi,
                    border: true,
                    padding: EdgeInsets.all(10),
                  ),
                  CostomTextField(
                    hint: 'Kullanıcıların göreceği bir açıklama giriniz.',
                    label: 'Başlık 1',
                    errored: erroredBas1,
                    errortext: 'Zorunlu alandır',
                    controller: cBaslik1,
                    border: true,
                    padding: EdgeInsets.all(10),
                  ),
                  CostomTextField(
                    hint: 'Kullanıcıların göreceği bir açıklama giriniz.',
                    label: 'Başlık 2',
                    errored: erroredBas2,
                    errortext: 'Zorunlu alandır',
                    controller: cBaslik2,
                    border: true,
                    padding: EdgeInsets.all(10),
                  ),
                  CostomTextField(
                    hint: 'Gün cinsinden ortalama ulaşma süresi.',
                    label: 'Ürün ulaşma süresi',
                    errored: erroredUlsur,
                    errortext: 'Zorunlu alandır',
                    inputType: TextInputType.number,
                    controller: cUlasmasur,
                    border: true,
                    padding: EdgeInsets.all(10),
                  ),
                  CostomTextField(
                    hint: 'Adet başına ortalama bir fiyat giriniz.',
                    label: 'Ürün Fiyat',
                    inputType: TextInputType.numberWithOptions(decimal: true),
                    errored: erroredFiyat,
                    errortext: 'Lütfen geçerli bir fiyatlandırma giriniz.',
                    controller: cFiyat,
                    border: true,
                    padding: EdgeInsets.all(10),
                  ),
                ],
              ),
            );
            break;
          }
        case 1:
          {
            pThis = 1;
            if (!once) {
              if (mData == null) {
                murunYarim.forEach((eached) {
                  if (eached.urunisim == urunis) {
                    mData = eached;
                  }
                });
              }
              isFileorUrl = false;
              imageurl = mData.urunres;
              cUrunadi.text = mData.urunisim;
              cBaslik1.text = mData.baslik1;
              cBaslik2.text = mData.baslik2;
              cUlasmasur.text = mData.ulasmasur;
              cFiyat.text = mData.fiyat.toString();
              tPossitive = 'Devam Et';
              tNegative = 'Daha Sonra';
              tBaslik = 'Ürün Özellikleri';
              once = true;
            }
            page = Container(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 0.5, color: Colors.black54),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Renk Özelliği'),
                            Text(
                              tSecilirenk,
                              style: TextStyle(color: Primaryclor),
                            )
                          ],
                        ),
                        Text(
                          'Renk seçeğeniz yoksa tümü olarak kalması önerilir',
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 12),
                        ),
                        MyWidgets().mRadioButton(
                            'Tümü',
                            0,
                            secilirenk,
                            tiklananR,
                            Colors.white,
                            AccentHard,
                            Colors.black87,
                            12,
                            350,
                            1,
                            EdgeInsets.only(left: 10)),
                        MyWidgets().mRadioButton(
                            'Tek renk',
                            1,
                            secilirenk,
                            tiklananR,
                            Colors.white,
                            AccentHard,
                            Colors.black87,
                            12,
                            350,
                            1,
                            EdgeInsets.only(left: 10)),
                        MyWidgets().mRadioButton(
                            'Çift renk',
                            2,
                            secilirenk,
                            tiklananR,
                            Colors.white,
                            AccentHard,
                            Colors.black87,
                            12,
                            350,
                            1,
                            EdgeInsets.only(left: 10)),
                        MyWidgets().mRadioButton(
                            'Üç renk',
                            3,
                            secilirenk,
                            tiklananR,
                            Colors.white,
                            AccentHard,
                            Colors.black87,
                            12,
                            350,
                            1,
                            EdgeInsets.only(left: 10)),
                        MyWidgets().mRadioButton(
                            'Dört renk',
                            4,
                            secilirenk,
                            tiklananR,
                            Colors.white,
                            AccentHard,
                            Colors.black87,
                            12,
                            350,
                            1,
                            EdgeInsets.only(left: 10)),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 0.5, color: Colors.black54),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Kargo Durumu'),
                            Text(
                              tSecilikarg,
                              style: TextStyle(color: Primaryclor),
                            )
                          ],
                        ),
                        Text(
                          'Renk seçeğeniz yoksa tümü olarak kalması önerilir',
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 12),
                        ),
                        MyWidgets().mRadioButton(
                            'Tümü',
                            0,
                            secilikarg,
                            tiklananK,
                            Colors.white,
                            AccentHard,
                            Colors.black87,
                            12,
                            350,
                            1,
                            EdgeInsets.only(left: 10)),
                        MyWidgets().mRadioButton(
                            'Ücretsiz kargo',
                            1,
                            secilikarg,
                            tiklananK,
                            Colors.white,
                            AccentHard,
                            Colors.black87,
                            12,
                            350,
                            1,
                            EdgeInsets.only(left: 10)),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 0.5, color: Colors.black54),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Tasarım Özelliği'),
                            Text(
                              tSecilitasarim,
                              style: TextStyle(color: Primaryclor),
                            )
                          ],
                        ),
                        Text(
                          'Tasarım seçeğeniz yoksa tümü olarak kalması önerilir',
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 12),
                        ),
                        MyWidgets().mRadioButton(
                            'Tümü',
                            0,
                            secilitas,
                            tiklananT,
                            Colors.white,
                            AccentHard,
                            Colors.black87,
                            12,
                            350,
                            1,
                            EdgeInsets.only(left: 10)),
                        MyWidgets().mRadioButton(
                            'Kullanıcı tarafından',
                            1,
                            secilitas,
                            tiklananT,
                            Colors.white,
                            AccentHard,
                            Colors.black87,
                            12,
                            350,
                            1,
                            EdgeInsets.only(left: 10)),
                        MyWidgets().mRadioButton(
                            'Şirket tarafından',
                            2,
                            secilitas,
                            tiklananT,
                            Colors.white,
                            AccentHard,
                            Colors.black87,
                            12,
                            350,
                            1,
                            EdgeInsets.only(left: 10)),
                      ],
                    ),
                  ),
                ],
              ),
            );
            break;
          }
        case 2:
          {
            pThis = 2;
            tPossitive = 'Tamamla';
            tNegative = 'Daha Sonra';
            tBaslik = 'Sipariş İstekleri';
            page = Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 0.5, color: Colors.black54),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('İstenecekler'),
                      InkWell(
                        onTap: () {
                          adder();
                        },
                        child: Text(
                          'Fonksiyon Ekle',
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.w700),
                        ),
                      )
                    ],
                  ),
                  Column(children: fonks)
                ],
              ),
            );
            break;
          }
        case 3:
          {
            pThis = 3;
            tPossitive = 'Devam Et';
            tNegative = 'Daha Sonra';
            tBaslik = 'Şablon';
            page = Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 0.5, color: Colors.black54),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Ürününüz İçin Şablon'),
                      InkWell(
                        onTap: () {
                          samplePicker();
                        },
                        child: Text(
                          'Şablon Ekle',
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.w700),
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: 10,
                  ),
                  Text(
                    'Yüksek çözünürlüklü bir şablon eklemenizi öneririz.',
                    style: TextStyle(
                        color: BlackLight,
                        fontSize: 10,
                        fontWeight: FontWeight.w200),
                  ),
                  Container(
                    height: 5,
                  ),
                  Text(
                    'Şablon üstünde marka,resim ve yazı bulunmamalı.',
                    style: TextStyle(
                        color: BlackLight,
                        fontSize: 10,
                        fontWeight: FontWeight.w200),
                  ),
                  sampleimage != null ? Image.file(sampleimage) : Container(),
                ],
              ),
            );
            break;
          }
      }
    });
  }

  bool isimKontrol(String tKnt) {
    if (tKnt.isEmpty) {
      return true;
    } else {
      var k = false;
      urunler.forEach((eached) {
        if (eached.urunisim.toLowerCase() == tKnt.toLowerCase()) {
          k = true;
        }
      });
      return k;
    }
  }

  @override
  void initState() {
    yenimi ? paGer(0) : paGer(1);
    cUrunadi.addListener(() {
      setState(() {
        erroredIsim = isimKontrol(cUrunadi.text);
        paGer(pThis);
      });
    });
    cBaslik1.addListener(() {
      setState(() {
        cBaslik1.text.isEmpty ? erroredBas1 = true : erroredBas1 = false;
        paGer(pThis);
      });
    });
    cBaslik2.addListener(() {
      setState(() {
        cBaslik2.text.isEmpty ? erroredBas2 = true : erroredBas2 = false;
        paGer(pThis);
      });
    });
    cUlasmasur.addListener(() {
      setState(() {
        cUlasmasur.text.isEmpty ? erroredUlsur = true : erroredUlsur = false;
        paGer(pThis);
      });
    });
    cFiyat.addListener(() {
      setState(() {
        cFiyat.text.isEmpty ? erroredFiyat = true : erroredFiyat = false;
        paGer(pThis);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: AccentHard,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Visibility(
                visible: visibOlustur,
                child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: EdgeInsets.only(
                        left: 15, right: 15, top: 50, bottom: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 100,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context, null);
                            },
                            child: Text(
                              tNegative,
                              style: TextStyle(
                                  color: Primaryclor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: null,
                          child: Text(
                            tBaslik,
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                        Container(
                          width: 100,
                          child: InkWell(
                            onTap: () {
                              devamEt();
                            },
                            child: Text(
                              tPossitive,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: Primaryclor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
              Visibility(
                visible: visibOlustur,
                child: Container(
                  width: 360,
                  height: 30,
                  margin: EdgeInsets.only(top: 15),
                  color: Colors.deepOrangeAccent,
                  child: Center(
                    child: Text(
                      'Önizleme',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: visibOlustur,
                child: Container(
                  height: 10,
                ),
              ),
              Visibility(
                visible: visibOlustur,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Primaryclor),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 120,
                        color: Colors.white,
                        height: 120,
                        child: Center(
                          child: isFileorUrl
                              ? (image == null
                                  ? Text(
                                      'RESİM SEÇİNİZ',
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.w500),
                                    )
                                  : MyWidgets().mCircularImage(
                                      image, 100, 100, EdgeInsets.all(10)))
                              : imageurl == null
                                  ? Text(
                                      'URL ALINAMADI',
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.w500),
                                    )
                                  :CircularImageInternet(url: imageurl,widh: 100,heigh: 100,padding: EdgeInsets.all(10),),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            width: 210,
                            child: Text(
                              cUrunadi.text,
                              style: TextStyle(fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            width: 210,
                            child: Text(cBaslik1.text,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 12),
                                overflow: TextOverflow.ellipsis),
                          ),
                          Container(
                            width: 210,
                            child: Text(cBaslik2.text,
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 11),
                                overflow: TextOverflow.ellipsis),
                          ),
                          Container(
                            width: 210,
                            child: Text(cUlasmasur.text + ' gün.',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 10),
                                overflow: TextOverflow.ellipsis),
                          ),
                          Container(
                            width: 210,
                            child: Text(cFiyat.text + ' ₺',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 10,
                                    color: Primaryclor),
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: visibOlustur,
                child: Container(
                  height: 20,
                ),
              ),
              Visibility(visible: visibOlustur, child: page),
              MyWidgets().splashscreen(visibWaiter, visibWaiter, visibWaiter,
                  visibWaiter, tProggres, context)
            ],
          ),
        ),
      ),
    );
  }
}

class Fonkolusturucu extends StatefulWidget {
  final int paG;

  Fonkolusturucu(this.paG);

  @override
  _Fonkolusturucu createState() => _Fonkolusturucu(paG);
}

class _Fonkolusturucu extends State<Fonkolusturucu> {
  int paG;

  _Fonkolusturucu(this.paG);

  int radGid;
  TextEditingController mcnt = TextEditingController();
  List<Widget> mPage = <Widget>[];
  List<String> mRads = <String>[];
  List<Widget> mRads2 = <Widget>[];

  @override
  void initState() {
    paGer(paG);
    super.initState();
  }

  radGunceller() {
    mRads2.clear();
    setState(() {
      mRads.forEach((eached) {
        mRads2.add(MyWidgets().mRadioButton(
            eached,
            0,
            null,
            (e) {},
            Colors.white,
            AccentHard,
            Colors.black54,
            12,
            300,
            1,
            EdgeInsets.only(left: 10)));
      });
      paGer(paG);
    });
  }

  paGer(int pGe) {
    setState(() {
      switch (pGe) {
        case 0:
          {
            mPage = <Widget>[
              HorizontalIconButtton(
                onclick: () async {
                  Istekdata result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Fonkolusturucu(1)));
                  if (result != null) {
                    Navigator.pop(context, result);
                  }
                },
                text: 'Yazı kutusu',
                paddingtext: EdgeInsets.only(left: 14),
              ),
              HorizontalIconButtton(
                onclick: () async {
                  Istekdata result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Fonkolusturucu(2)));
                  if (result != null) {
                    Navigator.pop(context, result);
                  }
                },
                text: 'Resim kutusu',
                paddingtext: EdgeInsets.only(left: 14),
              ),
              HorizontalIconButtton(
                onclick: () async {
                  Istekdata result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Fonkolusturucu(3)));
                  if (result != null) {
                    Navigator.pop(context, result);
                  }
                },
                text: 'Seçim Anahtarı',
                paddingtext: EdgeInsets.only(left: 14),
              ),
              HorizontalIconButtton(
                onclick: () async {
                  Istekdata result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Fonkolusturucu(4)));
                  if (result != null) {
                    Navigator.pop(context, result);
                  }
                },
                text: 'Çoktan seçim',
                paddingtext: EdgeInsets.only(left: 14),
              ),
            ];
            break;
          }
        case 1:
          {
            mPage = <Widget>[
              CostomTextField(
                hint: 'Kullanıcıdan isteyeceğiniz özelliği giriniz.',
                label: 'İstenecek Özellik',
                controller: mcnt,
                widh: 360,
                padding: EdgeInsets.all(5),
                border: true,
              ),
              Text('Yazı kutusu hangi yazım tipini alacak?'),
              MyWidgets().mRadioButton('Tam Sayı', 0, radGid, (r) {
                setState(() {
                  radGid = r;
                  paGer(paG);
                });
              }, Colors.white, AccentHard, Colors.black54, 14, 300, 1,
                  EdgeInsets.only(left: 10)),
              MyWidgets().mRadioButton('Virgüllü Sayı', 1, radGid, (r) {
                setState(() {
                  radGid = r;
                  paGer(paG);
                });
              }, Colors.white, AccentHard, Colors.black54, 14, 300, 1,
                  EdgeInsets.only(left: 10)),
              MyWidgets().mRadioButton('Düz yazı(Rakamda Alabilir)', 2, radGid,
                  (r) {
                setState(() {
                  radGid = r;
                  paGer(paG);
                });
              }, Colors.white, AccentHard, Colors.black54, 14, 300, 1,
                  EdgeInsets.only(left: 10)),
              CostomButton(
                text: 'Oluştur',
                onclick: () {
                  if (mcnt.text.isNotEmpty && radGid != null) {
                    Navigator.pop(context, Istekdata.yazi(radGid, mcnt.text, 0));
                  }
                },
                backgroundcolor: Colors.deepOrangeAccent,
                pressclor: Primaryclor,
                radius: 5,
                widh: 200,
                padding: EdgeInsets.only(top: 10),
              ),
            ];
            break;
          }
        case 2:
          {
            mPage = <Widget>[
              CostomTextField(
                hint: 'Kullanıcıdan ne resmi isteyeceksiniz ?',
                label: 'İstenecek Resim',
                controller: mcnt,
                widh: 360,
                padding: EdgeInsets.all(5),
                border: true,
              ),
              CostomButton(
                text: 'Oluştur',
                onclick: () {
                  if (mcnt.text.isNotEmpty) {
                    Navigator.pop(context, Istekdata.res(mcnt.text, 1));
                  }
                },
                backgroundcolor: Colors.deepOrangeAccent,
                pressclor: Primaryclor,
                radius: 5,
                widh: 200,
                padding: EdgeInsets.only(top: 10),
              ),
            ];
            break;
          }
        case 3:
          {
            mPage = <Widget>[
              CostomTextField(
                hint: 'Kullanıcıdan ne seçimi isteyeceksiniz ?',
                label: 'İstenecek Seçim',
                controller: mcnt,
                widh: 360,
                padding: EdgeInsets.all(5),
                border: true,
              ),
              CostomButton(
                text: 'Oluştur',
                onclick: () {
                  if (mcnt.text.isNotEmpty) {
                    Navigator.pop(context, Istekdata.switc(mcnt.text, 2));
                  }
                },
                backgroundcolor: Colors.deepOrangeAccent,
                pressclor: Primaryclor,
                radius: 5,
                widh: 200,
                padding: EdgeInsets.only(top: 10),
              ),
            ];
            break;
          }
        case 4:
          {
            mPage = <Widget>[
              CostomTextField(
                hint: 'Kullanıcıdan ne seçimi isteyeceksiniz ?',
                label: 'İstenecek Seçim',
                controller: mcnt,
                widh: 360,
                padding: EdgeInsets.all(5),
                border: true,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    'Şıkları burdan ekleyin lütfen',
                    style: TextStyle(color: Colors.deepOrangeAccent),
                  ),
                  InkWell(
                    onTap: () async {
                      String result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Fonkolusturucu(5)));
                      if (result != null) {
                        mRads.add(result);
                        radGunceller();
                      }
                    },
                    child: Icon(
                      Icons.add_circle,
                      color: Colors.deepOrangeAccent,
                    ),
                  )
                ],
              ),
              Column(children: mRads2),
              CostomButton(
                text: 'Oluştur',
                onclick: () {
                  if (mcnt.text.isNotEmpty && mRads.isNotEmpty) {
                    Navigator.pop(context, Istekdata.rad(mRads, mcnt.text, 3));
                  }
                },
                backgroundcolor: Colors.deepOrangeAccent,
                pressclor: Primaryclor,
                radius: 5,
                widh: 200,
                padding: EdgeInsets.only(top: 10),
              ),
            ];
            break;
          }
        case 5:
          {
            mPage = <Widget>[
              CostomTextField(
                hint: 'Bir şık giriniz.',
                label: 'Şık İsmi',
                controller: mcnt,
                widh: 360,
                padding: EdgeInsets.all(5),
                border: true,
              ),
              CostomButton(
                text: 'Oluştur',
                onclick: () {
                  if (mcnt.text.isNotEmpty) {
                    Navigator.pop(context, mcnt.text);
                  }
                },
                backgroundcolor: Colors.deepOrangeAccent,
                pressclor: Primaryclor,
                radius: 5,
                widh: 200,
                padding: EdgeInsets.only(top: 10),
              ),
            ];
            break;
          }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.deepOrangeAccent,
            title: Text('Fonksiyon Oluştur'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, null),
            )),
        body: SingleChildScrollView(
          child: Column(children: mPage),
        ),
      ),
    );
  }
}

class KatseciciFrag extends StatefulWidget {
  @override
  _KatseciciFrag createState() => _KatseciciFrag();
}

class _KatseciciFrag extends State<KatseciciFrag> {
  var katagoriListHorizontal = <Widget>[];

  katOlFrag() {
    katagoriListHorizontal.clear();
    setState(() {
      katagoriler.forEach((f) {
        katagoriListHorizontal.add(MyWidgets().mKatagorimHorizontal(
            f.katagori, f.baslik1, f.baslik2, f.toplamurun, f.katalogres));
      });
    });
  }

  katBulYolla(String kat) {
    int index = 0;
    katagoriler.forEach((eached) {
      if (eached.katagori == kat) {
        Navigator.pop(context, index);
      } else {
        index++;
      }
    });
  }

  @override
  void initState() {
    katOlFrag();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.deepOrangeAccent,
            title: Text('Katagori Seç'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, null),
            )),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
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
                          katBulYolla(view.key
                              .toString()
                              .substring(3, view.key.toString().length - 3));
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
