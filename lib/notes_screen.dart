import 'dart:convert';

import 'package:flutter/material.dart';
import 'add_notes.dart';
import 'edit_notes.dart';
import 'model_note.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({Key? key}) : super(key: key);

  @override
  State<ToDoList> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<ToDoList> {
  late Future<List<Notes>> notesFuture;
  late List<Notes> list; // Declare list here
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    list = []; // Initialize list
    notesFuture = getData();
  }

  Future<List<Notes>> getData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    List<String>? stringList = sharedPreferences.getStringList("list");

    if (stringList != null) {
      return stringList
          .map((item) => Notes.fromMap(json.decode(item)))
          .toList();
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("CookBook"),
      ),
      body: FutureBuilder(
        future: notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error loading data"),
            );
          } else if (snapshot.data == null) {
            return const Center(
              child: Text("Empty"),
            );
          } else {
            list = snapshot.data as List<Notes>; // Update list here

            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () async {
                    // Open the note for editing and get the updated note
                    Notes updatedNote = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditNotes(note: list[index]),
                      ),
                    );

                    if (updatedNote != null) {
                      // Update the note in the list
                      setState(() {
                        list[index] = updatedNote;
                        saveData();
                      });
                    }
                  },
                  leading: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 66, 66, 66),
                    child: Icon(
                    Icons.edit, // Change to the appropriate icon
                        color: Colors.white, // Change icon color here
                      ),),
                    title: Text(list[index].title),
  subtitle: Text(list[index].description.length > 20
      ? '${list[index].description.substring(0, 20)}...'
      : list[index].description),
  trailing: IconButton(
    onPressed: () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(255, 29, 29, 29), // Change background color here
            title: Text("Delete Note", style: TextStyle(color: Colors.white)),
            content: Text("Are you sure you want to delete this recipe/list? You won't be able to recover this recipe/list", style: TextStyle(color: Colors.white)),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    list.remove(list[index]);
                    saveData();
                    Navigator.of(context).pop(); // Close the dialog
                  });
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.red), // Change button color here
                ),
                child: Text("Delete"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text("Cancel", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    },
    icon: const Icon(Icons.delete_forever_outlined),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            Color.fromARGB(255, 66, 66, 66), // Change the color here
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () async {
          String refresh = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNotes()),
          );

          if (refresh == "loadData") {
            setState(() {
              notesFuture = getData(); // Update notesFuture here
            });
          }
        },
      ),
    );
  }

  void saveData() {
    // Save the updated list to SharedPreferences
    List<String> stringList =
        list.map((item) => json.encode(item.toMap())).toList();
    sharedPreferences.setStringList("list", stringList);
  }
}
