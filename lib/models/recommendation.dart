class Recommendation {
  final String text;
  final String? label;
  final String? icon;
  final String? labelColor;

  Recommendation({
    required this.text,
    this.label,
    this.icon,
    this.labelColor,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      text: json['text'],
      label: json['label'],
      icon: json['icon'],
      labelColor: json['labelColor'],
    );
  }
}
