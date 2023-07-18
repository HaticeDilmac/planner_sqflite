// ignore_for_file: avoid_print, must_be_immutable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planner_sqflite/planner/db_handler.dart';
import 'package:planner_sqflite/planner/model.dart';
import 'package:planner_sqflite/planner/todo.dart';

class AddUpdateTask extends StatefulWidget {
  int? todoId;
  String? todoTitle;
  String? todoDesc;
  String? todoDT;
  bool? update;
  AddUpdateTask(
      {super.key,
      this.todoId,
      this.todoTitle,
      this.todoDesc,
      this.todoDT,
      this.update});

  @override
  State<AddUpdateTask> createState() => _AddUpdateTaskState();
}

class _AddUpdateTaskState extends State<AddUpdateTask> {
  DBHelper? dbHelper;

  late Future<List<ToDoModel>> datalist;
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() {
    datalist = dbHelper!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: widget.todoTitle);
    final descController = TextEditingController(text: widget.todoDesc);
    String appTitle;
    if (widget.update == true) {
      appTitle = "Planlarımı Güncelle";
    } else {
      appTitle = "Plan Ekle";
    }
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(appTitle,
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "AmaticSC",
                  fontSize: 30,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.center),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Todo())))),
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: titleController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Not Başlığı'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Boş Geçilemez';
                      }
                      return null;
                    },
                  ),
                ),
              ]),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _formKey2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 5,
                  controller: descController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Not Açıklaması'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Boş Geçilemez';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Material(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          //veritabanına ekle
                          if (_formKey.currentState!.validate() &&
                              _formKey2.currentState!.validate()) {
                            if (widget.update == true) {
                              //eğer güncelleme işlemi varsa
                              dbHelper!.update(ToDoModel(
                                id: widget.todoId,
                                title: titleController.text,
                                deteandtime: widget.todoDT,
                                desc: descController.text,
                              ));
                            } else {
                              dbHelper!.insert(
                                //eğer ekleme işlemi varsa
                                ToDoModel(
                                    title: titleController.text,
                                    desc: descController.text,
                                    deteandtime: DateFormat('yMd')
                                        .add_jm()
                                        .format(DateTime.now())
                                        .toString()),
                              );
                            }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Todo()));
                            // Navigator.pushNamed(
                            //     context, '/todo'); //todo sayfasına git
                            //sayfaya gittikten sonra textfieldlardakileri temizle
                            titleController.clear();
                            descController.clear();
                            if (kDebugMode) {
                              print("veri silindi");
                            }
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          height: 55,
                          width: 120,
                          decoration: const BoxDecoration(),
                          child: const Text("Kaydet"),
                        ),
                      ),
                    ),
                    Material(
                      //Clear Button
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            //Clear function
                            titleController.clear();
                            descController.clear();
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          height: 55,
                          width: 120,
                          decoration: const BoxDecoration(),
                          child: const Text("Sil"),
                        ),
                      ),
                    )
                  ]),
            )
          ],
        )),
      ),
    );
  }
}
