
class EditoraddData{
  int type;
  String mText;
  int mColor;
  double mFontSize;
  double mImageSclae;
  String mFontStyle;
  String imagePath;
  int mFontweight;
  double positionx;
  double positiony;
  EditoraddData.text(this.type,this.positionx,this.positiony,this.mText,this.mColor,this.mFontSize,this.mFontStyle,this.mFontweight);
  EditoraddData.image(this.type,this.positionx,this.positiony,this.mImageSclae,this.imagePath);
  EditoraddData.back(this.type);
  tojson(){
    return{
      'type':type,
      'mText':mText,
      'mColor':mColor,
      'mFontSize':mFontSize,
      'mImageSclae':mImageSclae,
      'mFontStyle':mFontStyle,
      'mFontweight':mFontweight,
      'imagePath':imagePath,
      'x':positionx,
      'y':positiony,
    };
  }
}
class SepetBekleyenData{
  String sRes;
  String urunI;
  List<EditoraddData>screenResources;
  SepetBekleyenData(this.urunI,this.sRes,this.screenResources);
}
class SepetData{
  List<String> soru;
  List<String> cevap;
  String uruncode;
  String adet;
  SepetData(this.cevap,this.soru,this.uruncode,this.adet);
}