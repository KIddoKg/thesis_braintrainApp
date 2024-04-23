

class Objective {
  String id;
  String objectiveType;
  int level;
  double quantityRequired;
  String title;
  String description;
  int achievedDate;
  bool achieved;
  String imageTag;

  Objective({
    required this.id,
    required this.objectiveType,
    required this.level,
    required this.quantityRequired,
    required this.title,
    required this.description,
    required this.achievedDate,
    required this.achieved,
    required this.imageTag,
  });

  factory Objective.fromJson(Map<String, dynamic> json) {
    String imageTag = "";

    switch (json['objectiveType']) {
      case 'LANGUAGE_TRAINING':
        imageTag = '6';
        break;
      case 'TRAINING':
        imageTag = '1';
        break;
      case 'ATTENTION_TRAINING':
        imageTag = '5';
        break;
      case 'TRAINING_TIME':
        imageTag = '3';
        break;
      case 'MATH_TRAINING':
        imageTag = '7';
        break;
      case 'MEMORY_TRAINING':
        imageTag = '4';
        break;
      case 'CONSECUTIVE_TRAINING':
        imageTag = '2';
        break;
      default:
        break;
    }

    return Objective(
      id: json['id'],
      objectiveType: json['objectiveType'],
      level: json['level'],
      quantityRequired: json['quantityRequired'].toDouble(),
      title: json['title'],
      description: json['description'],
      achievedDate: json['achievedDate'] ?? 0,
      achieved: json['achieved'],
      imageTag: imageTag,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'objectiveType': objectiveType,
      'level': level,
      'quantityRequired': quantityRequired,
      'title': title,
      'description': description,
      'achievedDate': achievedDate,
      'achieved': achieved,
      'imageTag': imageTag,
    };
  }

  @override
  String toString() {
    return 'Objective{id: $id, objectiveType: $objectiveType, level: $level, quantityRequired: $quantityRequired, title: $title, description: $description, achievedDate: $achievedDate, achieved: $achieved, imageTag: $imageTag}';
  }
}
