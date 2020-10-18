import 'package:flutter/material.dart';

import 'MyWidgets.dart';
import 'datas/filterdata.dart';
import 'mCustomWIdgets/CostomTextField.dart';
import 'mCustomWIdgets/HorizontalIconButton.dart';
import 'main.dart';

class Filter extends StatefulWidget {
  final int filtP;

  Filter(this.filtP);

  @override
  _Filter createState() => _Filter(filtP);
}

class _Filter extends State<Filter> {
  int filtP;
  bool miner = false;
  bool maxer = false;
  int seciliradsirala = siralamasecili;
  int secilifiltKat = katagorisecili;
  int secilifiltRenk = renksecili;
  int secilifiltTas = tassecili;
  int secilifiltKar = kargosecili;
  int secilifiltUrtyer = urtimyrsecili;
  double secilifiltFiyatk = fiyatk;
  double secilifiltFiyatb = fiyatb;
  int secilifiltUretici = firmasecili;
  String sKat = 'Tümü';
  String sRenk = 'Tümü';
  String sTasarlama = 'Tümü';
  String sKarg = 'Tümü';
  String sUrtyeri = 'Tümü';
  String sFiyat = 'Tümü';
  String sUreticiF = 'Tümü';
  var katagoriListHorizontal = <Widget>[];

  _Filter(this.filtP);

  List<Widget> listW;

