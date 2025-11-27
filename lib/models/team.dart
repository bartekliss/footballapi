// models/team.dart
class Team {
  final int id;
  final String name;
  final String logo;
  final int founded;
  final String venueName;
  final String city;

  Team({required this.id, required this.name, required this.logo, required this.founded, required this.venueName, required this.city});

  // Fabryka do tworzenia obiektu z JSON (API)
  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['team']['id'],
      name: json['team']['name'],
      logo: json['team']['logo'],
      founded: json['team']['founded'] ?? 0,
      venueName: json['venue']['name'],
      city: json['venue']['city'],
    );
  }

// Tu należałoby dodać metody toMap/fromMap dla Hive (lokalna baza)
}