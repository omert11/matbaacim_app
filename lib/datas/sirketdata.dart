class Sirketdata{
  bool uAktif;
  String uRes;
  String uIsim;
  String uKonum;
  String uEposta;
  String uTel;
  String uWeb;
  String uUnvanmeslek;
  bool uOdemegecerlimi;
  double uSirketpuan;
Sirketdata(this.uAktif,this.uRes,this.uIsim,this.uKonum,this.uEposta,this.uTel,this.uWeb,this.uUnvanmeslek,this.uOdemegecerlimi,this.uSirketpuan);
  toJson(){
  return{
    'u_aktif':uAktif,
    'u_res':uRes,
    'u_isim':uIsim,
    'u_konum':uKonum,
    'u_eposta':uEposta,
    'u_tel':uTel,
    'u_web':uWeb,
    'u_unvanmeslek':uUnvanmeslek,
    'u_odemegecerlimi':uOdemegecerlimi,
    'u_sirketpuan':uSirketpuan,
  };
  }
}