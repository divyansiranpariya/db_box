import 'package:flutter/material.dart';
import '../services/db_helper.dart';
import '../models/todo_model.dart';
import '../services/shared_preferences_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Todo>> todosFuture;

  @override
  void initState() {
    super.initState();
    refreshTodos();
  }

  void refreshTodos() {
    todosFuture = DBHelper.instance.getTodos();
  }

  void showEditTodoDialog(BuildContext context, Todo todo) {
    TextEditingController titleController =
        TextEditingController(text: todo.title);
    bool isBookmarked = todo.isBookmarked;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit TODO"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: isBookmarked,
                    onChanged: (value) {
                      setState(() {
                        isBookmarked = value!;
                      });
                    },
                  ),
                  Text("Mark as important"),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty) {
                  todo.title = titleController.text;
                  todo.isBookmarked = isBookmarked;
                  await DBHelper.instance.updateTodo(todo: todo);
                  Navigator.pop(context);
                  refreshTodos();
                  setState(() {});
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TODO List"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: SharedPreferencesHelper.toggleTheme,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              refreshTodos();
              setState(() {});
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              DBHelper.instance.removeAllTodos();
              setState(() {});
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Todo>>(
        future: todosFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("An error occurred!"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No TODOs available."));
          } else if (snapshot.hasData) {
            final todos = snapshot.data!;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  title: Text(todo.title),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          todo.isBookmarked
                              ? Icons.bookmark
                              : Icons.bookmark_outline,
                        ),
                        onPressed: () async {
                          todo.isBookmarked = !todo.isBookmarked;
                          await DBHelper.instance.updateTodo(todo: todo);
                          refreshTodos();
                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          showEditTodoDialog(context, todo);
                        },
                      ),
                    ],
                  ),
                  onLongPress: () async {
                    await DBHelper.instance.removeTodo(todo.id!);
                    refreshTodos();
                    setState(() {});
                  },
                );
              },
            );
          } else
            return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              TextEditingController titleController = TextEditingController();
              bool isBookmarked = false;

              return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Add New TODO",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: "Title",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Checkbox(
                            value: isBookmarked,
                            onChanged: (value) {
                              setState(() {
                                isBookmarked = value!;
                              });
                            },
                          ),
                          Text("Mark as important"),
                        ],
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          if (titleController.text.isNotEmpty) {
                            Todo newTodo = Todo(
                              title: titleController.text,
                              isBookmarked: isBookmarked,
                            );
                            await DBHelper.instance.insertTodo(todo: newTodo);
                            Navigator.pop(context);
                            refreshTodos();
                            setState(() {});
                          }
                        },
                        child: Text("Add TODO"),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
