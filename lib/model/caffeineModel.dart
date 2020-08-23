class CaffeineModel {
  int _id;
  int caffeineAmount;
  String dateOfEntry;

  CaffeineModel({this.caffeineAmount, this.dateOfEntry});

  int get id => _id;
  int get caffeine => caffeineAmount;
  String get date => dateOfEntry;

  setCaffeine(int caffeine, String date) {
    this.caffeineAmount = caffeine;
    this.dateOfEntry = date;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = _id;
    }
    map['caffeine'] = caffeineAmount;
    map['date'] = dateOfEntry;

    return map;
  }

  CaffeineModel.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this.caffeineAmount = map['caffeine'];
    this.dateOfEntry = map['date'];
  }

  factory CaffeineModel.fromJson(Map<String, dynamic> json) {
    return CaffeineModel(
      caffeineAmount: json['caffeineAmount'],
      dateOfEntry: json['dateOfEntry'],
    );
  }
}
