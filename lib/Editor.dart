import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:fexm/datas/urundata.dart';
import 'package:fexm/mCustomWIdgets/CostomTextField.dart';
import 'package:fexm/mCustomWIdgets/ImageSizerPicker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:path/path.dart' as p;
import 'package:fexm/MyWidgets.dart';
import 'package:fexm/datas/editoraddData.dart';
import 'package:fexm/mCustomWIdgets/FontPicker.dart';
import 'package:fexm/mCustomWIdgets/MovedImage.dart';
import 'package:fexm/mCustomWIdgets/MovedText.dart';
import 'package:fexm/mCustomWIdgets/TextSizerPicker.dart';
import 'package:fexm/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'SiparisDetay.dart';

class Editor extends StatefulWidget {
  const Editor(
      {@required this.isCreated,
      this.uData,
      this.adWidgs,
      this.bacgroundcolor,
      this.picH,
      this.picW});

  final bool isCreated;
  final Urundata uData;
  final Color bacgroundcolor;
  final double picH;
  final double picW;
  final List<EditoraddData> adWidgs;

  @override
  _Editor createState() => _Editor();
}

class _Editor extends State<Editor> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  TextEditingController cntCreate = TextEditingController();
  FontWeight selectedwidh = FontWeight.w400;
  Color slectedcolor = Colors.black;
  Color bacgroundcolor = Colors.white;
  File focussedImage;
  Offset mPosstart;
  Offset mArea;
  Offset midscalepo;
  Offset focussedPos;
  double picH = 0;
  double picW = 0;
  double picScle = 1;
  GlobalKey previewContainer = new GlobalKey();
  final scrolfld = new GlobalKey<ScaffoldState>();
  double focussedScle = 1;
  double picScleEnd = 1;
  double screenH = 739.34;
  double screenW = 360.0;
  double selectedsize = 14;
  double layertapmargin = -200;
  int focussedIndx;
  String slectedFontFamily = 'lato';
  bool refesher = false;
  bool once = true;
  bool isopen = false;
  bool loading = false;
  List<Widget> aDdingWidGs = <Widget>[];
  List<EditoraddData> aDdingWidDs = <EditoraddData>[];

  @override
  void initState() {
    if (!widget.isCreated) {
      Image image = new Image.network(widget.uData.sampleres);
      image.image
          .resolve(ImageConfiguration())
          .addListener(ImageStreamListener((imageinf, b) {
        setState(() {
          picW = imageinf.image.width.toDouble();
          picH = imageinf.image.height.toDouble();
          aDdingWidGs.add(Positioned(
            left: 0,
            top: 0,
            child: image,
          ));
          aDdingWidDs.add(EditoraddData.back(0));
          picScle = 1;
          picScleEnd = 1;
          midscalepo = Offset(
              (((picW * picScle) - picW) / 2), (((picH * picScle) - picH) / 2));
          mArea =
              Offset((screenW / 2) - (picW / 2), (screenH / 2) - (picH / 2));
          if (widget.adWidgs != null) {
            if (widget.adWidgs.isNotEmpty) {
              _resourcesAdder();
            }
          }
        });
      }));
    } else {
      setState(() {
        bacgroundcolor = widget.bacgroundcolor;
        picH = widget.picH;
        picW = widget.picW;
      });
    }
    mArea = Offset((screenW / 2) - (picW / 2), (screenH / 2) - (picH / 2));
    midscalepo = Offset(
        (((picW * picScle) - picW) / 2), (((picH * picScle) - picH) / 2));
    controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    animation = Tween<double>(begin: 0, end: 200).animate(controller);
    animation.addListener(() {
      setState(() {
        double animatedval = animation.value;
        if (isopen) {
          double setval = -animatedval;
          layertapmargin = setval;
          if (animation.isCompleted) isopen = false;
        } else {
          double setval = animatedval - 200;
          layertapmargin = setval;
          if (animation.isCompleted) isopen = true;
        }
      });
    });
    super.initState();
  }

  _fontPicker() {
    void changeFont(String fontfam) {
      setState(() => slectedFontFamily = fontfam);
    }

    showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Yazı fontunu ayarla.'),
          content: FontPicker(
              sizeValue: selectedsize,
              selectedColor: slectedcolor,
              widhValue: selectedwidh,
              onFontChanged: changeFont,
              font: slectedFontFamily),
        ));
  }

  _changer(int index, String textCr, Color colorT, double textSize,
      FontWeight textWidh, Offset positionT) {
    EditoraddData mAddData = EditoraddData.text(1, positionT.dx, positionT.dy,
        textCr, colorT.value, textSize, slectedFontFamily, textWidh.index);
    void onDoubleTap(int index) {
      MovedText dat = aDdingWidGs[index];
      setState(() {
        cntCreate.text = dat.text;
        slectedFontFamily = dat.fontFamily;
        selectedwidh = dat.fontWidh;
        selectedsize = dat.fontSize;
        slectedcolor = dat.textColor;
        focussedPos = dat.position;
        focussedIndx = index;
      });
    }

    print(index);
    setState(() {
      aDdingWidDs[index] = mAddData;
      aDdingWidGs[index] = MovedText(
        onDoubleTap: onDoubleTap,
        index: index,
        text: textCr,
        fontSize: textSize,
        fontWidh: textWidh,
        textColor: colorT,
        picScle: picScle,
        areaPos: mArea,
        midScaledPos: midscalepo,
        position: positionT,
        fontFamily: slectedFontFamily,
      );
    });
  }

  _resourcesAdder() {
    int k = 1;
    widget.adWidgs.forEach((eachedRs) {
      switch (eachedRs.type) {
        case 1:
          {
            FontWeight fontWeight;
            switch (eachedRs.mFontweight) {
              case 0:
                fontWeight = FontWeight.w100;
                break;
              case 1:
                fontWeight = FontWeight.w200;
                break;
              case 2:
                fontWeight = FontWeight.w300;
                break;
              case 3:
                fontWeight = FontWeight.w400;
                break;
              case 4:
                fontWeight = FontWeight.w500;
                break;
              case 5:
                fontWeight = FontWeight.w600;
                break;
              case 6:
                fontWeight = FontWeight.w700;
                break;
              case 7:
                fontWeight = FontWeight.w800;
                break;
              case 8:
                fontWeight = FontWeight.w900;
                break;
            }
            setState(() {
              void onDoubleTappedText(int index) {
                MovedText dat = aDdingWidGs[index];
                setState(() {
                  cntCreate.text = dat.text;
                  selectedwidh = dat.fontWidh;
                  selectedsize = dat.fontSize;
                  slectedFontFamily = dat.fontFamily;
                  slectedcolor = dat.textColor;
                  focussedPos = dat.position;
                  focussedIndx = index;
                });
              }

              aDdingWidGs.add(MovedText(
                onDoubleTap: onDoubleTappedText,
                areaPos: mArea,
                fontFamily: eachedRs.mFontStyle,
                fontSize: eachedRs.mFontSize,
                index: k,
                fontWidh: fontWeight,
                midScaledPos: midscalepo,
                picScle: picScle,
                position: Offset(eachedRs.positionx, eachedRs.positiony),
                text: eachedRs.mText,
                textColor: Color(eachedRs.mColor),
              ));
              aDdingWidDs.add(eachedRs);
            });
            k++;
            break;
          }
        case 2:
          {

            setState(() {
              void onDoubleTappedImage(int index) {
                MovedImage dat = aDdingWidGs[index];
                setState(() {
                  focussedImage = dat.imageFile;
                  focussedPos = dat.position;
                  focussedScle = dat.imageScle;
                  focussedIndx = index;
                });
              }

              aDdingWidGs.add(MovedImage(
                areaPos: mArea,
                imageFile: File(eachedRs.imagePath),
                imageScle: eachedRs.mImageSclae,
                index: k,
                midScaledPos: midscalepo,
                picScle: picScle,
                position: Offset(eachedRs.positionx, eachedRs.positiony),
                onDoubleTap: onDoubleTappedImage,
              ));
              aDdingWidDs.add(eachedRs);
            });
            k++;
            break;
          }
      }
    });
  }

  _changerI(int index, Offset positionT, File image, double scale) {
    void onDoubleTap(int index) {
      MovedImage dat = aDdingWidGs[index];
      setState(() {
        focussedImage = dat.imageFile;
        focussedPos = dat.position;
        focussedIndx = index;
        focussedScle = dat.imageScle;
      });
    }

    print(index);
    setState(() {
      aDdingWidGs[index] = MovedImage(
          onDoubleTap: onDoubleTap,
          index: index,
          picScle: picScle,
          areaPos: mArea,
          midScaledPos: midscalepo,
          position: positionT,
          imageFile: image,
          imageScle: scale);
    });
  }

  _textSizePicker(String textInput) {
    void changeSize(double size) {
      setState(() => selectedsize = size);
    }

    void changeWidh(FontWeight widh) {
      setState(() => selectedwidh = widh);
    }

    showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Yazı boyutunu ayarla.'),
          content: TextSizerPicker(
            selectedColor: slectedcolor,
            sizeValue: selectedsize,
            onSizeChanged: changeSize,
            selectedFontfamily: slectedFontFamily,
            textImput: textInput,
            onWidhChanged: changeWidh,
            widhValue: selectedwidh,
          ),
        ));
  }

  _imageSizePicker(double scale) {
    void changeSize(double size) {
      setState(() => focussedScle = size);
    }

    showDialog(
        context: context,
        child: AlertDialog(
            title: Text('Yazı boyutunu ayarla.'),
            content: ImageSizerPicker(
              onSizeChanged: changeSize,
              sizeValue: scale,
            )));
  }

  _colorPicker() {
    void changeColor(Color color) {
      setState(() => slectedcolor = color);
    }

    showDialog(
      context: context,
      child: AlertDialog(
        title: Text('Bir renk seç.'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: slectedcolor,
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

  siparisDevamDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Matbaacım',
              style: TextStyle(color: Primaryclor),
            ),
            contentTextStyle:
                TextStyle(fontWeight: FontWeight.w300, color: Colors.black54),
            content:
                Text('Yaptığınız çalışma kaydedildi devam etmek istermisiniz.'),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Devam et',
                  style: TextStyle(color: Primaryclor),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(
                  'Şiparişe geç',
                  style: TextStyle(color: Primaryclor),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SiparisDetay(uData: widget.uData,)),
                  );
                },
              ),
            ],
          );
        });
  }

  Future _imagePicker() async {
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
        focussedImage = imagge;
        focussedIndx = aDdingWidDs.length;
      }
    });
  }

  _cropper() async {
    var imagge = await ImageCropper.cropImage(
        compressFormat: ImageCompressFormat.png,
        sourcePath: focussedImage.path,
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
        focussedImage = imagge;
        focussedIndx = aDdingWidDs.length;
      }
    });
  }

  posRefresher() {
    int index = 0;
    aDdingWidGs.forEach((widgets) {
      switch (aDdingWidDs[index].type) {
        case 1:
          {
            MovedText dat = aDdingWidGs[index];
            aDdingWidDs[index] = EditoraddData.text(
                1,
                dat.position.dx,
                dat.position.dy,
                dat.text,
                dat.textColor.value,
                dat.fontSize,
                dat.fontFamily,
                dat.fontWidh.index);
            break;
          }
        case 2:
          {
            MovedImage dat = aDdingWidGs[index];
            aDdingWidDs[index] = EditoraddData.image(2, dat.position.dx,
                dat.position.dy, dat.imageScle, dat.imageFile.path);
            break;
          }
      }
      index++;
    });
  }

  takeScreenShotunCreate() async {
    posRefresher();
    setState(() {
      loading = true;
    });
    RenderRepaintBoundary boundary =
        previewContainer.currentContext.findRenderObject();
    double pixelRatio = 5;
    ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    StorageUploadTask mtask = FirebaseStorage.instance
        .ref()
        .child("KullaniciDatasi")
        .child(kullaniciUid)
        .child('editting')
        .child(widget.uData.urunisim + '.png')
        .putData(pngBytes);
    mtask.onComplete.then((val) async {
      String downurl = await val.ref.getDownloadURL();
      var taskDatabase = FirebaseDatabase.instance
          .reference()
          .child('Editored')
          .child('Sepetler')
          .child(kullaniciUid)
          .child(widget.uData.urunisim + widget.uData.ureticiuid.substring(0, 3))
          .child('picres')
          .set(downurl);
      List<EditoraddData> savedlist = <EditoraddData>[];
      savedlist.addAll(aDdingWidDs);
      savedlist.removeAt(0);
      taskDatabase.whenComplete(() {
        int k = 0;
        savedlist.forEach((eached) {
          FirebaseDatabase.instance
              .reference()
              .child('Editored')
              .child('Sepetler')
              .child(kullaniciUid)
              .child(widget.uData.urunisim + widget.uData.ureticiuid.substring(0, 3))
              .child('screenResources')
              .child(k.toString())
              .set(eached.tojson());
          if (eached == savedlist.last) {
            setState(() {
              loading = false;
              siparisDevamDialog();
            });
          } else {
            k++;
          }
        });
      });
    });
  }
  takeScreenShotCreate() async {
    posRefresher();
    setState(() {
      loading = true;
    });
    RenderRepaintBoundary boundary =
        previewContainer.currentContext.findRenderObject();
    double pixelRatio = 5;
    ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    StorageUploadTask mtask = FirebaseStorage.instance
        .ref()
        .child("KullaniciDatasi")
        .child(kullaniciUid)
        .child('editting')
        .child(picW.toString()+'x'+picH.toString()+widget.bacgroundcolor.value.toString()+ '.png')
        .putData(pngBytes);
    mtask.onComplete.then((val) async {
      String downurl = await val.ref.getDownloadURL();
      var taskDatabase = FirebaseDatabase.instance
          .reference()
          .child('Editored')
          .child('Olusturulan')
          .child(kullaniciUid)
          .child(picW.floor().toString()+'x'+picH.floor().toString()+widget.bacgroundcolor.value.toString())
          .child('picres')
          .set(downurl);
      List<EditoraddData> savedlist = <EditoraddData>[];
      savedlist.addAll(aDdingWidDs);
      taskDatabase.whenComplete(() {
        int k = 0;
        if(savedlist.isEmpty){
          setState(() {
            loading = false;
          });
        }else{
        savedlist.forEach((eached) {
          FirebaseDatabase.instance
              .reference()
              .child('Editored')
              .child('Olusturulan')
              .child(kullaniciUid)
              .child(picW.toString()+'x'+picH.toString()+widget.bacgroundcolor.value.toString())
              .child('screenResources')
              .child(k.toString())
              .set(eached.tojson());
          if (eached == savedlist.last) {
            setState(() {
              loading = false;
            });
          } else {
            k++;
          }
        });}
      });
    });
  }

  _layerOpenner() {
    controller.reset();
    controller.forward();
  }

  _aDder(int type, String textCr, Color colorT, double textSize,
      FontWeight textWidh, Offset positionT, File image, double imagescle) {
    void onDoubleTappedText(int index) {
      MovedText dat = aDdingWidGs[index];
      setState(() {
        cntCreate.text = dat.text;
        selectedwidh = dat.fontWidh;
        selectedsize = dat.fontSize;
        slectedFontFamily = dat.fontFamily;
        slectedcolor = dat.textColor;
        focussedPos = dat.position;
        focussedIndx = index;
      });
    }

    void onDoubleTappedImage(int index) {
      MovedImage dat = aDdingWidGs[index];
      setState(() {
        focussedImage = dat.imageFile;
        focussedPos = dat.position;
        focussedScle = dat.imageScle;
        focussedIndx = index;
      });
    }

    final int index = aDdingWidDs.length;
    switch (type) {
      case 0:
        {
          setState(() {
            EditoraddData mAddData = EditoraddData.text(
                1,
                positionT.dx,
                positionT.dy,
                textCr,
                colorT.value,
                textSize,
                slectedFontFamily,
                textWidh.index);
            aDdingWidDs.add(mAddData);
            aDdingWidGs.add(MovedText(
              onDoubleTap: onDoubleTappedText,
              index: index,
              text: textCr,
              fontSize: textSize,
              fontWidh: textWidh,
              textColor: colorT,
              picScle: picScle,
              areaPos: mArea,
              midScaledPos: midscalepo,
              position: positionT,
              fontFamily: slectedFontFamily,
            ));
          });
          break;
        }
      case 1:
        {
          setState(() {
            EditoraddData mAddData = EditoraddData.image(
                2, positionT.dx, positionT.dy, imagescle, image.path);
            aDdingWidDs.add(mAddData);
            aDdingWidGs.add(MovedImage(
              onDoubleTap: onDoubleTappedImage,
              index: index,
              picScle: picScle,
              areaPos: mArea,
              midScaledPos: midscalepo,
              position: positionT,
              imageFile: image,
              imageScle: imagescle,
            ));
          });
          break;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scrolfld,
        backgroundColor: BlackLight_t,
        body: Stack(
          children: <Widget>[
            Positioned(
                top: mArea.dy,
                left: mArea.dx,
                child: Transform.scale(
                  scale: picScle,
                  child: GestureDetector(
                    onScaleUpdate: (ScaleUpdateDetails scaledet) {
                      if (once) {
                        mPosstart = scaledet.localFocalPoint * picScle;
                        once = false;
                      }
                      setState(() {
                        midscalepo = Offset((((picW * picScle) - picW) / 2),
                            (((picH * picScle) - picH) / 2));
                        mArea = scaledet.focalPoint - mPosstart + midscalepo;
                        picScle = picScleEnd * scaledet.scale;
                      });
                    },
                    onScaleEnd: (d) {
                      picScleEnd = picScle;
                      once = true;
                    },
                    child: RepaintBoundary(
                      key: previewContainer,
                      child: Container(
                          height: picH,
                          width: picW,
                          color: bacgroundcolor,
                          child: Stack(
                            children: aDdingWidGs,
                          )),
                    ),
                  ),
                )),
            Positioned(
              right: layertapmargin,
              top: 0,
              bottom: 0,
              child: Container(
                width: 200,
                color: BlackLight.withAlpha(180),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            _layerOpenner();
                          },
                          child: Icon(
                            Icons.clear,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Katmanlar',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: aDdingWidDs.length,
                        itemBuilder: (BuildContext context, int index) {
                          EditoraddData mAddData = aDdingWidDs[index];
                          return Container(
                            padding: EdgeInsets.all(10),
                            width: 180,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: 115,
                                  child: Text(
                                    mAddData.type==0?'BackImage':mAddData.type==1?mAddData.mText:mAddData.imagePath,
                                    style: TextStyle(color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      aDdingWidDs.removeAt(index);
                                      aDdingWidGs.removeAt(index);
                                    });
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          );
                        })
                  ],
                ),
              ),
            ),
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: Container(
                width: 360,
                decoration: BoxDecoration(
                    color: BlackLight.withAlpha(180),
                    border: Border.all(color: Colors.black)),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      MyWidgets().mEditorButton('Yazı Ekle', Icons.text_fields,
                          () {
                        setState(() {
                          focussedIndx = aDdingWidDs.length;
                        });
                      }, Primaryclor, 60, 60, 30, 10, EdgeInsets.all(2)),
                      MyWidgets().mEditorButton('Resim Ekle', Icons.image, () {
                        _imagePicker();
                      }, Primaryclor, 60, 60, 30, 10, EdgeInsets.all(2)),
                      MyWidgets()
                          .mEditorButton('Ekranı Ortala', Icons.fullscreen, () {
                        setState(() {
                          picScle = 1;
                          picScleEnd = 1;
                          mArea = Offset((screenW / 2) - (picW / 2),
                              (screenH / 2) - (picH / 2));
                        });
                      }, Primaryclor, 60, 60, 30, 10, EdgeInsets.all(2)),
                      MyWidgets().mEditorButton('Katmanlar', Icons.layers, () {
                        _layerOpenner();
                      }, Primaryclor, 60, 60, 30, 10, EdgeInsets.all(2)),
                      MyWidgets().mEditorButton('Kaydet', Icons.save, () {
                        widget.isCreated?takeScreenShotCreate():takeScreenShotunCreate();
                      }, Primaryclor, 60, 60, 30, 10, EdgeInsets.all(2)),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              bottom: 0,
              child: Visibility(
                  visible: focussedIndx != null && focussedImage == null,
                  child: Container(
                    color: Colors.black87.withAlpha(180),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                setState(() {
                                  cntCreate.clear();
                                  focussedIndx = null;
                                  focussedPos = null;
                                });
                              },
                              child: Icon(
                                Icons.clear,
                                color: Colors.white,
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    if (focussedPos != null) {
                                      _changer(
                                          focussedIndx,
                                          cntCreate.text,
                                          slectedcolor,
                                          selectedsize,
                                          selectedwidh,
                                          focussedPos);
                                    } else {
                                      _aDder(
                                          0,
                                          cntCreate.text,
                                          slectedcolor,
                                          selectedsize,
                                          selectedwidh,
                                          Offset.zero,
                                          null,
                                          null);
                                    }
                                    cntCreate.clear();
                                    focussedIndx = null;
                                    focussedPos = null;
                                  });
                                },
                                child: Icon(Icons.check, color: Colors.white)),
                          ],
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        ),
                        Container(
                            padding: EdgeInsets.only(
                                top: 5, bottom: 5, left: 15, right: 15),
                            color: Colors.white,
                            child: CostomTextField(
                              controller: cntCreate,
                              widh: 250,
                              textcolor: slectedcolor,
                              textsize: selectedsize,
                              fontWeight: selectedwidh,
                              fontFamily: slectedFontFamily,
                              border: true,
                            )),
                        Container(
                          color: BlackLight_t,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: <Widget>[
                                MyWidgets().mEditorButton(
                                    'Renk Seç', Icons.color_lens, () {
                                  _colorPicker();
                                }, Primaryclor, 60, 60, 30, 10,
                                    EdgeInsets.all(2)),
                                MyWidgets().mEditorButton(
                                    'Yazı Boyutu', Icons.format_size, () {
                                  _textSizePicker(cntCreate.text);
                                }, Primaryclor, 60, 60, 30, 10,
                                    EdgeInsets.all(2)),
                                MyWidgets().mEditorButton(
                                    'Yazı tipi', Icons.font_download, () {
                                  _fontPicker();
                                }, Primaryclor, 60, 60, 30, 10,
                                    EdgeInsets.all(2)),
                              ],
                            ),
                          ),
                        )
                      ],
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    ),
                  )),
            ),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              bottom: 0,
              child: Visibility(
                  visible: focussedImage != null && focussedIndx != null,
                  child: Container(
                    color: Colors.black87.withAlpha(180),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                setState(() {
                                  cntCreate.clear();
                                  focussedIndx = null;
                                  focussedPos = null;
                                  focussedImage = null;
                                  focussedScle = 1;
                                });
                              },
                              child: Icon(
                                Icons.clear,
                                color: Colors.white,
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    if (focussedPos != null) {
                                      _changerI(focussedIndx, focussedPos,
                                          focussedImage, focussedScle);
                                    } else {
                                      _aDder(
                                          1,
                                          p.basename(focussedImage.path),
                                          null,
                                          null,
                                          null,
                                          Offset.zero,
                                          focussedImage,
                                          focussedScle);
                                    }
                                    cntCreate.clear();
                                    focussedIndx = null;
                                    focussedImage = null;
                                    focussedPos = null;
                                    focussedScle = 1;
                                  });
                                },
                                child: Icon(Icons.check, color: Colors.white)),
                          ],
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        ),
                        Container(
                            padding: EdgeInsets.only(
                                top: 5, bottom: 5, left: 15, right: 15),
                            color: Colors.white,
                            child: focussedImage != null
                                ? Image.file(
                                    focussedImage,
                                    width: 150,
                                    height: 150,
                                  )
                                : null),
                        Container(
                          color: BlackLight_t,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: <Widget>[
                                MyWidgets().mEditorButton(
                                    'Kırp - Döndür', Icons.crop, () {
                                  _cropper();
                                }, Primaryclor, 60, 80, 30, 10,
                                    EdgeInsets.all(2)),
                                MyWidgets().mEditorButton('Resim Boyutu',
                                    Icons.photo_size_select_large, () {
                                  _imageSizePicker(focussedScle);
                                }, Primaryclor, 60, 80, 30, 10,
                                    EdgeInsets.all(2)),
                              ],
                            ),
                          ),
                        )
                      ],
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    ),
                  )),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,
              child: Visibility(
                visible: loading,
                child: Container(
                  color: BlackLight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Image.asset(
                        'assets/matbaacim_t.png',
                        height: 50,
                      ),
                      Container(
                        height: 25,
                      ),
                      CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
