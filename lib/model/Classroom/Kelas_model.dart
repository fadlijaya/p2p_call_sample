class KelasModel {
  int? id_kelas;
  String? nama_kelas;

  KelasModel(
      {required this.id_kelas,
        required this.nama_kelas});

  factory KelasModel.fromJson(Map<String, dynamic> json) {
    return KelasModel(
        id_kelas: json['id_kelas'],
        nama_kelas: json['nama_kelas']);
  }
}
