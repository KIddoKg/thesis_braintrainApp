class DataRanking {
  final double myPerformance;
  final List<UserRanking> userRankings;

  DataRanking({
    required this.myPerformance,
    required this.userRankings,
  });

  factory DataRanking.fromJson(Map<String, dynamic> json) {
    var userRankingsList = json['userRankings'] as List<dynamic>;
    List<UserRanking> userRankings =
    userRankingsList.map((e) => UserRanking.fromJson(e)).toList();

    return DataRanking(
      myPerformance: json['myPerformance'] ?? 0,
      userRankings: userRankings,
    );
  }

}

class UserRanking {
  final String userId;
  final String userName;
  final int score;

  UserRanking({
    required this.userId,
    required this.userName,
    required this.score,
  });

  factory UserRanking.fromJson(Map<String, dynamic> json) {
    return UserRanking(
      userId: json['userId'],
      userName: json['userName'],
      score: json['score'],
    );
  }
  @override
  String toString() {
    return 'ExpenseData { userId: $userId, score: $score }';
  }
}