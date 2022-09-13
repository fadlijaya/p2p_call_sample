class ClassroomPertemuanModel{
  int? id;
  int? pertemuan_ke;
  String? judul;
  String? tanggal_tayang;

  ClassroomPertemuanModel(
      {required this.id,
        required this.pertemuan_ke,
        required this.judul,
        required this.tanggal_tayang});

  factory ClassroomPertemuanModel.fromJson(Map<String, dynamic> json) {
    return ClassroomPertemuanModel(
        id: json['id'],
        pertemuan_ke: json['pertemuan_ke'],
        judul: json['judul'],
        tanggal_tayang: json['tanggal_tayang']);
  }
}