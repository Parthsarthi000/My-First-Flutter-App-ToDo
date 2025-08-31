import 'package:first_app/app_bar.dart';
import 'package:first_app/starred_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    gettheme();
  }

  Future<void> gettheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      themestate = prefs.getBool("theme") ?? true;
      if (themestate == true) {
        thememode = ThemeMode.dark;
      } else {
        thememode = ThemeMode.light;
      }
    });
  }

  ThemeMode thememode = ThemeMode.dark;
  bool themestate = true;

  Future<void> toggletheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (themestate == true) {
        thememode = ThemeMode.light;
        themestate = false;
      } else {
        thememode = ThemeMode.dark;
        themestate = true;
      }
    });

    await prefs.setBool("theme", themestate);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: thememode,
        darkTheme: ThemeData.dark(useMaterial3: true),
        theme: ThemeData.light(useMaterial3: true),
        home: HomePage(
          title: "What ToDo Today",
          changetheme: toggletheme,
          theme: thememode,
        ));
  }
}

class HomePage extends StatefulWidget {
  const HomePage(
      {super.key,
      required this.title,
      required this.changetheme,
      required this.theme});
  final String title;
  final VoidCallback changetheme;
  final ThemeMode theme;

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final inputController = TextEditingController();
  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  List<String> todoitems = [];
  List<String> starreditems = [];

  @override
  void initState() {
    super.initState();
    getdata();
  }

  Future<void> getdata() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      todoitems = prefs.getStringList("todo") ?? [];
      starreditems = prefs.getStringList("starred") ?? [];
    });
  }

  Future<void> setStarred(List<String> starredList) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("starred", starredList);
  }

  Future<void> setTodo(List<String> todoList) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("todo", todoList);
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
        todoitems.add(text);
      });
      await setTodo(todoitems);
    }
    inputController.clear();
  }

  Future<void> _navigatetostarred() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Starred(
                  theme: widget.theme,
                  changetheme: widget.changetheme,
                  todoitems: todoitems,
                  starreditems: starreditems,
                  setStarred: setStarred,
                  setToDo: setTodo,
                )));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: myAppBar(
          pagenum: 0,
          theme: widget.theme,
          changetheme: widget.changetheme,
          navigateToStarred: _navigatetostarred),
      body: ListView.builder(
          itemCount: todoitems.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(todoitems[index]),
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    todoitems[index] = "✅";
                  });
                  Future.delayed(const Duration(milliseconds: 300), () {
                    setState(() {
                      todoitems.removeAt(index);
                      setTodo(todoitems);
                    });
                  });
                },
                icon: Icon(
                  Icons.circle_outlined,
                  color:
                      todoitems[index] == "✅" ? const Color(0xFF1E90FF) : null,
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    starreditems.add(todoitems[index]);
                    todoitems.removeAt(index);
                    setTodo(todoitems);
                    setStarred(starreditems);
                  });
                },
                icon: const Icon(Icons.star_border),
              ),
            );
          }),
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          await _showModalBottomSheet(context);
        },
        child: const Icon(
          Icons.add,
          color: Color(0xFF1E90FF),
        ),
      ),
    ));
  }
}
