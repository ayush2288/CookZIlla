import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model_note.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({Key? key}) : super(key: key);

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  List<Notes> list = [];
  late SharedPreferences sharedPreferences;

  getData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    List<String>? stringList = sharedPreferences.getStringList("list");

    if (stringList != null) {
      list = stringList.map((item) => Notes.fromMap(json.decode(item))).toList();
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Adding Recipe"),
      ),
      body: SingleChildScrollView( // Wrap your column with SingleChildScrollView
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              height: 350,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                // border: Border.all(color: Colors.blueAccent, width: 2)
              ),
              child: Column(
                children: [
                  TextField(
                    controller: title,
                    maxLines: 1,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    decoration: const InputDecoration(
                      hintText: "Dishname",
                      border: InputBorder.none,
                    ),
                  ),
                  TextFormField(
                    controller: description,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      isDense: true,
                      hintText: "Recipe or Shopping List",
                    ),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {
                list.insert(0, Notes(title: title.text, description: description.text));
                List<String> stringList = list.map((item) => json.encode(item.toMap())).toList();
                sharedPreferences.setStringList("list", stringList);

                Navigator.pop(context, "loadData");
              },
              child: Container(
                height: 50,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16), // Optional: Add some space after the button
          ],
        ),
      ),
    );
  }
}
