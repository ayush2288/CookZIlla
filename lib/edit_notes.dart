import 'package:flutter/material.dart';
import 'model_note.dart';

class EditNotes extends StatefulWidget {
  final Notes note;

  const EditNotes({Key? key, required this.note}) : super(key: key);

  @override
  _EditNotesState createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note.title);
    descriptionController =
        TextEditingController(text: widget.note.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Recipe"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                controller: titleController,
                decoration: InputDecoration(labelText: 'Dishname'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                maxLines: 16,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: "Recipe or Shopping List",
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Save changes and pop the screen
                  Navigator.pop(
                    context,
                    Notes(
                      title: titleController.text,
                      description: descriptionController.text,
                    ),
                  );
                },
                child: Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
