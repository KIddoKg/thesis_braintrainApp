class Achievement {
  String title;
  String subTitle;
  int percent;
  int maxCount;
  String levels;
  String nameImg;
  List<AchievementDate> achievementDates; // Danh sách các ngày đạt được thành tựu

  Achievement({
    this.title = '',
    this.subTitle = '',
    this.percent = 0,
    this.maxCount = 0,
    this.levels = '',
    this.nameImg = '',
    this.achievementDates = const [], // Khởi tạo danh sách rỗng mặc định
  });

  Achievement.fromJson(Map<String, dynamic> json)
      : title = json['title'] ?? "",
        subTitle = json['subTitle'] ?? '',
        percent = json['percent'] ?? 0,
        maxCount = json['maxCount'] ?? 0,
        nameImg = json['nameImg'] ?? '',
        levels = json['levels'] ?? '',
        achievementDates = (json['achievementDates'] as List<dynamic> ?? [])
            .map((dateJson) => AchievementDate.fromJson(dateJson))
            .toList(); // Chuyển đổi danh sách ngày đạt được thành tựu từ JSON

  Map<String, dynamic> toJson() => {
    'title': title,
    'subTitle': subTitle,
    'percent': percent,
    'maxCount': maxCount,
    'nameImg': nameImg,
    'levels': levels,
    'achievementDates':
    achievementDates.map((date) => date.toJson()).toList(), // Chuyển đổi danh sách thành JSON
  };
}

class AchievementDate {
  String title;
  String subTitle;
  String date;
  String levels;
  String nameImg;

  AchievementDate({
    this.date = '',
    this.title = '',
    this.subTitle = '',
    this.levels = '',
    this.nameImg = '',
  });

  AchievementDate.fromJson(Map<String, dynamic> json)
      : date = json['date'] ?? "",
        title = json['title'] ?? "", subTitle = json['subTitle'] ?? "",
        levels = json['levels'] ?? "",
        nameImg = json['nameImg'] ?? "";

  Map<String, dynamic> toJson() => {
    'date': date,
    'title': title,
    'subTitle': subTitle,
    'levels': levels,
    'nameImg': nameImg,
  };
  @override
  String toString() {
    return 'AchievementDate(date: $date, title: $title, subTitle: $subTitle, levels: $levels, nameImg: $nameImg)';
  }
}
