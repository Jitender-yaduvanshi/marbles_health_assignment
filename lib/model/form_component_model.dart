import 'dart:convert';

class FormComponentData {
  String label;
  String infoText;
  bool isRequired;
  bool isReadOnly;
  bool isHidden;

  FormComponentData({
    required this.label,
    required this.infoText,
    required this.isRequired,
    required this.isReadOnly,
    required this.isHidden,
  });

  factory FormComponentData.fromJson(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    return FormComponentData(
      label: json['label'],
      infoText: json['infoText'],
      isRequired: json['isRequired'],
      isReadOnly: json['isReadOnly'],
      isHidden: json['isHidden'],
    );
  }

  String toJson() {
    Map<String, dynamic> json = {
      'label': label,
      'infoText': infoText,
      'isRequired': isRequired,
      'isReadOnly': isReadOnly,
      'isHidden': isHidden,
    };
    return jsonEncode(json);
  }
}
