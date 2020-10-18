import 'dart:io';

import 'package:fexm/mCustomWIdgets/CostomTextField.dart';
import 'package:fexm/mCustomWIdgets/SplashScreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'MyWidgets.dart';
import 'datas/kullanicidata.dart';
import 'datas/sirketdata.dart';
import 'flutter_datetime_picker.dart';
import 'grouped_buttons.dart';
import 'mCustomWIdgets/CostomButton.dart';
import 'main.dart';

class Kayitol extends StatefulWidget {
  @override
  _Kayitol createState() => _Kayitol();
}

class _Kayitol extends State<Kayitol> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  int positionlayer = 0;
  int odemesayac = 0;
  var animatedforward = 0.0;
  var paddingscreen = 0.0;
  var animatedforward2 = 0.0;
  var animatedforward3 = 0.0;
  var animatedforward4 = 0.0;
  var animatedopacty = 1.0;
  var animatedopacty2 = 1.0;
  var animatedopacty3 = 1.0;
  var animatedopacty4 = 1.0;
  bool visibleS1 = false;
  bool visibleLogo = false;
  bool visibleSplash = true;
  bool visibleS2 = false;
  bool visibleS3 = false;
  bool visibleS4 = false;
  bool visibleS5 = false;
  bool eroredIsim = true;
  bool eroredEposta = true;
  bool eroredTelefon = true;
  bool eroredIl = true;
  bool eroredIlce = true;
  bool eroredMahalle = true;
  bool eroredAdres = true;
  bool eroredUnvan = true;
  bool eroredSirketadi = true;
  bool eroredUretilen = true;
  bool eroredSirketeposta = true;
  bool eroredSirkettel = true;
  bool eroredDogum = false;
  bool eroredHesaptip = false;
  bool eroredRes = false;
  bool eroredSirres = false;
  bool uneror = false;
  var cIsim = TextEditingController();
  var cEposta = TextEditingController();
  var cTelefon = TextEditingController();
  var cIl = TextEditingController();
  var cIlce = TextEditingController();
  var cMahalle = TextEditingController();
  var cAdres1 = TextEditingController();
  var cAdres2 = TextEditingController();
  var cUnvan = TextEditingController();
  var cSirketadi = TextEditingController();
  var cUruetilen = TextEditingController();
  var cSirketkonum = TextEditingController();
  var cSirketeposta = TextEditingController();
  var cSirketel = TextEditingController();
  var cSirkeweb = TextEditingController();
  var datetext = 'Doğum tarihi seçmediniz.';
  var _textsplash = 'Kontroller yapılıyor.';
  var _progressplash = '0';
  DateTime datedogum = DateTime.now();
  int _currVal = 1;
  String _currText = '';
  File _image;
  File _imageU;

  @override
  void initState() {
    controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    animation = Tween<double>(begin: 0, end: 300).animate(controller);
    animation.addListener(() {
      setState(() {
        switch (positionlayer) {
          case 0:
            {
              animatedforward = animation.value;
              animatedopacty = 1 - (animation.value / 300);
              if (animation.isCompleted) {
                visibleS1 = false;
                visibleS2 = true;
                animation =
                    Tween<double>(begin: 300, end: 0).animate(controller);
                positionlayer = 1;
                controller.reset();
                controller.forward();
              }
              break;
            }
          case 1:
            {
              animatedopacty2 = 1 - (animation.value / 300);
              animatedforward2 = -animation.value;
              break;
            }
          case 2:
            {
              animatedopacty2 = 1 - (animation.value / 300);
              animatedforward2 = animation.value;
              if (animation.isCompleted) {
                visibleS1 = true;
                visibleS2 = false;
                animation =
                    Tween<double>(begin: 300, end: 0).animate(controller);
                positionlayer = 3;
                controller.reset();
                controller.forward();
              }
              break;
            }
          case 3:
            {
              animatedopacty = 1 - (animation.value / 300);
              animatedforward = -animation.value;
              if (animation.isCompleted) {
                positionlayer = 0;
              }
              break;
            }
          case 4:
            {
              animatedopacty2 = 1 - (animation.value / 300);
              animatedforward2 = animation.value;
              if (animation.isCompleted) {
                visibleS1 = false;
                visibleS2 = false;
                visibleS3 = true;
                animation =
                    Tween<double>(begin: 300, end: 0).animate(controller);
                positionlayer = 5;
                controller.reset();
                controller.forward();
              }
              break;
            }
          case 5:
            {
              animatedopacty3 = 1 - (animation.value / 300);
              animatedforward3 = -animation.value;
              break;
            }
          case 6:
            {
              animatedopacty3 = 1 - (animation.value / 300);
              animatedforward3 = animation.value;
              if (animation.isCompleted) {
                visibleS2 = true;
                visibleS3 = false;
                animation =
                    Tween<double>(begin: 300, end: 0).animate(controller);
                positionlayer = 1;
                controller.reset();
                controller.forward();
              }
              break;
            }
          case 7:
            {
              animatedopacty3 = 1 - (animation.value / 300);
              animatedforward3 = animation.value;
              if (animation.isCompleted) {
                visibleS4 = true;
                visibleS3 = false;
                animation =
                    Tween<double>(begin: 300, end: 0).animate(controller);
                positionlayer = 8;
                controller.reset();
                controller.forward();
              }
              break;
            }
          case 8:
            {
              animatedopacty4 = 1 - (animation.value / 300);
              animatedforward4 = -animation.value;
              break;
            }
        }
      });
    });
    DatabaseReference dbK = FirebaseDatabase.instance
        .reference()
        .child("Hesaplar")
        .child("KullaniciBilgileri")
        .child(kullaniciUid);
    DatabaseReference dbU = FirebaseDatabase.instance
        .reference()
        .child("Hesaplar")
        .child("SirketBilgileri")
        .child(kullaniciUid);
    dbK.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values == null) {
        setState(() {
          visibleSplash = false;
          paddingscreen = 40;
          visibleS1 = true;
          visibleLogo = true;
          positionlayer = 0;
        });
      } else {
        setState(() {
          _textsplash='Abonelik kontrolü';
          _progressplash='50';
        });
        var bogum = values['k_Adres'];
        var adresdataa = Adresdata(
          bogum['il'],
          bogum['ilce'],
          bogum['mahalle'],
          bogum['adres1'],
          bogum['adres2'],
        ).toJson();
        kullaniciData = Kullanicidata(
            values['k_Res'],
            values['k_Isim'],
            values['k_Eposta'],
            values['k_Tel'],
            adresdataa,
            values['k_Unvanmeslek'],
            values['k_Dogumtarihi'],
            values['k_AbonelikTipi']);
        values.forEach((key, values) {
          if (key == "k_AbonelikTipi" && values == 0) {
            Navigator.of(context).pushNamed('/anasayfa');
          } else if (key == "k_AbonelikTipi" && values == 1) {
            dbU.once().then((DataSnapshot snapsU) {
              Map<dynamic, dynamic> valuues = snapsU.value;
              if (valuues == null) {
                setState(() {
                  visibleSplash = false;
                  paddingscreen = 40;
                  visibleS4 = true;
                  visibleLogo = true;
                  positionlayer = 8;
                });
              } else if (valuues['u_odemegecerlimi'] as bool) {
                sirketData = Sirketdata(
                  valuues['u_aktif'],
                  valuues['u_res'],
                  valuues['u_isim'],
                  valuues['u_konum'],
                  valuues['u_eposta'],
                  valuues['u_tel'],
                  valuues['u_web'],
                  valuues['u_unvanmeslek'],
                  valuues['u_odemegecerlimi'],
                  valuues['u_sirketpuan'].toDouble(),
                );
                Navigator.of(context).pushNamed('/anasayfa');
              } else {
                setState(() {
                  _textsplash = "Ödeme yapınız.";
                  _progressplash='99';
                  visibleS5 = true;
                });
              }
            });
          }
        });
      }
    });
    // c_isim.addListener(_conroltext(c_isim,erored_isim));
    cIsim.addListener(() {
      setState(() {
        eroredIsim = MyWidgets().conroltext(cIsim, 0);
      });
    });
    cEposta.addListener(() {
      setState(() {
        eroredEposta = MyWidgets().conroltext(cEposta, 2);
      });
    });
    cTelefon.addListener(() {
      setState(() {
        eroredTelefon = MyWidgets().conroltext(cTelefon, 1);
      });
    });
    cIl.addListener(() {
      setState(() {
        eroredIl = MyWidgets().conroltext(cIl, 0);
      });
    });
    cIlce.addListener(() {
      setState(() {
        eroredIlce = MyWidgets().conroltext(cIlce, 0);
      });
    });
    cMahalle.addListener(() {
      setState(() {
        eroredMahalle = MyWidgets().conroltext(cMahalle, 0);
      });
    });
    cAdres1.addListener(() {
      setState(() {
        eroredAdres = MyWidgets().conroltext(cAdres1, 0);
      });
    });
    cAdres2.addListener(() {
      setState(() {
        eroredAdres = MyWidgets().conroltext(cAdres2, 0);
      });
    });
    cUnvan.addListener(() {
      setState(() {
        eroredUnvan = MyWidgets().conroltext(cUnvan, 0);
      });
    });
    cSirketel.addListener(() {
      setState(() {
        eroredSirkettel = MyWidgets().conroltext(cSirketel, 1);
      });
    });
    cSirketadi.addListener(() {
      setState(() {
        eroredSirketadi = MyWidgets().conroltext(cSirketadi, 0);
      });
    });
    cSirketeposta.addListener(() {
      setState(() {
        eroredSirketeposta = MyWidgets().conroltext(cSirketeposta, 2);
      });
    });
    cUruetilen.addListener(() {
      setState(() {
        eroredUretilen = MyWidgets().conroltext(cUruetilen, 0);
      });
    });
    super.initState();
  }

  _odeme() {
    if (odemesayac == 12) {
      DatabaseReference dbUodeme = FirebaseDatabase.instance
          .reference()
          .child("Hesaplar")
          .child("SirketBilgileri")
          .child(kullaniciUid)
          .child("u_odemegecerlimi");
      dbUodeme.set(true);
      Navigator.of(context).pushNamed('/anasayfa');
    } else {
      odemesayac++;
    }
  }

  _animForward() {
    switch (positionlayer) {
      case 0:
        {
          if (!eroredAdres &&
              !eroredIsim &&
              !eroredTelefon &&
              !eroredIl &&
              !eroredIlce &&
              !eroredMahalle &&
              !eroredAdres) {
            animation = Tween<double>(begin: 0, end: 300).animate(controller);
            controller.reset();
            controller.forward();
          }
          break;
        }
      case 1:
        {
          if (!eroredUnvan && eroredHesaptip && eroredDogum) {
            animation = Tween<double>(begin: 0, end: 300).animate(controller);
            controller.reset();
            positionlayer = 4;
            controller.forward();
          }
          break;
        }
      case 5:
        {
          if (!eroredAdres &&
              !eroredIsim &&
              !eroredTelefon &&
              !eroredIl &&
              !eroredIlce &&
              !eroredMahalle &&
              !eroredAdres &&
              !eroredUnvan &&
              eroredHesaptip &&
              eroredDogum &&
              eroredRes) {
            kaydet();
          }
          break;
        }
      case 8:
        {
          if (eroredSirres &&
              !eroredSirketadi &&
              !eroredSirketeposta &&
              !eroredSirkettel &&
              !eroredUretilen) {
            kaydetS();
          }
          break;
        }
    }
  }

  kaydetS() async {
    setState(() {
      _textsplash = "Logo yükleniyor.";
      visibleSplash = true;
      visibleLogo = false;
      visibleS4 = false;
      paddingscreen = 0;
    });
    StorageUploadTask task = FirebaseStorage.instance
        .ref()
        .child("UreticiDatasi")
        .child(kullaniciUid)
        .child("resimlerim")
        .child('logo.png')
        .putFile(_imageU);
    task.events.listen((onData) {
      setState(() {
        double _progress = (onData.snapshot.bytesTransferred.toDouble() /
                onData.snapshot.totalByteCount.toDouble()) *
            100;
        _textsplash = "%$_progress yüklendi.";
      });
    });
    String url = await (await task.onComplete).ref.getDownloadURL();
    setState(() {
      _textsplash = "Kayıt tamamlanıyor lütfen bekleyiniz.";
    });
    var a = FirebaseDatabase.instance
        .reference()
        .child("Hesaplar")
        .child("SirketBilgileri")
        .child(kullaniciUid)
        .set(Sirketdata(
                true,
                url,
                cSirketadi.text,
                cSirketkonum.text,
                cSirketeposta.text,
                cSirketel.text,
                cSirkeweb.text,
                cUruetilen.text,
                false,
                0)
            .toJson());
    a.whenComplete(() {
      setState(() {
        _textsplash = "Ödeme yapınız.";
        visibleS5 = true;
      });
    });
  }

  kaydet() async {
    setState(() {
      _textsplash = "Resim yükleniyor.";
      visibleSplash = true;
      visibleLogo = false;
      visibleS3 = false;
      paddingscreen = 0;
    });
    StorageUploadTask task = FirebaseStorage.instance
        .ref()
        .child("KullaniciDatasi")
        .child(kullaniciUid)
        .child("resimlerim")
        .child('profil.jpg')
        .putFile(_image);
    task.events.listen((onData) {
      setState(() {
        double _progress = (onData.snapshot.bytesTransferred.toDouble() /
                onData.snapshot.totalByteCount.toDouble()) *
            100;
        _progressplash=_progress.toString();
      });
    });
    String url = await (await task.onComplete).ref.getDownloadURL();
    setState(() {
      _textsplash = "Kayıt tamamlanıyor lütfen bekleyiniz.";
    });
    var a = FirebaseDatabase.instance
        .reference()
        .child("Hesaplar")
        .child("KullaniciBilgileri")
        .child(kullaniciUid)
        .set(Kullanicidata(
                url,
                cIsim.text,
                cEposta.text,
                cTelefon.text,
                Adresdata(cIl.text, cIlce.text, cMahalle.text, cAdres1.text,
                        cAdres2.text)
                    .toJson(),
                cUnvan.text,
                datedogum.millisecondsSinceEpoch,
                _currVal)
            .toJson());
    a.whenComplete(() {
      if (_currVal == 0) {
        Navigator.of(context).pushNamed('/anasayfa');
      } else if (_currVal == 1) {
        setState(() {
          visibleLogo = true;
          visibleSplash = false;
          paddingscreen = 40;
        });
        animation = Tween<double>(begin: 0, end: 300).animate(controller);
        positionlayer = 7;
        controller.reset();
        controller.forward();
      }
    });
  }

  _animBack() {
    switch (positionlayer) {
      case 1:
        {
          animation = Tween<double>(begin: 0, end: 300).animate(controller);
          positionlayer = 2;
          controller.reset();
          controller.forward();
          break;
        }
      case 5:
        {
          animation = Tween<double>(begin: 0, end: 300).animate(controller);
          positionlayer = 6;
          controller.reset();
          controller.forward();
          break;
        }
    }
  }

  _datepicker() {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1950, 0, 0),
        maxTime: DateTime(2000, 0, 0), onChanged: (date) {
      print('change $date');
    }, onConfirm: (date) {
      print('confirm $date');
      setState(() {
        eroredDogum = true;
        datedogum = date;
        datetext = date.toString().substring(0, 10);
      });
    }, currentTime: datedogum, locale: LocaleType.tr);
  }

  _onchangedradio(String radText, int index) {
    setState(() {
      eroredHesaptip = true;
      _currText = radText;
      _currVal = index;
    });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
    var imagge = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2
        ],
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
      _image = imagge;
      if (_image != null) {
        eroredRes = true;
      } else {
        eroredRes = false;
      }
    });
  }

  Future getImageu() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    var imagge = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2
        ],
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
      _imageU = imagge;
      if (_imageU != null) {
        eroredSirres = true;
      } else {
        eroredSirres = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          switch (positionlayer) {
            case 0:
              {
                return true;
              }
            case 1:
              {
                _animBack();
                return false;
              }
            case 5:
              {
                _animBack();
                return false;
              }
            default:
              {
                return true;
              }
          }
        },
        child: MaterialApp(
            home: Scaffold(
                body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(top: paddingscreen),
              child: Center(
                child: Column(children: <Widget>[
                  SplashScreen(contex: context,logocolor:Primaryclor,subcolor: Colors.black,backgroundcolor:Colors.white,textinfo: _textsplash,splashVisib:visibleSplash,textprogress: _progressplash,),
                  Visibility(
                    visible: visibleLogo,
                    child: Container(
                        width: 150,
                        child:
                            Image(image: AssetImage('assets/matbaacim_t.png'))),
                  ),
                  CostomTextField(
                    opaticy: animatedopacty,
                    ofsetx: animatedforward * 0.2,
                    hint: 'İsminizi giriniz.',
                    label: 'İsim',
                    ic: Icon(
                      Icons.person_pin,
                      color: Primaryclor,
                      size: 16,
                    ),
                    inputType: TextInputType.text,
                    errored: eroredIsim,
                    errortext: 'İsim alanı boş bırakılamaz.',
                    controller: cIsim,
                    visible: visibleS1,
                    widh: 300,
                    padding: EdgeInsets.only(top: 10),
                    border: true,
                  ),
                  CostomTextField(
                    opaticy: animatedopacty,
                    ofsetx: animatedforward * 0.4,
                    hint: 'Mail adresinizi giriniz.',
                    label: 'Mail',
                    ic: Icon(
                      Icons.email,
                      color: Primaryclor,
                      size: 16,
                    ),
                    inputType: TextInputType.emailAddress,
                    errored: eroredEposta,
                    errortext: 'Geçerli bir mail adresi giriniz.',
                    controller: cEposta,
                    visible: visibleS1,
                    widh: 300,
                    padding: EdgeInsets.only(top: 10),
                    border: true,
                  ),
                  CostomTextField(
                    opaticy: animatedopacty,
                    ofsetx: animatedforward * 0.6,
                    hint: 'Telefon numarasını giriniz.',
                    label: 'Telefon Numarası',
                    ic: Icon(
                      Icons.phone_android,
                      color: Primaryclor,
                      size: 16,
                    ),
                    inputType: TextInputType.phone,
                    errored: eroredTelefon,
                    errortext:
                        'Başında 0 olmadan 10 haneli telefon numaranızı giriniz.',
                    controller: cTelefon,
                    visible: visibleS1,
                    widh: 300,
                    padding: EdgeInsets.only(top: 10),
                    border: true,
                  ),
                  CostomTextField(
                    opaticy: animatedopacty,
                    ofsetx: animatedforward * 0.8,
                    hint: 'Yaşadığınız il.',
                    label: 'İl',
                    ic: Icon(
                      Icons.location_city,
                      color: Primaryclor,
                      size: 16,
                    ),
                    inputType: TextInputType.text,
                    errored: eroredIl,
                    errortext: 'İl alanı boş bırakılamaz',
                    controller: cIl,
                    visible: visibleS1,
                    widh: 300,
                    padding: EdgeInsets.only(top: 10),
                    border: true,
                  ),
                  CostomTextField(
                    opaticy: animatedopacty,
                    ofsetx: animatedforward,
                    hint: 'İlçe giriniz.',
                    label: 'İlçe',
                    ic: Icon(
                      Icons.home,
                      color: Primaryclor,
                      size: 16,
                    ),
                    inputType: TextInputType.text,
                    errored: eroredIlce,
                    errortext: 'İlçe alanı boş bırakılamaz',
                    controller: cIlce,
                    visible: visibleS1,
                    widh: 300,
                    padding: EdgeInsets.only(top: 10),
                    border: true,
                  ),
                  CostomTextField(
                    opaticy: animatedopacty,
                    ofsetx: animatedforward * 1.2,
                    hint: 'Mahalle giriniz.',
                    label: 'Mahalle',
                    ic: Icon(
                      Icons.location_on,
                      color: Primaryclor,
                      size: 16,
                    ),
                    inputType: TextInputType.text,
                    errored: eroredMahalle,
                    errortext: 'Mahalle alanı boş bırakılamaz',
                    controller: cMahalle,
                    visible: visibleS1,
                    widh: 300,
                    padding: EdgeInsets.only(top: 10),
                    border: true,
                  ),
                  CostomTextField(
                    opaticy: animatedopacty,
                    ofsetx: animatedforward * 1.4,
                    hint: 'Adresinizi giriniz.',
                    label: 'Adres 1',
                    ic: Icon(
                      Icons.my_location,
                      color: Primaryclor,
                      size: 16,
                    ),
                    inputType: TextInputType.text,
                    errored: eroredAdres,
                    errortext: 'Adres alanlarından en az biri doldurulmalı.',
                    controller: cAdres1,
                    visible: visibleS1,
                    widh: 300,
                    padding: EdgeInsets.only(top: 10),
                    border: true,
                  ),
                  CostomTextField(
                    opaticy: animatedopacty,
                    ofsetx: animatedforward * 1.6,
                    hint: 'Adresinizi giriniz.',
                    label: 'Adres 2',
                    ic: Icon(
                      Icons.my_location,
                      color: Primaryclor,
                      size: 16,
                    ),
                    inputType: TextInputType.text,
                    errored: eroredAdres,
                    errortext: 'Adres alanlarından en az biri doldurulmalı.',
                    controller: cAdres2,
                    visible: visibleS1,
                    widh: 300,
                    padding: EdgeInsets.only(top: 10),
                    border: true,
                  ),
                  CostomButton(
                    ofsetx: animatedforward * 1.8,
                    opaticy: animatedopacty,
                    visible: visibleS1,
                    text: 'Devam',
                    onclick: () {
                      _animForward();
                    },
                    pressclor: Colors.orangeAccent,
                    widh: 300,
                    radius: 10,
                    padding: EdgeInsets.only(top: 10),
                  ),
                  CostomTextField(
                    opaticy: animatedopacty2,
                    ofsetx: animatedforward2 * 1.2,
                    hint: 'Ünvan-Meslek.',
                    label: 'Ne ile ilgileniyorsunuz',
                    ic: Icon(
                      Icons.work,
                      color: Primaryclor,
                      size: 16,
                    ),
                    inputType: TextInputType.text,
                    errored: eroredUnvan,
                    errortext: 'Ünvan alanı doldurulmalı.',
                    controller: cUnvan,
                    visible: visibleS2,
                    widh: 300,
                    padding: EdgeInsets.only(top: 10),
                    border: true,
                  ),
                  Visibility(
                      visible: visibleS2,
                      child: Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Opacity(
                            opacity: animatedopacty2,
                            child: Transform.translate(
                              offset: Offset(animatedforward2, 0),
                              child: Container(
                                width: 300,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Primaryclor, width: 2),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Column(
                                  children: <Widget>[
                                    MyWidgets().mTextWithanimation(
                                        0,
                                        animatedopacty2,
                                        datetext,
                                        visibleS2,
                                        Primaryclor,
                                        14,
                                        TextAlign.center,
                                        280,
                                        null,
                                        EdgeInsets.only(top: 10)),
                                    CostomButton(
                                      opaticy: animatedopacty2,
                                      visible: visibleS2,
                                      text: 'Tarih seç',
                                      onclick: () {
                                        _datepicker();
                                      },
                                      pressclor: Colors.orangeAccent,
                                      widh: 280,
                                      radius: 10,
                                      padding: EdgeInsets.only(top: 10),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ))),
                  MyWidgets().mTextWithanimation(
                      animatedforward2 * 0.8,
                      animatedopacty2,
                      'Hesap Tipi',
                      visibleS2,
                      Primaryclor,
                      14,
                      TextAlign.center,
                      null,
                      null,
                      EdgeInsets.only(top: 50)),
                  Visibility(
                    visible: visibleS2,
                    child: Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Opacity(
                          opacity: animatedopacty2,
                          child: Transform.translate(
                            offset: Offset(animatedforward2 * 0.6, 0),
                            child: RadioButtonGroup(
                              picked: _currText,
                              labels: <String>[
                                'Kullanıcı Hesabı',
                                'Üretici Hesabı'
                              ],
                              orientation: GroupedButtonsOrientation.HORIZONTAL,
                              activeColor: Primaryclor,
                              labelStyle: TextStyle(color: Colors.black),
                              onChange: (String text, int index) =>
                                  _onchangedradio(text, index),
                            ),
                          )),
                    ),
                  ),
                  MyWidgets().mTextWithanimation(
                      animatedforward2 * 0.4,
                      animatedopacty2,
                      "Üretici hesabı aylık ücrete tabii tutulmaktadır ilk ay ücret alınmayacaktır.Kayıt sonunda abonelik oluşturmanız istenecektir.",
                      visibleS2,
                      Colors.black54,
                      10,
                      TextAlign.center,
                      null,
                      null,
                      EdgeInsets.only(top: 10, left: 25, right: 25)),
                  CostomButton(
                    ofsetx: animatedforward2 * 0.2,
                    opaticy: animatedopacty2,
                    visible: visibleS2,
                    text: 'Devam',
                    onclick: () {
                      _animForward();
                    },
                    pressclor: Colors.orangeAccent,
                    widh: 300,
                    radius: 10,
                    padding: EdgeInsets.only(top: 50),
                  ),
                  Visibility(
                    visible: visibleS3,
                    child: Opacity(
                      opacity: animatedopacty3,
                      child: Transform.translate(
                          offset: Offset(animatedforward3, 0),
                          child: Container(
                            padding: EdgeInsets.only(top: 50),
                            child: _image == null
                                ? Text('Henüz bir resim seçmediniz.')
                                : MyWidgets()
                                    .mCircularImage(_image, 200, 200, null),
                          )),
                    ),
                  ),
                  CostomButton(
                    ofsetx: animatedforward3 * 0.6,
                    opaticy: animatedopacty3,
                    visible: visibleS3,
                    text: 'Resim seç',
                    onclick: () {
                      getImage();
                    },
                    pressclor: Colors.deepOrangeAccent,
                    widh: 100,
                    radius: 10,
                    padding: EdgeInsets.only(top: 5),
                  ),
                  CostomButton(
                    ofsetx: animatedforward3 * 0.2,
                    opaticy: animatedopacty3,
                    visible: visibleS3,
                    text: 'Devam et',
                    onclick: () {
                      _animForward();
                    },
                    pressclor: Colors.deepOrangeAccent,
                    widh: 300,
                    radius: 10,
                    padding: EdgeInsets.only(top:100),
                  ),
                  Visibility(
                    visible: visibleS4,
                    child: Container(
                      padding: EdgeInsets.only(top: 25),
                      child: Text(
                        'Şirketiniz İçin Bir Logo Seçiniz',
                        style: TextStyle(color: Primaryclor, fontSize: 16),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: visibleS4,
                    child: Opacity(
                      opacity: animatedopacty4,
                      child: Transform.translate(
                          offset: Offset(animatedforward4, 0),
                          child: Container(
                            padding: EdgeInsets.only(top: 50),
                            child: _imageU == null
                                ? Text('Henüz bir resim seçmediniz.')
                                : MyWidgets()
                                    .mCircularImage(_imageU, 200, 200, null),
                          )),
                    ),
                  ),
                  CostomButton(
                    ofsetx: animatedforward4 * 0.6,
                    opaticy: animatedopacty4,
                    visible: visibleS4,
                    text: 'Resim seç',
                    onclick: () {
                      getImageu();
                    },
                    pressclor: Colors.deepOrangeAccent,
                    widh: 100,
                    radius: 10,
                    padding: EdgeInsets.only(top: 5),
                  ),
                  CostomTextField(
                    opaticy: animatedopacty4,
                    ofsetx: animatedforward4 * 1.2,
                    hint: 'Üretici hesabınız için bir isim girin.',
                    label: 'Şirket yada satıcının adı',
                    ic: Icon(
                      Icons.work,
                      color: Primaryclor,
                      size: 16,
                    ),
                    inputType: TextInputType.text,
                    errored: eroredSirketadi,
                    errortext: 'Şirket adı alanı doldurulmalı.',
                    controller: cSirketadi,
                    visible: visibleS4,
                    widh: 300,
                    padding: EdgeInsets.only(top: 10),
                    border: true,
                  ),
                  CostomTextField(
                    opaticy: animatedopacty4,
                    ofsetx: animatedforward4 * 1.2,
                    hint: 'Üretici hesabınız ne üretiyor veya satıyor.',
                    label: 'Şirket Yapılan İş-Ürettiği Ürün',
                    ic: Icon(
                      Icons.work,
                      color: Primaryclor,
                      size: 16,
                    ),
                    inputType: TextInputType.text,
                    errored: eroredUretilen,
                    errortext: 'Ürün alanı doldurulmalı.',
                    controller: cUruetilen,
                    visible: visibleS4,
                    widh: 300,
                    padding: EdgeInsets.only(top: 10),
                    border: true,
                  ),
                  CostomTextField(
                    opaticy: animatedopacty4,
                    ofsetx: animatedforward4 * 1.2,
                    hint: 'Üretici hesabınız için bir konum girin.',
                    label: 'Şirket Konumu (Varsa)',
                    ic: Icon(
                      Icons.work,
                      color: Primaryclor,
                      size: 16,
                    ),
                    inputType: TextInputType.text,
                    errored: uneror,
                    controller: cSirketkonum,
                    visible: visibleS4,
                    widh: 300,
                    padding: EdgeInsets.only(top: 10),
                    border: true,
                  ),
                  CostomTextField(
                    opaticy: animatedopacty4,
                    ofsetx: animatedforward4 * 1.2,
                    hint: 'Üretici hesabınız için bir eposta girin.',
                    label: 'Şirket Mail Adresi',
                    ic: Icon(
                      Icons.work,
                      color: Primaryclor,
                      size: 16,
                    ),
                    inputType: TextInputType.emailAddress,
                    errored: eroredSirketeposta,
                    errortext: 'Mail alanı doldurulmalı.',
                    controller: cSirketeposta,
                    visible: visibleS4,
                    widh: 300,
                    padding: EdgeInsets.only(top: 10),
                    border: true,
                  ),
                  CostomTextField(
                    opaticy: animatedopacty4,
                    ofsetx: animatedforward4 * 1.2,
                    hint: 'Üretici hesabınız için bir telefon numarası girin.',
                    label: 'Şirket Telefon Numarası',
                    ic: Icon(
                      Icons.work,
                      color: Primaryclor,
                      size: 16,
                    ),
                    inputType: TextInputType.phone,
                    errored: eroredSirkettel,
                    errortext: 'Bir telefon numarası girmelisiniz.',
                    controller: cSirketel,
                    visible: visibleS4,
                    widh: 300,
                    padding: EdgeInsets.only(top: 10),
                    border: true,
                  ),
                  CostomTextField(
                    opaticy: animatedopacty4,
                    ofsetx: animatedforward4 * 1.2,
                    hint: 'Üretici hesabınız için varsa bir web sitesi girin.',
                    label: 'Şirket Web Sitesi(Varsa)',
                    ic: Icon(
                      Icons.work,
                      color: Primaryclor,
                      size: 16,
                    ),
                    inputType: TextInputType.text,
                    errored: uneror,
                    controller: cSirkeweb,
                    visible: visibleS4,
                    widh: 300,
                    padding: EdgeInsets.only(top: 10),
                    border: true,
                  ),
                  CostomButton(
                    ofsetx: animatedforward4 * 0.2,
                    opaticy: animatedopacty4,
                    visible: visibleS4,
                    text: 'Devam et',
                    onclick: () {
                      _animForward();
                    },
                    pressclor: Colors.deepOrangeAccent,
                    widh: 300,
                    radius: 10,
                    padding: EdgeInsets.only(top:20),
                  ),
                  CostomButton(
                    visible: visibleS5,
                    text: 'Öde',
                    onclick: () {
                      _odeme();
                    },
                    pressclor: Colors.deepOrangeAccent,
                    widh: 300,
                    radius: 10,
                    padding: EdgeInsets.only(top:20),
                  ),
                ]),
              )),
        ))));
  }
}
