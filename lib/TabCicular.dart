import 'dart:math';
import 'package:fexm/datas/urundata.dart';
import 'package:fexm/mCustomWIdgets/CostomButton.dart';
import 'package:flutter/material.dart';
import 'UrunDetay.dart';
import 'UrunOlustur.dart';
import 'mCustomWIdgets/UrunCell.dart';
import 'main.dart';

class TabCircular extends StatefulWidget {
  final BuildContext cntx;

  TabCircular(this.cntx);

  @override
  _TabCircular createState() => _TabCircular(cntx);
}

class _TabCircular extends State<TabCircular>
    with SingleTickerProviderStateMixin {
  BuildContext cntx;

  _TabCircular(this.cntx);

  Animation<double> animation;
  AnimationController controller;
  double rCircularOne = 0;
  double tCircularOne = 150;
  double heightw = 800;
  String yUrunum = murunYarim.length.toString() + ' ürününüz tamamlanmamış.';
  double opCirc = 1;
  String tOne = 'Ürünleriniz';
  String tTwo = 'Ürünleriniz hakkında detaylı bilgiyi buradan alabilirsiniz.';
  String bOne = 'Sayfa Geçmek İçin Kaydır.';
  String bTwo = 'Sonraki Sayfa Yorumlar.';
  int dr = 0;
  Offset dMoved;
  List<Widget> _mPages;
  var murunListVertical = <Urundata>[];

  Color cCicle = Colors.deepOrangeAccent;

  @override
  void initState() {
    _mUrunlist();
    _mPager(0);
    controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    animation = Tween<double>(begin: rCircularOne, end: 0).animate(controller);
    animation.addListener(() {
      setState(() {
        double animatedV = animation.value;
        switch (dr) {
          case 0:
            {
              rCircularOne = sqrt((150 * 150) - (animatedV * animatedV));
              tCircularOne = animatedV;
              opCirc = tCircularOne / 150;
              if (animation.isCompleted) {
                opCirc = 1;
                rCircularOne = 0;
                tCircularOne = 150;
              }
              break;
            }
          case 1:
            {
              rCircularOne = sqrt((150 * 150) - (animatedV * animatedV));
              tCircularOne = animatedV;
              opCirc = tCircularOne / 150;
              if (animation.isCompleted) {
                opCirc = 0;
                tCircularOne = -50;
                dr = 2;
                if (cCicle == Colors.deepOrangeAccent) {
                  _mPager(1);
                  cCicle = Colors.blueAccent;
                  tOne = 'Yorumlar';
                  tTwo =
                      'Şirketiniz hakkında detaylı yorum bilgileriniz burda bulunur.İster cevaplayın ister göz atın.';
                  bTwo = 'Sonraki Sayfa İstatistikler.';
                } else if (cCicle == Colors.blueAccent) {
                  _mPager(2);
                  cCicle = Colors.pinkAccent;
                  tOne = 'İstatistik';
                  tTwo =
                      'Profil detaylarınız ödeme sipariş geçmişiniz ve bütün istatistikler burda toplanır.';
                  bTwo = 'Sonraki Sayfa Ürünler.';
                } else if (cCicle == Colors.pinkAccent) {
                  _mPager(0);
                  cCicle = Colors.deepOrangeAccent;
                  tOne = 'Ürünler';
                  tTwo =
                      'Ürünleriniz hakkında detaylı bilgiyi buradan alabilirsiniz.';
                  bTwo = 'Sonraki Sayfa Yorumlar.';
                }
                animation =
                    Tween<double>(begin: -100, end: 0).animate(controller);
                controller.reset();
                controller.forward();
              }
              break;
            }
          case 2:
            {
              rCircularOne = animatedV;
              opCirc = 1;
              tCircularOne = sqrt((150 * 150) - (animatedV * animatedV));
              if (animation.isCompleted) {
                rCircularOne = 0;
                tCircularOne = 150;
                dr = 0;
              }
              break;
            }
        }
      });
    });
    super.initState();
  }

  urunDetay(String urunIsim) {
    urunler.forEach((eached) {
      if (eached.urunisim == urunIsim) {
        Navigator.push(
          cntx,
          MaterialPageRoute(builder: (context) => UrunDetay(true, eached)),
        );
      }
    });
  }

  urunOlusturucuAc(String urunIsim, bool yenimi) async {
    await Navigator.push(
      cntx,
      MaterialPageRoute(builder: (context) => UrunOlustur(urunIsim, yenimi)),
    );
    _mUrunlist();
    _mPager(0);
  }

  Offset _koordinathesaplar(double y, double x) {
    Offset mOfset;
    if (y < 0) {
      y = y * -1;
    }
    if (x < 0) {
      x = x * -1;
    }
    double uzaklik = _uzaklikolcer(x, y);
    double mY = (150 * y) / (150 + uzaklik);
    double mX = (150 * x) / (150 + uzaklik);
    mOfset = Offset(mX, mY);
    return mOfset;
  }

  double _uzaklikolcer(double x, double y) {
    double uz = sqrt((x * x) + (y * y)) - 150;
    return uz;
  }

  _mUrunlist() {
    murunListVertical.clear();
    murunYarim.forEach((f) {
      murunListVertical.add(f);
    });
    urunler.forEach((f) {
      if (f.ureticires == sirketData.uRes) {
        murunListVertical.add(f);
      }
    });
  }

  _mPager(int page) {
    setState(() {
      switch (page) {
        case 0:
          {
            var k = (murunListVertical.length % 2 == 0
                    ? murunListVertical.length
                    : (murunListVertical.length + 1)) /
                2;
            print(k);
            heightw = (k * 200) + 350;
            _mPages = [
              CostomButton(
                text: 'Ürün Oluştur',
                onclick: () {
                  urunOlusturucuAc('', true);
                },
                backgroundcolor: Colors.deepOrangeAccent,
                pressclor: Colors.deepOrangeAccent.withAlpha(100),
                radius: 10,
                widh: 300,
              ),
              Container(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(),
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: 1,
                      ),
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: murunListVertical.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext ctxt, int index) {
                        var f = murunListVertical[index];
                           void onClick() {
                          index + 1 <= murunYarim.length
                              ? urunOlusturucuAc(
                             f.urunisim,
                              false)
                              : urunDetay(f.urunisim);
                        }
                        return UrunCell(directionisV: true,uData: f,gecerlilik:index + 1 <= murunYarim.length
                            ?  false:true,onClick:onClick,);
                      }),
                ),
              ),
            ];
            break;
          }
        case 1:
          {
            heightw = 200;
            _mPages = [];
            break;
          }
        case 2:
          {
            heightw = 200;
            _mPages = [];
            break;
          }
      }
    });
  }

  _mOlcek() {
    double tX = 360 - dMoved.dx;
    double tY = dMoved.dy - 255;
    var legjt = _koordinathesaplar(tY, tX);
    setState(() {
      rCircularOne = legjt.dx;
      tCircularOne = legjt.dy;
      opCirc = tCircularOne / 150;
      if (legjt.dy > 50) {
      } else {}
    });
  }

  _aDurum() {
    if (tCircularOne > 80) {
      dr = 0;
    } else {
      dr = 1;
    }
    switch (dr) {
      case 0:
        {
          animation =
              Tween<double>(begin: tCircularOne, end: 150).animate(controller);
          controller.reset();
          controller.forward();
          break;
        }
      case 1:
        {
          animation =
              Tween<double>(begin: tCircularOne, end: 0).animate(controller);
          controller.reset();
          controller.forward();
          break;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: heightw,
      child: Stack(
        children: <Widget>[
          Positioned(
              right: -170,
              top: -170,
              child: Container(
                  width: 350,
                  height: 350,
                  decoration: new BoxDecoration(
                    color: cCicle.withAlpha(150),
                    shape: BoxShape.circle,
                  ))),
          Positioned(
            top: 0,
            child: Container(
                height: 200, width: 400, color: cCicle.withAlpha(175)),
          ),
          Positioned(
              top: 50,
              left: 20,
              child: Container(
                width: 150,
                child: Column(
                  children: <Widget>[
                    Text(
                      tOne,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                    Text(tTwo,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w200,
                            fontSize: 12),
                        textAlign: TextAlign.center),
                  ],
                ),
              )),
          Positioned(
              top: 20,
              right: 5,
              child: Container(
                width: 150,
                child: Column(
                  children: <Widget>[
                    Text(
                      bOne,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    Text(bTwo,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w200,
                            fontSize: 12),
                        textAlign: TextAlign.center),
                  ],
                ),
              )),
          Positioned(
            right: -170,
            top: -170,
            child: Container(
              width: 350,
              height: 350,
              child: CustomPaint(
                foregroundPainter: MyPainter(
                    lineColor: Colors.white,
                    completeColor: cCicle.withAlpha(90),
                    completePercent: -((tCircularOne / 6) + 25),
                    width: 8.0),
              ),
            ),
          ),
          Positioned(
            right: rCircularOne,
            top: tCircularOne,
            child: Opacity(
              opacity: opCirc,
              child: GestureDetector(
                  onHorizontalDragUpdate: (dragDowned) {
                    dMoved = dragDowned.globalPosition;
                    _mOlcek();
                  },
                  onVerticalDragUpdate: (dragDowned) {
                    dMoved = dragDowned.globalPosition;
                    _mOlcek();
                  },
                  onHorizontalDragEnd: (end) {
                    _aDurum();
                  },
                  onVerticalDragEnd: (end) {
                    _aDurum();
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: new BoxDecoration(
                      color: cCicle,
                      border: Border.all(color: Colors.white, width: 3),
                      shape: BoxShape.circle,
                    ),
                  )),
            ),
          ),
          Positioned(
            top: 220,
            child: Container(
              width: 360,
              child: Column(
                children: _mPages,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  Color lineColor;
  Color completeColor;
  double completePercent;
  double width;

  MyPainter(
      {this.lineColor, this.completeColor, this.completePercent, this.width});

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Paint complete = new Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width + 0.3;
    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, line);
    double arcAngle = 2 * pi * (completePercent / 100);
    canvas.drawArc(new Rect.fromCircle(center: center, radius: radius), -pi / 2,
        arcAngle, false, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
