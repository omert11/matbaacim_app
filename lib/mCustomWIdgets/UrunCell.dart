import 'package:fexm/MyWidgets.dart';
import 'package:fexm/datas/urundata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'CircularImageInternet.dart';

class UrunCell extends StatefulWidget {
  const UrunCell(
      {@required this.onClick,
      @required this.directionisV,
      @required this.uData,
      this.gecerlilik: true});

  final bool directionisV;
  final bool gecerlilik;
  final Urundata uData;
  final VoidCallback onClick;

  @override
  _UrunCell createState() => _UrunCell();
}

class _UrunCell extends State<UrunCell> {
  Urundata uData;

  @override
  void initState() {
    uData = widget.uData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap:(){widget.onClick();},child:widget.directionisV
        ? Center(
        key: Key(uData.urunisim),
        child: Container(
          color: widget.gecerlilik
              ? Colors.lightGreen.withAlpha(30)
              : Colors.redAccent.withAlpha(30),
          padding: EdgeInsets.all(3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(onTap:(){MyWidgets().photoDialogCreater(context, <String>[uData.urunres]);},child:Image.network(
                uData.urunres,
                width: 125,
                height: 125,
              ) ,)
              ,
              Container(
                width: 175,
                child: Text(uData.urunisim,
                    style: TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w900),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis),
              ),
              Container(
                width: 175,
                child: Text(
                    widget.gecerlilik
                        ? 'Ürün yayında.'
                        : 'Ürün tamamlanmamış.',
                    style: TextStyle(
                        color: Primaryclor,
                        fontSize: 8,
                        fontWeight: FontWeight.w500),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis),
              )
            ],
          ),
        ))
        : Column(
      children: <Widget>[
        Row(
          children: <Widget>[
        InkWell(onTap:(){MyWidgets().photoDialogCreater(context, <String>[uData.urunres]);},child: Image.network(
              uData.urunres,
              width: 100,
              height: 100,
            )),
            Column(
              children: <Widget>[
                SizedBox(
                  width: 240,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 140,
                            child: Text(uData.urunisim,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900),
                                maxLines: 1,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis),
                          ),
                          Container(
                            width: 140,
                            child: Text(uData.baslik1,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w100),
                                maxLines: 1,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          CircularImageInternet(
                            url: uData.ureticires,
                            widh: 40,
                            heigh: 40,
                            border: true,
                            bacgroundcolor: Colors.white,
                          ),
                          Container(
                            width: 40,
                            child: Text(uData.ureticiisim,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w100),
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: 100,
                      margin: EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(uData.deger.toString(),
                              style: TextStyle(
                                  color: Primaryclor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                              maxLines: 1,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis),
                          MyWidgets().yIldizlar(uData.deger),
                          Text(
                              uData.degerlendirensay +
                                  ' kişi değerlendirdi.',
                              style: TextStyle(
                                  color: BlackLight_h,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w100),
                              maxLines: 1,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    Container(
                        width: 100,
                        margin: EdgeInsets.all(5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(uData.fiyat.toString() + " ₺",
                                style: TextStyle(
                                    color: Primaryclor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                                maxLines: 1,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis),
                            Opacity(
                              opacity: 0,
                              child: Icon(Icons.attach_money,
                                  color: Primaryclor, size: 10),
                            ),
                            Text('Adet fiyatı',
                                style: TextStyle(
                                    color: BlackLight_h,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w100),
                                maxLines: 1,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis),
                          ],
                        ))
                  ],
                )
              ],
            )
          ],
        ),
        Divider(
          thickness: 1,
          color: AccentHard,
        )
      ],
    ),) ;
  }
}
