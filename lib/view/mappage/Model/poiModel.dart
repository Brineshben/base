class PoiModel {
  List<Pois>? pois;
  bool? success;

  PoiModel({this.pois, this.success});

  PoiModel.fromJson(Map<String, dynamic> json) {
    if (json['pois'] != null) {
      pois = <Pois>[];
      json['pois'].forEach((v) {
        pois!.add(new Pois.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pois != null) {
      data['pois'] = this.pois!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    return data;
  }
}

class Pois {
  String? createdAt;
  int? id;
  String? name;
  String? updatedAt;
  double? x;
  double? y;
  double? yawDeg;

  Pois(
      {this.createdAt,
        this.id,
        this.name,
        this.updatedAt,
        this.x,
        this.y,
        this.yawDeg});

  Pois.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    id = json['id'];
    name = json['name'];
    updatedAt = json['updated_at'];
    x = json['x'];
    y = json['y'];
    yawDeg = json['yaw_deg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['name'] = this.name;
    data['updated_at'] = this.updatedAt;
    data['x'] = this.x;
    data['y'] = this.y;
    data['yaw_deg'] = this.yawDeg;
    return data;
  }
}