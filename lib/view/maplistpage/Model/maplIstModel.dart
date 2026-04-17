class MapListModel {
  List<Maps>? maps;
  bool? success;

  MapListModel({this.maps, this.success});

  MapListModel.fromJson(Map<String, dynamic> json) {
    if (json['maps'] != null) {
      maps = <Maps>[];
      json['maps'].forEach((v) {
        maps!.add(new Maps.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.maps != null) {
      data['maps'] = this.maps!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    return data;
  }
}

class Maps {
  int? id;
  String? mapName;

  Maps({this.id, this.mapName});

  Maps.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mapName = json['map_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['map_name'] = this.mapName;
    return data;
  }
}