  @override
  void initState() {
    pager(filtP);
    katagorioFrag();
    super.initState();
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

  katagorioFrag() {
    katagoriListHorizontal.clear();
    setState(() {
      katagoriler.forEach((f) {
        katagoriListHorizontal.add(MyWidgets().mKatagorimHorizontal(
            f.katagori, f.baslik1, f.baslik2, f.toplamurun, f.katalogres));
      });
      pager(filtP);
    });
  }

  tiklanan(int id) {
    print(id);
    setState(() {
      seciliradsirala = id;
      pager(0);
    });
  }

  tiklananR(int id) {
    print(id);
    setState(() {
      secilifiltRenk = id;
      pager(3);
    });
  }

  tiklananT(int id) {
    print(id);
    setState(() {
      secilifiltTas = id;
      pager(4);
    });
  }

  tiklananK(int id) {
    print(id);
    setState(() {
      secilifiltKar = id;
      pager(5);
    });
  }

  filterAltAcar(int sekme) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Filter(sekme)),
    );
    switch (sekme) {
      case 2:
        {
          secilifiltKat = result;
          switch (result) {
            case -1:
              {
                setState(() {
                  sKat = 'Tümü';
                  pager(filtP);
                });
                break;
              }
            default:
              {
                setState(() {
                  sKat = katagoriler[result].katagori;
                  pager(filtP);
                });
              }
          }
          break;
        }
      case 3:
        {
          secilifiltRenk = result;
          switch (result) {
            case 0:
              {
                setState(() {
                  sRenk = 'Tümü';
                  pager(filtP);
                });
                break;
              }
            case 1:
              {
                setState(() {
                  sRenk = 'Tek renk';
                  pager(filtP);
                });
                break;
              }
            case 2:
              {
                setState(() {
                  sRenk = 'Çift renk';
                  pager(filtP);
                });
                break;
              }
            case 3:
              {
                setState(() {
                  sRenk = 'Üç renk';
                  pager(filtP);
                });
                break;
              }
            case 4:
              {
                setState(() {
                  sRenk = 'Dört renk';
                  pager(filtP);
                });
                break;
              }
          }
          break;
        }
      case 4:
        {
          secilifiltTas = result;
          switch (result) {
            case 0:
              {
                setState(() {
                  sTasarlama = 'Tümü';
                  pager(filtP);
                });
                break;
              }
            case 1:
              {
                setState(() {
                  sTasarlama = 'Kendi Tasarımım';
                  pager(filtP);
                });
                break;
              }
            case 2:
              {
                setState(() {
                  sTasarlama = 'Özel Tasarım';
                  pager(filtP);
                });
                break;
              }
          }
          break;
        }
      case 5:
        {
          secilifiltKar = result;
          switch (result) {
            case 0:
              {
                setState(() {
                  sKarg = 'Tümü';
                  pager(filtP);
                });
                break;
              }
            case 1:
              {
                setState(() {
                  sKarg = 'Ücretsiz';
                  pager(filtP);
                });
                break;
              }
          }
          break;
        }
      case 7:
        {
          var k = result[0] as double;
          var b = result[1] as double;
          secilifiltFiyatk = k;
          secilifiltFiyatb = b;
          if (k == 0 && b == 0) {
            setState(() {
              sFiyat = 'Tümü';
              pager(filtP);
            });
          } else if (k == 0) {
            setState(() {
              sFiyat = 'MIN - ' + b.toString();
              pager(filtP);
            });
          } else if (b == 0) {
            setState(() {
              sFiyat = k.toString() + ' - MAX';
              pager(filtP);
            });
          } else {
            setState(() {
              sFiyat = k.toString() + ' - ' + b.toString();
              pager(filtP);
            });
          }
        }
    }
  }

  pager(int page) {
    setState(() {
      switch (page) {
        case 0:
          {
            listW = [
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.pop(
                              context,
                              Filterdata(
                                  siralamasecili,
                                  katagorisecili,
                                  renksecili,
                                  tassecili,
                                  kargosecili,
                                  fiyatk,
                                  fiyatb,
                                  kelimesecili));
                        },
                        child: Text(
                          'İptal',
                          style: TextStyle(color: Primaryclor, fontSize: 15),
                        ),
                      ),
                      InkWell(
                        onTap: null,
                        child: Text(
                          'Sırala',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          siralamasecili = seciliradsirala;
                          Navigator.pop(
                              context,
                              Filterdata(
                                  seciliradsirala,
                                  katagorisecili,
                                  renksecili,
                                  tassecili,
                                  kargosecili,
                                  fiyatk,
                                  fiyatb,
                                  kelimesecili));
                        },
                        child: Text(
                          'Uygula',
                          style: TextStyle(color: Primaryclor, fontSize: 15),
                        ),
                      ),
                    ],
                  )),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    MyWidgets().mRadioButton(
                        'Fiyat artan',
                        0,
                        seciliradsirala,
                        tiklanan,
                        Colors.white,
                        AccentHard,
                        Colors.black54,
                        12,
                        360,
                        1,
                        EdgeInsets.only(left: 10)),
                    MyWidgets().mRadioButton(
                        'Fiyat azalan',
                        1,
                        seciliradsirala,
                        tiklanan,
                        Colors.white,
                        AccentHard,
                        Colors.black54,
                        12,
                        360,
                        1,
                        EdgeInsets.only(left: 10)),
                    MyWidgets().mRadioButton(
                        'Puan azalan',
                        2,
                        seciliradsirala,
                        tiklanan,
                        Colors.white,
                        AccentHard,
                        Colors.black54,
                        12,
                        360,
                        1,
                        EdgeInsets.only(left: 10)),
                    MyWidgets().mRadioButton(
                        'Puan artan',
                        3,
                        seciliradsirala,
                        tiklanan,
                        Colors.white,
                        AccentHard,
                        Colors.black54,
                        12,
                        360,
                        1,
                        EdgeInsets.only(left: 10)),
                    MyWidgets().mRadioButton(
                        'Alfabetik',
                        4,
                        seciliradsirala,
                        tiklanan,
                        Colors.white,
                        AccentHard,
                        Colors.black54,
                        12,
                        360,
                        1,
                        EdgeInsets.only(left: 10)),
                  ],
                ),
              )
            ];
            break;
          }
        case 1:
          {
            if (secilifiltKat != -1) {
              sKat = katagoriler[secilifiltKat].katagori;
            }
            if (secilifiltRenk != 0) {
              sRenk = secilifiltRenk == 1
                  ? 'Tek renk'
                  : (secilifiltRenk == 2
                      ? 'Çift renk'
                      : (secilifiltRenk == 3 ? 'Üç renk' : 'Dört renk'));
            }
            if (secilifiltTas != 0) {
              sTasarlama =
                  secilifiltTas == 1 ? 'Kendi Tasarımım' : 'Özel Tasarım';
            }
            if (secilifiltKar != 0) {
              sKarg = 'Ücretsiz';
            }
            if (secilifiltFiyatk != 0 || secilifiltFiyatb != 0) {
              sFiyat = secilifiltFiyatk == 0
                  ? 'MIN - ' + secilifiltFiyatb.toString()
                  : secilifiltFiyatb == 0
                      ? secilifiltFiyatk.toString() + ' - MAX'
                      : secilifiltFiyatk.toString() +
                          ' - ' +
                          secilifiltFiyatb.toString();
            }
            listW = [
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          katagorisecili = -1;
                          renksecili = 0;
                          tassecili = 0;
                          kargosecili = 0;
                          fiyatk = 0;
                          fiyatb = 0;
                          Navigator.pop(
                              context,
                              Filterdata(siralamasecili, -1, 0, 0, 0, 0, 0,
                                  kelimesecili));
                        },
                        child: Text(
                          'Temizle',
                          style: TextStyle(color: Primaryclor, fontSize: 15),
                        ),
                      ),
                      InkWell(
                        onTap: null,
                        child: Text(
                          'Filtreler',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          katagorisecili = secilifiltKat;
                          renksecili = secilifiltRenk;
                          tassecili = secilifiltTas;
                          kargosecili = secilifiltKar;
                          fiyatk = secilifiltFiyatk;
                          fiyatb = secilifiltFiyatb;
                          Navigator.pop(
                              context,
                              Filterdata(
                                  seciliradsirala,
                                  secilifiltKat,
                                  renksecili,
                                  tassecili,
                                  kargosecili,
                                  fiyatk,
                                  fiyatb,
                                  kelimesecili));
                        },
                        child: Text(
                          'Uygula',
                          style: TextStyle(color: Primaryclor, fontSize: 15),
                        ),
                      ),
                    ],
                  )),
              Container(
                height: 30,
              ),
              Column(
                children: <Widget>[
                  HorizontalIconButtton(
                      onclick: () {
                        filterAltAcar(2);
                      },
                      text: 'Katagori',
                      textisaretci: sKat,
                      paddingtext: EdgeInsets.only(left: 10),
                      iconcolor: Primaryclor),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: 360,
                    color: AccentHard,
                    child: Text('Ürün Özellikleri'),
                  ),
                  HorizontalIconButtton(
                      onclick: () {
                        filterAltAcar(3);
                      },
                      text: 'Renk',
                      textisaretci: sRenk,
                      paddingtext: EdgeInsets.only(left: 10),
                      iconcolor: Primaryclor),
                  HorizontalIconButtton(
                      onclick: () {
                        filterAltAcar(4);
                      },
                      text: 'Tasarlama',
                      textisaretci: sTasarlama,
                      paddingtext: EdgeInsets.only(left: 10),
                      iconcolor: Primaryclor),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: 360,
                    color: AccentHard,
                    child: Text('Ürün Bilgileri'),
                  ),
                  HorizontalIconButtton(
                      onclick: () {
                        filterAltAcar(5);
                      },
                      text: 'Kargo Durumu',
                      textisaretci: sKarg,
                      paddingtext: EdgeInsets.only(left: 10),
                      iconcolor: Primaryclor),
                  HorizontalIconButtton(
                      onclick: () {
                        filterAltAcar(6);
                      },
                      text: 'Üretildiği Yer',
                      textisaretci: sUrtyeri,
                      paddingtext: EdgeInsets.only(left: 10),
                      iconcolor: Primaryclor),
                  HorizontalIconButtton(
                      onclick: () {
                        filterAltAcar(7);
                      },
                      text: 'Fiyat',
                      textisaretci: sFiyat,
                      paddingtext: EdgeInsets.only(left: 10),
                      iconcolor: Primaryclor),
                  HorizontalIconButtton(
                    onclick: () {
                      filterAltAcar(8);
                    },
                    text: 'Üretici Firma',
                    textisaretci: sUreticiF,
                    paddingtext: EdgeInsets.only(left: 10),
                    iconcolor: Primaryclor,
                  ),
                ],
              )
            ];
            break;
          }
        case 2:
          {
            listW = [
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.pop(context, katagorisecili);
                        },
                        child: Text(
                          'Geri',
                          style: TextStyle(color: Primaryclor, fontSize: 15),
                        ),
                      ),
                      InkWell(
                        onTap: null,
                        child: Text(
                          'Katagori',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context, secilifiltKat);
                        },
                        child: Text(
                          'Uygula',
                          style: TextStyle(color: Primaryclor, fontSize: 15),
                        ),
                      ),
                    ],
                  )),
              Container(
                height: 20,
              ),
              HorizontalIconButtton(
                  onclick: () {
                    Navigator.pop(context, -1);
                  },
                  text: 'Tümü',
                  paddingtext: EdgeInsets.only(left: 10),
                  iconcolor: Primaryclor),
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
            ];
            break;
          }
        case 3:
          {
            listW = [
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.pop(context, renksecili);
                        },
                        child: Text(
                          'Geri',
                          style: TextStyle(color: Primaryclor, fontSize: 15),
                        ),
                      ),
                      InkWell(
                        onTap: null,
                        child: Text(
                          'Renk',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          renksecili = secilifiltRenk;
                          Navigator.pop(context, secilifiltRenk);
                        },
                        child: Text(
                          'Uygula',
                          style: TextStyle(color: Primaryclor, fontSize: 15),
                        ),
                      ),
                    ],
                  )),
              Container(
                height: 20,
              ),
              MyWidgets().mRadioButton(
                  'Tümü',
                  0,
                  secilifiltRenk,
                  tiklananR,
                  Colors.white,
                  AccentHard,
                  Colors.black54,
                  14,
                  360,
                  1,
                  EdgeInsets.only(left: 10)),
              MyWidgets().mRadioButton(
                  'Tek renk',
                  1,
                  secilifiltRenk,
                  tiklananR,
                  Colors.white,
                  AccentHard,
                  Colors.black54,
                  14,
                  360,
                  1,
                  EdgeInsets.only(left: 10)),
              MyWidgets().mRadioButton(
                  'Çift renk',
                  2,
                  secilifiltRenk,
                  tiklananR,
                  Colors.white,
                  AccentHard,
                  Colors.black54,
                  14,
                  360,
                  1,
                  EdgeInsets.only(left: 10)),
              MyWidgets().mRadioButton(
                  'Üç renk',
                  3,
                  secilifiltRenk,
                  tiklananR,
                  Colors.white,
                  AccentHard,
                  Colors.black54,
                  14,
                  360,
                  1,
                  EdgeInsets.only(left: 10)),
              MyWidgets().mRadioButton(
                  'Dört renk',
                  4,
                  secilifiltRenk,
                  tiklananR,
                  Colors.white,
                  AccentHard,
                  Colors.black54,
                  14,
                  360,
                  1,
                  EdgeInsets.only(left: 10)),
            ];
            break;
          }
        case 4:
          {
            listW = [
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.pop(context, tassecili);
                        },
                        child: Text(
                          'Geri',
                          style: TextStyle(color: Primaryclor, fontSize: 15),
                        ),
                      ),
                      InkWell(
                        onTap: null,
                        child: Text(
                          'Tasarlama',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          tassecili = secilifiltTas;
                          Navigator.pop(context, secilifiltTas);
                        },
                        child: Text(
                          'Uygula',
                          style: TextStyle(color: Primaryclor, fontSize: 15),
                        ),
                      ),
                    ],
                  )),
              Container(
                height: 20,
              ),
              MyWidgets().mRadioButton(
                  'Tümü',
                  0,
                  secilifiltTas,
                  tiklananT,
                  Colors.white,
                  AccentHard,
                  Colors.black54,
                  14,
                  360,
                  1,
                  EdgeInsets.only(left: 10)),
              MyWidgets().mRadioButton(
                  'Kendi Tasarımım',
                  1,
                  secilifiltTas,
                  tiklananT,
                  Colors.white,
                  AccentHard,
                  Colors.black54,
                  14,
                  360,
                  1,
                  EdgeInsets.only(left: 10)),
              MyWidgets().mRadioButton(
                  'Özel Tasarım',
                  2,
                  secilifiltTas,
                  tiklananT,
                  Colors.white,
                  AccentHard,
                  Colors.black54,
                  14,
                  360,
                  1,
                  EdgeInsets.only(left: 10)),
            ];
            break;
          }
        case 5:
          {
            listW = [
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.pop(context, kargosecili);
                        },
                        child: Text(
                          'Geri',
                          style: TextStyle(color: Primaryclor, fontSize: 15),
                        ),
                      ),
                      InkWell(
                        onTap: null,
                        child: Text(
                          'Kargo',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          kargosecili = secilifiltKar;
                          Navigator.pop(context, secilifiltKar);
                        },
                        child: Text(
                          'Uygula',
                          style: TextStyle(color: Primaryclor, fontSize: 15),
                        ),
                      ),
                    ],
                  )),
              Container(
                height: 20,
              ),
              MyWidgets().mRadioButton(
                  'Tümü',
                  0,
                  secilifiltKar,
                  tiklananK,
                  Colors.white,
                  AccentHard,
                  Colors.black54,
                  14,
                  360,
                  1,
                  EdgeInsets.only(left: 10)),
              MyWidgets().mRadioButton(
                  'Ücretsiz',
                  1,
                  secilifiltKar,
                  tiklananK,
                  Colors.white,
                  AccentHard,
                  Colors.black54,
                  14,
                  360,
                  1,
                  EdgeInsets.only(left: 10)),
            ];
            break;
          }
        case 7:
          {
            var cKucuk = TextEditingController();
            var cBuyuk = TextEditingController();
            cKucuk.addListener(() {
              if (cKucuk.text == '') {
                cKucuk.text = '0';
              }
              try {
                var parsed = double.parse(cKucuk.text);
                secilifiltFiyatk = parsed;
                miner = false;
              } catch (e) {
                setState(() {
                  miner = true;
                  pager(7);
                });
              }
            });
            cBuyuk.addListener(() {
              if (cBuyuk.text == '') {
                cBuyuk.text = '0';
              }
              try {
                var parsed = double.parse(cBuyuk.text);
                secilifiltFiyatb = parsed;
                maxer = false;
              } catch (e) {
                setState(() {
                  maxer = true;
                  pager(7);
                });
              }
            });
            cKucuk.text = secilifiltFiyatk.toString();
            cBuyuk.text = secilifiltFiyatb.toString();
            listW = [
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.pop(context, kargosecili);
                        },
                        child: Text(
                          'Geri',
                          style: TextStyle(color: Primaryclor, fontSize: 15),
                        ),
                      ),
                      InkWell(
                        onTap: null,
                        child: Text(
                          'Fiyat',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          fiyatk = secilifiltFiyatk;
                          fiyatb = secilifiltFiyatb;
                          Navigator.pop(
                              context, [secilifiltFiyatk, secilifiltFiyatb]);
                        },
                        child: Text(
                          'Uygula',
                          style: TextStyle(color: Primaryclor, fontSize: 15),
                        ),
                      ),
                    ],
                  )),
              Container(
                height: 10,
              ),
              CostomTextField(
                label: "Küçük değer",
                inputType: TextInputType.numberWithOptions(decimal: true),
                errored: miner,
                errortext: 'Doğru bir fiyatlandırma girin.',
                controller: cKucuk,
                padding: EdgeInsets.only(top: 10),
                border: true,
              ),
              CostomTextField(
                label: "Büyük değer",
                inputType: TextInputType.numberWithOptions(decimal: true),
                errored: maxer,
                errortext: 'Doğru bir fiyatlandırma girin.',
                controller: cBuyuk,
                padding: EdgeInsets.only(top: 10),
                border: true,
              ),
            ];
            break;
          }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 50),
            child: Column(children: listW)));
  }
// String textToSendBack ='degisaq';
// Navigator.pop(context, textToSendBack);
}
