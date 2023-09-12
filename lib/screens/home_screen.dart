import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../widgets/drawer.dart';

import '../screens/home.dart';
import '../model/todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final todoList = ToDo.todoList();
  final _todoController = TextEditingController();
  // ignore: unused_field
  List<ToDo> _foundTodoList = [];

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

  AppBar _buildAppBar() {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.black),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      backgroundColor: const Color(0xFFEEEFF5),
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          // Icon(
          //   Icons.menu,
          //   color: Colors.black,
          //   size: 25,
          // ),
          Spacer(),
          Text(
            'ToDo',
            style: TextStyle(color: Colors.black, fontSize: 25),
          ),
          Spacer(),
          CircleAvatar(
            backgroundImage: NetworkImage(
                'https://thumbs.dreamstime.com/b/logo-avengers-145259952.jpg'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    _foundTodoList = todoList;
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
    return Scaffold(
      backgroundColor: const Color(0xFFEEEFF5),
      appBar: _buildAppBar(),
      drawer: MainDrawer(),
      body: const HomeScreenSecond(),
      // body: Stack(
      //   children: [
      //     Container(
      //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      //       child: Column(
      //         children: [
      //           _searchBox(),
      //           Expanded(
      //             child: ListView(
      //               children: [
      //                 Container(
      //                   padding: const EdgeInsets.only(top: 50, bottom: 20),
      //                   child: const Text(
      //                     'All ToDos',
      //                     style: TextStyle(
      //                       fontWeight: FontWeight.bold,
      //                       fontSize: 30,
      //                     ),
      //                   ),
      //                 ),
      //                 for (ToDo todoo in _foundTodoList)
      //                   ToDoItem(
      //                     todo: todoo,
      //                     selectHandler: () => selectHandler(todoo),
      //                     onDeleteItem: () => deleteTodoItem(todoo.id),
      //                   ),
      //               ],
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //     Align(
      //       alignment: Alignment.bottomCenter,
      //       child: Row(
      //         children: [
      //           Expanded(
      //             child: Container(
      //               padding:
      //                   const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      //               decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(10),
      //                 color: Colors.white,
      //                 boxShadow: const [
      //                   BoxShadow(
      //                     color: Colors.black,
      //                     offset: Offset(0.0, 0.0),
      //                     blurRadius: 10,
      //                     spreadRadius: 0,
      //                   ),
      //                 ],
      //               ),
      //               margin: const EdgeInsets.only(
      //                 left: 20,
      //                 bottom: 20,
      //                 right: 20,
      //               ),
      //               child: TextField(
      //                 controller: _todoController,
      //                 onSubmitted: (_) => addNewItem(),
      //                 textInputAction: TextInputAction.done,
      //                 decoration: const InputDecoration(
      //                   hintText: 'Add new item',
      //                   border: InputBorder.none,
      //                 ),
      //               ),
      //             ),
      //           ),
      //           Container(
      //             margin: const EdgeInsets.only(
      //               bottom: 20,
      //               right: 20,
      //             ),
      //             height: 60,
      //             child: ElevatedButton(
      //               child: const Text(
      //                 '+',
      //                 style: TextStyle(fontSize: 45),
      //               ),
      //               onPressed: () {
      //                 addNewItem();
      //                 print('Added new item');
      //               },
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
