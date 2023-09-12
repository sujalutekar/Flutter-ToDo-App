import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/todo.dart';
import '../widgets/to_do_item.dart';

class HomeScreenSecond extends StatefulWidget {
  const HomeScreenSecond({Key? key}) : super(key: key);

  @override
  State<HomeScreenSecond> createState() => _HomeScreenSecondState();
}

class _HomeScreenSecondState extends State<HomeScreenSecond> {
  final todoList = ToDo.todoList();
  final _todoController = TextEditingController();
  List<ToDo> _foundTodoList = [];

  @override
  void initState() {
    _foundTodoList = todoList;
    getTodos();
    super.initState();
  }

  void selectHandler(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void deleteTodoItem(String id) {
    setState(() {
      todoList.removeWhere((todo) => todo.id == id);
    });
  }

  void addNewItem(ToDo todoo) {
    final url = Uri.parse(
        'https://todo-app-34145-default-rtdb.firebaseio.com/todo.json');
    http.post(
      url,
      body: json.encode(
        {
          'id': todoo.id,
          'todoText': todoo.todoText,
        },
      ),
    );

    setState(
      () {
        if (_todoController.text.isNotEmpty) {
          todoList.insert(
            0,
            ToDo(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              todoText: _todoController.text,
            ),
          );
        } else {
          return;
        }
      },
    );
    _todoController.clear();
  }

  void getTodos() async {
    final url = Uri.parse(
        'https://todo-app-34145-default-rtdb.firebaseio.com/todo.json');

    var response = await http.get(url);
    var data = jsonDecode(response.body);

    print("TODOS $data");
  }

  Container _searchBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        onChanged: (value) => runFilter(value),
        decoration: const InputDecoration(
          hintText: 'Search',
          prefixIcon: Icon(
            Icons.search,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  void runFilter(String enteredKeyword) {
    List<ToDo> result = [];
    if (enteredKeyword.isEmpty) {
      result = todoList;
    } else {
      result = todoList
          .where(
            (item) => item.todoText.toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ),
          )
          .toList();
    }

    setState(() {
      _foundTodoList = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: _searchBox()),
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: const Text(
            'All ToDos',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: todoList.isEmpty
                ? const Center(
                    child: Text('Add new ToDo item to your list !'),
                  )
                : ListView(
                    children: [
                      for (ToDo todoo in _foundTodoList)
                        ToDoItem(
                          todo: todoo,
                          selectHandler: () => selectHandler(todoo),
                          onDeleteItem: () => deleteTodoItem(todoo.id),
                        ),
                    ],
                  ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _todoController,
                    onSubmitted: (_) => addNewItem(
                      ToDo(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        todoText: _todoController.text,
                      ),
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Add new ToDo item to your list',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue,
                ),
                height: 70,
                width: 70,
                child: ElevatedButton(
                  child: const Text(
                    '+',
                    style: TextStyle(fontSize: 40),
                  ),
                  onPressed: () {
                    addNewItem(
                      ToDo(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        todoText: _todoController.text,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
