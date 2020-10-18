class Urundata{
  String urunres;
  String sampleres;
  String urunisim;
  String baslik1;
  String baslik2;
  double deger;
  String degerlendirensay;
  String ulasmasur;
  String ureticiuid;
  String ureticires;
  String ureticiisim;
  int oncelik;
  String bulundugukatagori;
  int renk;
  int tasarim;
  int kargo;
  double fiyat;
  Urundata.halfed(this.urunres,this.urunisim,this.baslik1,this.baslik2,this.deger,this.degerlendirensay,this.ulasmasur,this.oncelik,this.ureticiuid,this.ureticiisim,this.ureticires,this.bulundugukatagori,this.fiyat);
  Urundata.finaly(this.urunres,this.urunisim,this.baslik1,this.baslik2,this.deger,this.degerlendirensay,this.ulasmasur,this.oncelik,this.ureticiuid,this.ureticiisim,this.ureticires,this.bulundugukatagori,this.fiyat,this.kargo,this.renk,this.tasarim,this.sampleres);
  toJson(){
    return{
      'urunres':urunres,
      'urunisim':urunisim,
      'baslik1':baslik1,
      'baslik2':baslik2,
      'deger':deger,
      'degerlendirensay':degerlendirensay,
      'ulasmasur':ulasmasur,
      'ureticiuid':ureticiuid,
      'ureticiisim':ureticiisim,
      'ureticires':ureticires,
      'oncelik':oncelik,
      'bulundugukatagori':bulundugukatagori,
      'renk':renk,
      'tasarim':tasarim,
      'kargo':kargo,
      'fiyat':fiyat,
      'sampleres':sampleres,
    };
  }
}