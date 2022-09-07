class AbsenModel{
  int? id;
  String? lat;
  String? lng;
  int? radius;

  AbsenModel(
      {required this.id,
        required this.lat,
        required this.lng,
        required this.radius});

  factory AbsenModel.fromJson(Map<String, dynamic> json) {
    return AbsenModel(
        id: json['id'],
        lat: json['lat'],
        lng: json['lng'],
        radius: json['radius']);
  }
}