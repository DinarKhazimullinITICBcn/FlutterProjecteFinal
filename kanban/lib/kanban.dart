import 'package:flutter/material.dart';
//StatefulWidget, te un estat mutable/canviable
class KanbanPage extends StatefulWidget {
  @override
  _KanbanPageState createState() => _KanbanPageState();
}

class _KanbanPageState extends State<KanbanPage> {
  /* Llistes de "maps" amb clau valor, sent strings i strings
   */
  List<Map<String, String>> toDoList = [];
  List<Map<String, String>> inProgressList = [];
  List<Map<String, String>> doneList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kanban'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildColumn('ToDo', toDoList),
          buildColumn('In Progress', inProgressList),
          buildColumn('Done', doneList),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewTaskPage()),
          );
          if (result != null) {
            setState(() {
              switch (result['status']) {
                case 'ToDo':
                  toDoList.add(result);
                  break;
                case 'In Progress':
                  inProgressList.add(result);
                  break;
                case 'Done':
                  doneList.add(result);
                  break;
              }
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildColumn(String title, List<Map<String, String>> list) {
  return Expanded(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 24),
          ),
        ),
        Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(list[index]['title'] ?? ''),
                  subtitle: Text(list[index]['description'] ?? ''),
                  onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditTaskPage(task: list[index], status: title)),
                  );
                  if (result == null) {
                    setState(() {
                      list.removeAt(index);
                    });
                  } else {
                    setState(() {
                      list.removeAt(index);
                      switch (result['status']) {
                        case 'ToDo':
                          toDoList.add(result);
                          break;
                        case 'In Progress':
                          inProgressList.add(result);
                          break;
                        case 'Done':
                          doneList.add(result);
                          break;
                      }
                    });
                  }
                },
              );
            },
          ),
        ),
      ],
    ),
  );}
}

class NewTaskPage extends StatefulWidget {
  @override
  _NewTaskPageState createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _status = 'ToDo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova tasca'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Titol'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El titol no pot ser buit';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Descripcio'),
              ),
              DropdownButtonFormField(
                value: _status,
                items: ['ToDo', 'In Progress', 'Done'].map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context, {
                      'title': _titleController.text,
                      'description': _descriptionController.text,
                      'status': _status,
                    });
                  }
                },
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class EditTaskPage extends StatefulWidget {
  final Map<String, String> task;
  final String status;

  EditTaskPage({required this.task, required this.status});

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _status = 'ToDo';

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.task['title'] ?? '';
    _descriptionController.text = widget.task['description'] ?? '';
    _status = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Tasca'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Titol'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El titul no pot ser buit';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Descripcio'),
              ),
              DropdownButtonFormField(
                value: _status,
                items: ['ToDo', 'In Progress', 'Done'].map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context, {
                      'title': _titleController.text,
                      'description': _descriptionController.text,
                      'status': _status,
                    });
                  }
                },
                child: Text('Enviar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Eliminar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}