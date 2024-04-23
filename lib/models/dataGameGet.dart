class GameData {
  String id;
  String gameType;
  String gameName;
  int score;
  int playTime;
  int maxLevel;
  int? levelGame;
  int? newPicOneResult;
  int? newPicTwoResult;
  int? noOfFishCaught;
  bool boatStatus;
  String? wordList;
  int createdDate;

  GameData({
    required this.id,
    required this.gameType,
    required this.gameName,
    required this.score,
    required this.playTime,
    required this.maxLevel,
    this.levelGame,
    this.newPicOneResult,
    this.newPicTwoResult,
    this.noOfFishCaught,
    required this.boatStatus,
    this.wordList,
    required this.createdDate,
  });

  factory GameData.fromJson(Map<String, dynamic> json) {
    return GameData(
      id: json['id'] ?? "",
      gameType: json['gameType'] ??"",
      gameName: json['gameName']??"",
      score: json['score']??0,
      playTime: json['playTime']??0,
      maxLevel: json['level']??0,
      levelGame: json['level']??1,
      newPicOneResult: json['newPicOneResult']??0,
      newPicTwoResult: json['newPicTwoResult']??0,
      noOfFishCaught: json['noOfFishCaught']??0,
      boatStatus: json['boatStatus']??false,
      wordList: json['wordList'] ?? null,
      createdDate: json['createdDate']??0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gameType': gameType,
      'gameName': gameName,
      'score': score,
      'playTime': playTime,
      'maxLevel': maxLevel,
      'maxLevel': maxLevel,
      'newPicOneResult': newPicOneResult,
      'newPicTwoResult': newPicTwoResult,
      'noOfFishCaught': noOfFishCaught,
      'boatStatus': boatStatus,
      'wordList': wordList,
      'createdDate': createdDate,
    };
  }
}
