class ClassroomDetailModel{
  int? id;
  int? pertemuan_ke;
  String? tanggal_tayang;
  String? url_file_modul;
  String? bahan_ajar;
  String? bahan_tayang;
  String? url_video_bahan;
  String? nama_guru_smart;
  String? nama_pelajaran;
  String? kode_tingkat;
  String? nama_tahun_akademik;
  String? judul;
  String? deskripsi;

  ClassroomDetailModel(
      {required this.id,
        required this.pertemuan_ke,
        required this.tanggal_tayang,
        required this.url_file_modul,
        required this.bahan_ajar,
        required this.bahan_tayang,
        required this.url_video_bahan,
        required this.nama_guru_smart,
        required this.nama_pelajaran,
        required this.kode_tingkat,
        required this.nama_tahun_akademik,
        required this.judul,
        required this.deskripsi});

  factory ClassroomDetailModel.fromJson(Map<String, dynamic> json) {
    return ClassroomDetailModel(
        id: json['id'],
        pertemuan_ke: json['pertemuan_ke'],
        tanggal_tayang: json['tanggal_tayang'],
        url_file_modul: json['url_file_modul'],
        bahan_ajar: json['bahan_ajar'],
        bahan_tayang: json['bahan_tayang'],
        url_video_bahan: json['url_video_bahan'],
        nama_guru_smart: json['nama_guru_smart'],
        nama_pelajaran: json['nama_pelajaran'],
        kode_tingkat: json['kode_tingkat'],
        nama_tahun_akademik: json['nama_tahun_akademik'],
        judul: json['judul'],
        deskripsi: json['deskripsi']);
  }
}