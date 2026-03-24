class EarningsSummary {
  final int totalEarnings;
  final int platformFees;
  final int netEarnings;
  final int jobCount;
  final String period;

  EarningsSummary({required this.totalEarnings, required this.platformFees, required this.netEarnings, required this.jobCount, required this.period});

  factory EarningsSummary.fromJson(Map<String, dynamic> json) => EarningsSummary(
    totalEarnings: json['totalEarnings'] ?? 0, platformFees: json['platformFees'] ?? 0,
    netEarnings: json['netEarnings'] ?? 0, jobCount: json['jobCount'] ?? 0,
    period: json['period'] ?? 'daily',
  );
}

class DailyEarning {
  final String date;
  final int jobCount;
  final int grossEarnings;
  final int platformFees;
  final int netEarnings;

  DailyEarning({required this.date, required this.jobCount, required this.grossEarnings, required this.platformFees, required this.netEarnings});

  factory DailyEarning.fromJson(Map<String, dynamic> json) => DailyEarning(
    date: json['date'] ?? '', jobCount: json['jobCount'] ?? 0,
    grossEarnings: json['grossEarnings'] ?? 0, platformFees: json['platformFees'] ?? 0,
    netEarnings: json['netEarnings'] ?? 0,
  );
}
