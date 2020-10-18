import 'package:fexm/Editor.dart';
import 'package:fexm/MyWidgets.dart';
import 'package:fexm/mCustomWIdgets/CostomButton.dart';
import 'package:fexm/mCustomWIdgets/CostomTextField.dart';
import 'package:fexm/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'SiparisDetay.dart';
import 'datas/urundata.dart';

class EditorStarter extends StatefulWidget {
  @override
  _EditorStarter createState() => _EditorStarter();
}

class _EditorStarter extends State<EditorStarter>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  TextEditingController cntH=TextEditingController();
  TextEditingController cntW=TextEditingController();
  double opacitymain = 1;
  double scaleLogo = 1;
  double logotop = 150;
  double pagetop = 800;
  bool visiblemain = true;
  bool isMain = false;
  int pag;
  Color slectedColor = Colors.white;

  @override
  void initState() {
    controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    animation = Tween<double>(begin: 0, end: 500).animate(controller);
    animation.addListener(() {
      double value = animation.value;
      setState(() {
        if (isMain) {
          logotop = (value) / 500 * 150;
          scaleLogo = (500 + value) / 1000;
          pagetop = (value) / 500 * 800 + 100;
          if (value > 250) {
            visiblemain = true;
            opacitymain = (value - 250) / 250;
          } else {
            opacitymain = (250 - value) / 250;
          }
          if (animation.isCompleted) {
            isMain = false;
          }
        } else {
          logotop = (500 - value) / 500 * 150;
          scaleLogo = (1000 - value) / 1000;
          pagetop = (500 - value) / 500 * 800 + 100;
          if (value < 250) {
            opacitymain = (250 - value) / 250;
          } else {
            visiblemain = false;
            opacitymain = (value - 250) / 250;
          }
          if (animation.isCompleted) {
            isMain = true;
          }
        }
      });
    });
    super.initState();
  }
  _actionSelecter(int index,Urundata urundata,bool isSepet){
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text('Ne yapmak istiyorsunuz.',style:TextStyle(fontSize: 14),),
        content:Text('Önceden oluşturduğunuz bu çalışma ile ne yapmak istiyorsunuz.',style: TextStyle(fontSize: 12),),
        actions: <Widget>[
          FlatButton(
            child: const Text('Sil'),
            onPressed: () {
             FirebaseDatabase.instance.reference().child('Editored').child(isSepet?'Sepetler':'Olusturulan').child(kullaniciUid).child(urundata.urunisim+urundata.ureticiuid.substring(0,3)).remove();
             setState(() {
               sepetimBekleyen.removeAt(index);
             });
             Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text('Sipariş oluştur'),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SiparisDetay(uData:urundata)),
              );
            },
          ),
        ],
      ),
    );
  }
  _colorPicker() {
    void changeColor(Color color) {
      setState(() => slectedColor = color);
    }

    showDialog(
      context: context,
      child: AlertDialog(
        title: Text('Bir renk seç.'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: slectedColor,
            onColorChanged: changeColor,
            enableLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('Seç'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (isMain) {
            controller.reset();
            controller.forward();
            return false;
          } else {
            return true;
          }
        },
        child: MaterialApp(
          home: Scaffold(
            backgroundColor: BlackLight,
            body: Container(
              width: double.infinity,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: logotop,
                    left: 0,
                    right: 0,
                    child: Transform.scale(
                      scale: scaleLogo,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'Matbaacım',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w200,
                                  fontSize: 60),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  'Editor',
                                  style: TextStyle(
                                      color: Primaryclor,
                                      fontFamily: 'lato',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20),
                                ),
                                Container(
                                  width: 10,
                                ),
                                Text(
                                  'v0.0.1',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'lato',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 400,
                    right: 0,
                    child: Visibility(
                      visible: visiblemain,
                      child: Opacity(
                        opacity: opacitymain,
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    pag = 0;
                                    controller.reset();
                                    controller.forward();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Column(
                                      children: <Widget>[
                                        Icon(
                                          Icons.insert_drive_file,
                                          size: 90,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          'Yeni Oluştur',
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    pag = 1;
                                    controller.reset();
                                    controller.forward();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Column(
                                      children: <Widget>[
                                        Icon(
                                          Icons.folder,
                                          size: 90,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          'Kayıtlılar',
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 35,
                            ),
                            Text(
                              'Kolaylaştırmak için çalışıyoruz.',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w200),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: pagetop,
                    left: 0,
                    right: 0,
                    child: Visibility(
                      visible: !visiblemain,
                      child: Opacity(
                        opacity: opacitymain,
                        child: Container(
                            child: pag == 0
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        child: Text(
                                          'Tuval boyutu',
                                          style: TextStyle(
                                              color: Primaryclor,
                                              fontWeight: FontWeight.w300,
                                              fontFamily: 'lato',
                                              fontSize: 18),
                                        ),
                                        padding: EdgeInsets.only(left: 10),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: 65, top: 20),
                                        width: 230,
                                        decoration: BoxDecoration(
                                            color: BlackLight_h,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            border: Border.all(
                                                color: BlackLight_t)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            CostomTextField(
                                              textcolor: Colors.white,
                                              hintcolor: Colors.white,
                                              border: false,
                                              controller: cntH,
                                              textAlign: TextAlign.center,
                                              inputType: TextInputType
                                                  .numberWithOptions(
                                                      decimal: true),
                                              hint: 'Yükseklik(H)',
                                              widh: 100,
                                            ),
                                            Text(
                                              'X',
                                              style:
                                                  TextStyle(color: Primaryclor),
                                            ),
                                            CostomTextField(
                                              textcolor: Colors.white,
                                              hintcolor: Colors.white,
                                              textAlign: TextAlign.center,
                                              inputType: TextInputType
                                                  .numberWithOptions(
                                                      decimal: true),
                                              border: false,
                                              controller: cntW,
                                              hint: 'Genişlik(W)',
                                              widh: 100,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 10,
                                      ),
                                      Padding(
                                        child: Text(
                                          'Tuval rengi',
                                          style: TextStyle(
                                              color: Primaryclor,
                                              fontFamily: 'lato',
                                              fontWeight: FontWeight.w300,
                                              fontSize: 18),
                                        ),
                                        padding: EdgeInsets.only(left: 10),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: 65, top: 20),
                                        padding: EdgeInsets.all(10),
                                        width: 230,
                                        decoration: BoxDecoration(
                                            color: BlackLight_h,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            border: Border.all(
                                                color: BlackLight_t)),
                                        child: InkWell(
                                          onTap: () {
                                            _colorPicker();
                                          },
                                          child: Container(
                                            height: 25,
                                            color: slectedColor,
                                          ),
                                        ),
                                      ),
                                      CostomButton(
                                        text: 'Oluştur',
                                        onclick: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Editor(isCreated: true,picH:double.parse(cntH.text),picW: double.parse(cntW.text),bacgroundcolor: slectedColor,)));
                                        },
                                        widh: 230,
                                        padding:
                                            EdgeInsets.only(left: 65, top: 15),
                                        backgroundcolor: BlackLight_h,
                                        pressclor: BlackLight,
                                      ),
                                      CostomButton(
                                        text: 'Geri',
                                        onclick: () {
                                          controller.reset();
                                          controller.forward();
                                        },
                                        widh: 230,
                                        padding:
                                            EdgeInsets.only(left: 65, top: 15),
                                        backgroundcolor: BlackLight_h,
                                        pressclor: BlackLight,
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: <Widget>[
                                      Padding(
                                        child: Text(
                                          'Kayıtlı dosyalar',
                                          style: TextStyle(
                                              color: Primaryclor,
                                              fontWeight: FontWeight.w300,
                                              fontFamily: 'lato',
                                              fontSize: 18),
                                        ),
                                        padding: EdgeInsets.only(left: 0),
                                      ),
                                      Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
                                        Icon(Icons.info,color: Primaryclor,),
                                        Container(width: 5,),
                                        Text('Daha fazla seçenek için basılı tutun',style: TextStyle(color: Primaryclor,fontSize: 14,fontWeight: FontWeight.w100),)
                                      ],),
                                      ScrollConfiguration(
                                          behavior: MyBehavior(),
                                          child: GridView.builder(
                                              shrinkWrap: true,
                                              itemCount: sepetimBekleyen.length,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                childAspectRatio: 1,
                                                mainAxisSpacing: 10,
                                              ),
                                              itemBuilder: (BuildContext cntx,
                                                  int index){
                                                var data = sepetimBekleyen[index];
                                                Urundata urundat=MyWidgets().urunFinder(data.urunI);
                                                return InkWell(
                                                  onLongPress: (){
                                                    _actionSelecter(index,urundat,true);
                                                  },
                                                  onTap:(){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Editor(isCreated: false,uData:urundat,adWidgs:data.screenResources,)));
                                                },child:Container(
                                                  child:
                                                  Image.network(data.sRes),
                                                ) ,);
                                              }))
                                    ],
                                  )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
