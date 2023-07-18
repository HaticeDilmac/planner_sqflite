// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:planner_sqflite/planner/add_update.dart';
import 'package:planner_sqflite/planner/db_handler.dart';
import 'package:planner_sqflite/planner/model.dart';

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  DBHelper? dbHelper;
  late Future<List<ToDoModel>> datalist;

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
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.deepPurple,
        // ignore: sort_child_properties_last
        child: const Icon(
          Icons.add,
          color: Colors.purple,
          size: 30,
        ),
        backgroundColor: Theme.of(context).cardColor,
        onPressed: () {
          // Navigator.pushNamed(context, '/add_update');
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddUpdateTask()));
        },
      ),
      appBar: AppBar(
        title: const Text('Planlayıcım'),
      ),
      body: Column(children: [
        Expanded(
            child: FutureBuilder(
                future: datalist,
                builder: (context, AsyncSnapshot<List<ToDoModel>> snapshot) {
                  if (!snapshot.hasData || snapshot.hasData == null) {
                    // Veri yüklenirken gösterilecek yüklenme animasyonu
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data!.isEmpty) {
                    // Eğer veri yoksa gösterilecek mesaj
                    return const Center(
                        child: Text(
                      'HENÜZ Hİç Planınız Yok',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "AmaticSC",
                          fontSize: 30,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w700),
                    ));
                  } else {
                    // Veri varsa listeyi oluşturan ListView.builder
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        int todoId = snapshot.data![index].id!.toInt();
                        String todoTitle =
                            snapshot.data![index].title.toString();
                        String todoDesc = snapshot.data![index].desc.toString();
                        String todoDT =
                            snapshot.data![index].deteandtime.toString();
                        return Dismissible(
                          key: ValueKey<int>(todoId),
                          direction: DismissDirection.endToStart,
                          background: Container(
                              color: Colors.red,
                              child: const Icon(Icons.delete)),
                          onDismissed: (DismissDirection direction) {
                            // Bir görev silindiğinde yapılacak işlemler
                            setState(() {
                              dbHelper!.delete(todoId);
                              datalist = dbHelper!.getDataList();
                              snapshot.data!.remove(snapshot.data![index]);
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(context).secondaryHeaderColor,
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 4,
                                      spreadRadius: 1)
                                ]),
                            child: Column(
                              children: [
                                ListTile(
                                  contentPadding: const EdgeInsets.all(10),
                                  title: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      todoTitle,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ),
                                  subtitle: Text(
                                    todoDesc,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                                const Divider(
                                  // Ayırıcı çizgi Widget'i
                                  color: Colors.black,
                                  thickness: 0.8,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 10),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          todoDT,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontFamily: "ArchivoBlack",
                                              fontStyle: FontStyle.italic),
                                        ),
                                        InkWell(
                                          // Düzenleme düğmesi
                                          onTap: () {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddUpdateTask(
                                                          todoId: todoId,
                                                          todoTitle: todoTitle,
                                                          todoDesc: todoDesc,
                                                          todoDT: todoDT,
                                                          update: true,
                                                        )));
                                          },
                                          child: const Icon(
                                            Icons.edit_note,
                                            color: Colors.red,
                                            size: 30,
                                          ),
                                        )
                                      ]),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                })),
      ]),
    );
  }
}
