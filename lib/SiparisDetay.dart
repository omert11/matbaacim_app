import 'dart:io';
import 'package:fexm/MyWidgets.dart';
import 'package:fexm/datas/editoraddData.dart';
import 'package:fexm/datas/istekdata.dart';
import 'package:fexm/mCustomWIdgets/CostomButton.dart';
import 'package:fexm/mCustomWIdgets/CostomTextField.dart';
import 'package:fexm/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'datas/urundata.dart';
import 'mCustomWIdgets/SplashScreen.dart';

class SiparisDetay extends StatefulWidget {
  final Urundata uData;
  final bool isbeforeEdited;
  final SepetData duzenlecenek;

  const SiparisDetay(
      {@required this.uData, this.isbeforeEdited: false, this.duzenlecenek});

  @override
  _SiparisDetay createState() => _SiparisDetay(uData);
}

class _SiparisDetay extends State<SiparisDetay> {
  Urundata uData;
  bool yukleme = false;
  bool once = true;
  SepetBekleyenData editoredData;
  bool tas = false;
  String proggres = '0';
  double proggresK = 100;
  final scrofkey = GlobalKey<ScaffoldState>();
  List<Istekdata> mData = <Istekdata>[];
  List<Widget> mWidgets = <Widget>[];
  List<dynamic> mIsteklist = <dynamic>[];
  List<String> boslist = <String>[];
  TextEditingController adetCont = TextEditingController();

  _SiparisDetay(this.uData);

  @override
  void initState() {
    String unameCode = uData.urunisim + uData.ureticiuid.substring(0, 3);
    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child('Urunler')
        .child(uData.bulundugukatagori)
        .child(unameCode)
        .child('siparisistegim');
    ref.once().then((onValue) {
      if (onValue != null) {
        List<dynamic> valuesust = onValue.value;
        valuesust.forEach((eachedIstek) {
          Map<dynamic, dynamic> datadonusulecek = eachedIstek;
          int typ = datadonusulecek['type'] as int;
          switch (typ) {
            case 0:
              {
                Istekdata mIdata = Istekdata.yazi(datadonusulecek['inputtype'],
                    datadonusulecek['istenecek'], datadonusulecek['type']);
                mData.add(mIdata);
                break;
              }
            case 1:
              {
                Istekdata mIdata = Istekdata.res(
                    datadonusulecek['istenecek'], datadonusulecek['type']);
                mData.add(mIdata);
                break;
              }
            case 2:
              {
                Istekdata mIdata = Istekdata.switc(
                    datadonusulecek['istenecek'], datadonusulecek['type']);
                mData.add(mIdata);
                break;
              }
            case 3:
              {
                List<String> mList = <String>[];
                (datadonusulecek['list'] as List<dynamic>).forEach((eachedd) {
                  mList.add(eachedd as String);
                });
                Istekdata mIdata = Istekdata.rad(mList,
                    datadonusulecek['istenecek'], datadonusulecek['type']);
                mData.add(mIdata);
                break;
              }
          }
        });
      }
    }).whenComplete(() {
      if (sepetimBekleyen.isNotEmpty) {
        sepetimBekleyen.forEach((each) {
          if (uData.urunisim + uData.ureticiuid.substring(0, 3) == each.urunI) {
            tas = true;
            editoredData = each;
          }
        });
      }
      _refresh();
    });
    super.initState();
  }

  _progressListener() {
    double newprog = double.parse(proggres) + proggresK;
    setState(() {
      proggres = newprog.toString();
    });
    if (newprog > 95) {
      Navigator.pop(context);
    }
  }

