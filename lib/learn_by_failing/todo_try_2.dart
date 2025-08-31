import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Shared preferences demo',
      home: HomePage(title: 'Shared preferences demo'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final inputController = TextEditingController();
  String inputText = "";
  List<String> todoItems = [];
  @override
  void initState() {
    super.initState();
    getToDo();
  }

  Future<void> getToDo() async {
    final list = await SharedPreferences.getInstance();
    setState(() {
      todoItems = list.getStringList("ToDo_Data") ?? [];
    });
  }

  Future<void> setToDo(List<String> toDoList) async {
    final list = await SharedPreferences.getInstance();
    await list.setStringList("ToDo_Data", toDoList);
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  Future<void> _showModalBottomSheet(BuildContext context) async {
    String? text = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return (Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: inputController,
                      decoration: const InputDecoration(hintText: "New Task"),
                    ),
                    const SizedBox(
                      //maybe for better bottom visuals instead of adding padding below TextField
                      height: 10,
                    ),
                    FloatingActionButton(
                        onPressed: () {
                          Navigator.pop(context, inputController.text);
                        },
                        child: const Icon(Icons.check))
                  ],
                ),
              ),
            ),
          ));
        });

    if (text != null && text.isNotEmpty) {
      setState(() {
        todoItems.add(text);
      });
      await setToDo(todoItems);
      inputController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "What ToDo Today?",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
            onPressed: () async {
              await _showModalBottomSheet(context);
            },
            icon: const Icon(Icons.add)),
        backgroundColor: Colors.black45,
      ),
      body: ListView.builder(
        itemCount: todoItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(todoItems[index]),
          );
        },
      ),
    );
  }
}
