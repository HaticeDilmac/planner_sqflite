//Data Model
class ToDoModel {
  //Model sınıfımızın değişkenlerini olşuturduk.
  final int? id;
  final String? title;
  final String? desc;
  final String? deteandtime;

  ToDoModel(
      {this.id,
      this.title,
      this.desc,
      this.deteandtime}); //constructarımızı oluşturduk.

  ToDoModel.fromMap(Map<String, dynamic> value) //map yapısı
      : id = value['id'],
        title = value['title'],
        desc = value['desc'],
        deteandtime = value['dateandtime'];
  Map<String, Object?> toMap() {
    return {
      "id": id,
      "title": title,
      "desc": desc,
      "dateandtime": deteandtime,
    };
  }
}