  _tamamla() {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text(
          'MatbaacımApp',
          style: TextStyle(fontSize: 14),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
                boslist.isNotEmpty
                    ? 'Aşağıda istenen özellikleri gerçekten boş bırakacak mısınız?'
                    : 'Ürün sepetinize eklensinmi?',
                style: TextStyle(fontSize: 12)),
            boslist.isNotEmpty
                ? ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: boslist.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Container(
                          margin: EdgeInsets.all(3),
                          child: Text('- ${boslist[index]}',
                              style: TextStyle(
                                  fontSize: 10, color: Colors.redAccent)));
                    })
                : Container(),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('Hayır'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text('Sepete Ekle'),
            onPressed: () {
              _saver();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  _saver() {
    setState(() {
      yukleme = true;
    });
    proggresK = 100 / (mData.length + 2 - boslist.length);
    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child('Sepetler')
        .child(kullaniciUid)
        .child(uData.urunisim + uData.ureticiuid.substring(0, 3));
    var task1 = ref
        .child('urunKod')
        .set(uData.urunisim + uData.ureticiuid.substring(0, 3));
    ref.child('urunKat').set(uData.bulundugukatagori);
    var task2 = ref.child('istekcevaplari').child('Adet').set(adetCont.text);
    task1.then((val) {
      _progressListener();
    });
    task2.then((val) {
      _progressListener();
    });
    int k = 0;
    mData.forEach((eachedistek) {
      switch (eachedistek.type) {
        case 0:
          {
            TextEditingController t = mIsteklist[k];
            if (t.text.isNotEmpty) {
              var task = ref
                  .child('istekcevaplari')
                  .child(eachedistek.istenecek)
                  .set(t.text);
              task.then((val) {
                _progressListener();
              });
            }
            break;
          }
        case 1:
          {
            File f = mIsteklist[k];
            if (f != null) {
              StorageUploadTask task = FirebaseStorage.instance
                  .ref()
                  .child('Sepetler')
                  .child(kullaniciUid)
                  .child(uData.urunisim + uData.ureticiuid.substring(0, 3))
                  .child(eachedistek.istenecek + '.png')
                  .putFile(f);
              task.onComplete.then((val) async {
                String url = await val.ref.getDownloadURL();
                ref
                    .child('istekcevaplari')
                    .child(eachedistek.istenecek)
                    .set(url);
                _progressListener();
              });
            }
            break;
          }
        case 2:
          {
            var task = ref
                .child('istekcevaplari')
                .child(eachedistek.istenecek)
                .set((mIsteklist[k] as bool) ? 'Evet' : 'Hayır');
            task.then((val) {
              _progressListener();
            });
            break;
          }
        case 3:
          {
            int i = mIsteklist[k];
            if (i != null) {
              var task = ref
                  .child('istekcevaplari')
                  .child(eachedistek.istenecek)
                  .set(mData[k].list[i]);
              task.then((val) {
                _progressListener();
              });
            }
            break;
          }
      }
      k++;
    });
  }

  _sepeteEkler() {
    boslist.clear();
    if (adetCont.text.isNotEmpty) {
      int index = 0;
      mData.forEach((eachedistek) {
        switch (eachedistek.type) {
          case 0:
            {
              TextEditingController tIstek = mIsteklist[index];
              if (tIstek.text.isEmpty) {
                boslist.add(eachedistek.istenecek);
              }
              break;
            }
          case 1:
            {
              File tIstek = mIsteklist[index];
              if (tIstek == null) {
                boslist.add(eachedistek.istenecek);
              }
              break;
            }
          case 3:
            {
              int tIstek = mIsteklist[index];
              if (tIstek == null) {
                boslist.add(eachedistek.istenecek);
              }
              break;
            }
        }
        index++;
      });
      _tamamla();
    } else {
      final SnackBar snack = SnackBar(
        content: Text('Adet kısmını unuttun !'),
        action: SnackBarAction(
          label: 'Tamam',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      scrofkey.currentState.showSnackBar(snack);
    }
  }

  int _indexbulur(String istek) {
    int k = 0;
    bool aramada = true;
    mData.forEach((eached) {
      if (eached.istenecek == istek && aramada) {
        aramada = false;
      } else if (aramada) {
        k++;
      }
    });
    return k;
  }

  Future<File> _imageatar() async {
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
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    return imagge;
  }

  _refresh() {
    mWidgets.clear();
    setState(() {
      mWidgets.addAll([
        Container(
            color: BlackLight_t,
            padding: EdgeInsets.only(top: 35, left: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )),
                    Container(
                      width: 10,
                    ),
                    Container(
                        width: 210,
                        child: Text(
                          uData.urunisim,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        )),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                    Container(
                      width: 10,
                    ),
                    Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                    ),
                    Container(
                      width: 30,
                    ),
                  ],
                )
              ],
            )),
        Container(
            margin: EdgeInsets.only(top: 5, left: 10),
            child: Text(uData.baslik1.toUpperCase(),
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300))),
        Container(
          margin: EdgeInsets.only(top: 10, left: 10),
          child: Row(
            children: <Widget>[
              MyWidgets().yIldizlar(uData.deger),
              Container(
                width: 5,
              ),
              Text(
                uData.degerlendirensay,
                style: TextStyle(
                    color: Primaryclor,
                    fontWeight: FontWeight.w300,
                    fontSize: 12),
              )
            ],
          ),
        ),
        Container(
          color: BlackLight_t,
          margin: EdgeInsets.only(top: 5),
          padding: EdgeInsets.all(10),
          child: Image.network(uData.urunres),
          height: 200,
          width: 360,
        ),
        Container(
            margin: EdgeInsets.only(top: 5, left: 10),
            child: Text(
              uData.fiyat.toString() + '₺',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            )),
        Container(
            padding: EdgeInsets.all(10),
            child: Divider(height: 1, color: BlackLight)),
        Container(
          margin: EdgeInsets.only(top: 5, left: 10),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.local_shipping,
                color: uData.kargo == 0 ? Colors.green : Colors.red,
              ),
              Container(
                width: 5,
              ),
              Text(
                uData.kargo == 0 ? 'Ücretsiz Kargo' : 'Ücretli Kargo',
                style: TextStyle(
                  color: uData.kargo == 0 ? Colors.green : Colors.red,
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5, left: 10),
          child: Row(
            children: <Widget>[
              Text(
                uData.ulasmasur + ' gün içinde ulaşır',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
              ),
              Container(
                width: 5,
              ),
              Icon(
                Icons.info_outline,
                size: 15,
              )
            ],
          ),
        ),
        Container(
            padding: EdgeInsets.all(10),
            child: Divider(height: 1, color: BlackLight)),
        Container(
            margin: EdgeInsets.only(top: 5, left: 10),
            child: Text(
              'Tasarım',
              style: TextStyle(color: Colors.deepOrangeAccent),
            )),
        uData.tasarim != 2
            ? tas
                ? Container(
                    margin: EdgeInsets.only(top: 5, left: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image.network(editoredData.sRes,width: 100,height: 100,),
                        Container(width: 5,),
                        Container(width: 230,child: Text('Tasarım yapılmış.Değiştirmek isterseniz Profil>Yarım Kalanlar'))
                      ],
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(top: 5, left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Bir tasarım oluşturmadınız.\nEklemek için bir fonksiyon seçiniz.',
                          style: TextStyle(fontSize: 10, color: BlackLight_h),
                        ),
                        Container(
                          height: 5,
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Primaryclor, width: 0.2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Text(
                                'Matbaacim Editor(v$versioncodeE)',
                                style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    color: Primaryclor),
                              ),
                            ),
                            Container(
                              width: 10,
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Primaryclor, width: 0.2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Text(
                                'Dosya Yükle',
                                style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    color: Primaryclor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
            : Container(
                margin: EdgeInsets.only(top: 5, left: 10),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Bu ürün için özel tasarıma izin verilmemiş',
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                    ),
                    Container(
                      width: 5,
                    ),
                    Icon(
                      Icons.info_outline,
                      size: 15,
                    )
                  ],
                ),
              ),
        Container(
            padding: EdgeInsets.all(10),
            child: Divider(height: 1, color: BlackLight)),
        Container(
            margin: EdgeInsets.all(10),
            child: Text('Sipariş İstekleri',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
        Center(
            child: CostomTextField(
          hint: 'Adet giriniz.',
          label: 'Adet',
          inputType: TextInputType.number,
          widh: 300,
          padding: EdgeInsets.only(top: 5),
          border: true,
          controller: adetCont,
        ))
      ]);
      int index = 0;
      mData.forEach((istegim) {
        switch (istegim.type) {
          case 0:
            {
              TextEditingController mCnt = new TextEditingController();
              mIsteklist.add(mCnt);
              mWidgets.add(
                Center(
                    child: CostomTextField(
                  hint: istegim.istenecek,
                  label: istegim.istenecek,
                  inputType: TextInputType.number,
                  widh: 300,
                  padding: EdgeInsets.only(top: 5),
                  border: true,
                  controller: mCnt,
                )),
              );
              break;
            }
          case 1:
            File mFil;
            mIsteklist.add(mFil);
            mWidgets.add(
              Center(
                child: Container(
                    width: 300,
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Primaryclor),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: <Widget>[
                        Text(
                          istegim.istenecek,
                          style: TextStyle(
                              fontSize: 16,
                              color: Primaryclor,
                              fontWeight: FontWeight.w700),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            mIsteklist[index] == null
                                ? Text('Henüz bir resim seçmediniz.')
                                : Image.file(
                                    mIsteklist[index],
                                    height: 100,
                                    width: 100,
                                  ),
                            RaisedButton(
                              onPressed: () async {
                                var k = await _imageatar();
                                setState(() {
                                  mIsteklist[_indexbulur(istegim.istenecek)] =
                                      k;
                                  _refresh();
                                });
                              },
                              color: Colors.green,
                              focusColor: Colors.lightGreen,
                              child: Text(
                                'Resim Seç',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            )
                          ],
                        ),
                      ],
                    )),
              ),
            );
            break;
          case 2:
            bool switcistegim = false;
            mIsteklist.add(switcistegim);
            mWidgets.add(Center(
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Primaryclor),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                margin: EdgeInsets.only(top: 5),
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(istegim.istenecek),
                    Switch(
                      onChanged: (activedbool) {
                        mIsteklist[_indexbulur(istegim.istenecek)] =
                            activedbool;
                        _refresh();
                      },
                      value: mIsteklist[_indexbulur(istegim.istenecek)],
                    ),
                  ],
                ),
              ),
            ));
            break;
          case 3:
            int radistegim;
            int k = 0;
            mIsteklist.add(radistegim);
            var lisofmRad = <Widget>[];
            istegim.list.forEach((eachedI) {
              lisofmRad.add(MyWidgets().mRadioButton(istegim.list[k], k,
                  mIsteklist[_indexbulur(istegim.istenecek)], (d) {
                mIsteklist[_indexbulur(istegim.istenecek)] = d;
                _refresh();
              }, Colors.transparent, AccentHard, Colors.black54, 14, 290, 1,
                  EdgeInsets.only(left: 10)));
              k++;
            });
            mWidgets.add(Center(
              child: Container(
                  width: 300,
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Primaryclor),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: <Widget>[
                      Text(
                        istegim.istenecek,
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
            ));
            break;
        }
        index++;
      });
      mWidgets.add(Center(
          child: CostomButton(
        onclick: () {
          _sepeteEkler();
        },
        text: 'Sepete Ekle',
        backgroundcolor: BlackLight_t,
        pressclor: AccentHard,
      )));
    });
    if (widget.isbeforeEdited && once) {
      once = false;
      List<String> cevap = widget.duzenlecenek.cevap;
      List<String> soru = widget.duzenlecenek.soru;
      int indx = 0;
      mData.forEach((each) {
        int k = 0;
        soru.forEach((e) {
          if (e == each.istenecek) {
            setState(() {
              switch (each.type) {
                case 0:
                  {
                    (mIsteklist[indx] as TextEditingController).text = cevap[k];
                    break;
                  }
                case 1:
                  {
                    //File fileNew=File(cevap[k]);
                    // mIsteklist[indx]=fileNew;
                    break;
                  }
                case 2:
                  {
                    bool switchN = true;
                    if (cevap[k] == 'Hayır') switchN = false;
                    mIsteklist[indx] = switchN;
                    break;
                  }
                case 3:
                  {
                    int radNew;
                    int indexlist = 0;
                    each.list.forEach((radE) {
                      if (radE == cevap[k]) {
                        radNew = indexlist;
                      } else {
                        indexlist++;
                      }
                    });
                    mIsteklist[indx] = radNew;
                    break;
                  }
              }
            });
          } else {
            k++;
          }
        });
        indx++;
      });
      adetCont.text = widget.duzenlecenek.adet;
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scrofkey,
        body: SingleChildScrollView(
          child: yukleme
              ? SplashScreen(
                  contex: context,
                  splashVisib: yukleme,
                  textprogress: proggres,
                )
              : Column(
                  children: mWidgets,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
        ),
      ),
    );
  }
}
