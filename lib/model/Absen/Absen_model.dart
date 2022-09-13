class AbsenModel{
  int? id;
  String? lat;
  String? lng;
  int? radius;
  String? rect;

  AbsenModel(
      {required this.id,
        required this.lat,
        required this.lng,
        required this.radius,
        required this.rect});

  factory AbsenModel.fromJson(Map<String, dynamic> json) {
    return AbsenModel(
        id: json['id'],
        lat: json['lat'],
        lng: json['lng'],
        radius: json['radius'],
        rect: json['rect']);
  }
}