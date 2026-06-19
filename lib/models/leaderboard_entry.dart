class LeaderboardEntry {
  final String playerName;
  final int wins;
  final int gamesPlayed;
  final Duration bestTime;
  final DateTime lastPlayed;

  LeaderboardEntry({
    required this.playerName,
    required this.wins,
    required this.gamesPlayed,
    required this.bestTime,
    required this.lastPlayed,
  });

  double get winRate => gamesPlayed > 0 ? wins / gamesPlayed : 0.0;

  Map<String, dynamic> toJson() {
    return {
      'playerName': playerName,
      'wins': wins,
      'gamesPlayed': gamesPlayed,
      'bestTime': bestTime.inSeconds,
      'lastPlayed': lastPlayed.toIso8601String(),
    };
  }

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      playerName: json['playerName'],
      wins: json['wins'],
      gamesPlayed: json['gamesPlayed'],
      bestTime: Duration(seconds: json['bestTime']),
      lastPlayed: DateTime.parse(json['lastPlayed']),
    );
  }
}
