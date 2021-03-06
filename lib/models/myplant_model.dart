import 'dart:convert';

List<MyPlant> myPlantFromJson(String str) =>
    List<MyPlant>.from(json.decode(str).map((x) => MyPlant.fromJson(x)));

class MyPlant {
  MyPlant({
    this.id,
    this.idPlant,
    this.name,
    this.plantName,
    this.progress,
    this.picture,
    this.finishTask,
    this.totalTask,
    this.isDone,
  });

  String id;
  String idPlant;
  String name;
  String plantName;
  String progress;

  bool isDone;
  String picture;
  int finishTask;
  int totalTask;

  factory MyPlant.fromJson(Map<String, dynamic> json) => MyPlant(
        id: json["id"],
        idPlant: json["id_plant"],
        name: json["name"],
        plantName: json["plant_name"],
        progress: json["progress"].toString(),
        isDone: json["is_done"] is bool
            ? json["is_done"]
            : json["is_done"].toString() == '1'
                ? true
                : false,
        picture: json["picture"],
        finishTask: json["finish_task"],
        totalTask: json["total_task"],
      );
}

class ListTask {
  ListTask({
    this.task,
    this.ischeck,
  });

  String task;
  bool ischeck;

  factory ListTask.fromJson(Map<String, dynamic> json) => ListTask(
        task: json["task"],
        ischeck: json["ischeck"],
      );
}
