class battery {
  double? ageS;
  BmsData? bmsData;
  String? raw;
  bool? success;

  battery({this.ageS, this.bmsData, this.raw, this.success});

  battery.fromJson(Map<String, dynamic> json) {
    ageS = json['age_s'];
    bmsData = json['bms_data'] != null
        ? new BmsData.fromJson(json['bms_data'])
        : null;
    raw = json['raw'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age_s'] = this.ageS;
    if (this.bmsData != null) {
      data['bms_data'] = this.bmsData!.toJson();
    }
    data['raw'] = this.raw;
    data['success'] = this.success;
    return data;
  }
}

class BmsData {
  double? current;
  int? cycleCount;
  double? fullCapacity;
  double? remainingCapacity;
  double? soc;
  double? voltage;

  BmsData(
      {this.current,
        this.cycleCount,
        this.fullCapacity,
        this.remainingCapacity,
        this.soc,
        this.voltage});

  BmsData.fromJson(Map<String, dynamic> json) {
    current = json['current'];
    cycleCount = json['cycle_count'];
    fullCapacity = json['full_capacity'];
    remainingCapacity = json['remaining_capacity'];
    soc = json['soc'];
    voltage = json['voltage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current'] = this.current;
    data['cycle_count'] = this.cycleCount;
    data['full_capacity'] = this.fullCapacity;
    data['remaining_capacity'] = this.remainingCapacity;
    data['soc'] = this.soc;
    data['voltage'] = this.voltage;
    return data;
  }
}