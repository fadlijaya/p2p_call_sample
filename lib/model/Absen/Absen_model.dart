class AbsenModel{
  String? lat;
  String? lng;
  int? radius;

  AbsenModel({
        required this.lat,
        required this.lng,
        required this.radius});

  factory AbsenModel.fromJson(Map<String, dynamic> json) {
    return AbsenModel(
        lat: json['lat'],
        lng: json['lng'],
        radius: json['radius'],);
  }
}