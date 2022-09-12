class MatapelajaranModel {
  String? mapel;
  String? teacher;

  MatapelajaranModel(
      {required this.mapel,
        required this.teacher});

  factory MatapelajaranModel.fromJson(Map<String, dynamic> json) {
    return MatapelajaranModel(
        mapel: json['mapel'],
        teacher: json['teacher']);
  }
}
