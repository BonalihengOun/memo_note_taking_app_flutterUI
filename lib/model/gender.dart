class GenderModel {
  final String value;

  GenderModel(this.value);

  factory GenderModel.fromJson(Map<String, dynamic> json) {
    return GenderModel(json['value']);
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
    };
  }
}