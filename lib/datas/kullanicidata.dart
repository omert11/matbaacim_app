
class Kullanicidata{
  String kRes;
  String kIsim;
  String kEposta;
  String kTel;
  Map<String, String> kAdres;
  String kUnvanmeslek;
  int kDogumtarihi;
  int kAbonelikTipi;
  Kullanicidata(this.kRes,this.kIsim,this.kEposta,this.kTel,this.kAdres,this.kUnvanmeslek,this.kDogumtarihi,this.kAbonelikTipi);
  toJson(){
    return{
      'k_Res':kRes,
      'k_Isim':kIsim,
      'k_Eposta':kEposta,
      'k_Tel':kTel,
      'k_Adres':kAdres,
      'k_Unvanmeslek':kUnvanmeslek,
      'k_Dogumtarihi':kDogumtarihi,
      'k_AbonelikTipi':kAbonelikTipi,
    };
  }
}
class Adresdata{
  String il;
  String ilce;
  String mahalle;
  String adres1;
  String adres2;
 Adresdata(this.il,this.ilce,this.mahalle,this.adres1,this.adres2);
 toJson(){
   return{
     'il':il,
     'ilce':ilce,
     'mahalle':mahalle,
     'adres1':adres1,
     'adres2':adres2,
   };
 }
}
