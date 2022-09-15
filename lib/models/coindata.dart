class Coins {
  Coins({
    required this.success,
    required this.terms,
    required this.privacy,
    required this.timestamp,
    required this.target,
    required this.rates,
  });

  bool success;
  String terms;
  String privacy;
  int timestamp;
  String target;
  Map<String, double> rates;

  factory Coins.fromJson(Map<String, dynamic> json) => Coins(
        success: json["success"],
        terms: json["terms"],
        privacy: json["privacy"],
        timestamp: json["timestamp"],
        target: json["target"],
        rates: Map.from(json["rates"])
            .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "terms": terms,
        "privacy": privacy,
        "timestamp": timestamp,
        "target": target,
        "rates": Map.from(rates).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}
