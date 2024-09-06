class Task {
  int? id;
  String? title;
  String? description;
  int? isCompleted;
  String? date;
  String? startTime;
  int? color;
  String? repeat;

  // Constructor
  Task(this.title, this.description, this.isCompleted, this.date,
      this.startTime, this.color, this.repeat);

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    isCompleted = json['isCompleted'];
    date = json['date'];
    startTime = json['startTime'];
    color = json['color'];
    repeat = json['repeat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['isCompleted'] = this.isCompleted;
    data['date'] = this.date;
    data['startTime'] = this.startTime;
    data['color'] = this.color;
    data['repeat'] = this.repeat;

    return data;
  }
}
