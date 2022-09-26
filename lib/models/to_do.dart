class Todo {
  String title;
  DateTime dateCriation;
  DateTime dateconclusion;
  DateTime dateUpdate;
  bool done;

  Todo({
    required this.title,
    required this.dateCriation,
    required this.dateconclusion,
    required this.dateUpdate,
    required this.done,
  });

  Todo.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        dateCriation = DateTime.parse(json['dateCriation']),
        dateconclusion = DateTime.parse(json['dateconclusion']),
        dateUpdate = DateTime.parse(json['dateUpdate']),
        done = json['done'];

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'dateCriation': dateCriation.toIso8601String(),
      'dateconclusion': dateconclusion.toIso8601String(),
      'dateUpdate': dateUpdate.toIso8601String(),
      'done': done,
    };
  }
}
