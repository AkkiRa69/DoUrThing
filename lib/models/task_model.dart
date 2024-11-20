class TaskModel {
  String? id;
  String? title;
  String? description;
  bool? isCompleted;
  String? priority;
  String? dueDate;
  String? createdAt;

  TaskModel(
      {this.id,
      this.title,
      this.description,
      this.isCompleted,
      this.priority,
      this.dueDate,
      this.createdAt});

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    isCompleted = json['isCompleted'];
    priority = json['priority'];
    dueDate = json['dueDate'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['isCompleted'] = isCompleted;
    data['priority'] = priority;
    data['dueDate'] = dueDate;
    data['createdAt'] = createdAt;
    return data;
  }
}
