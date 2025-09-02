import 'package:flutter/material.dart';

import 'databse.dart';

void main() {
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const HomePage(
        title: "ToDo",
      ),
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
  List<String> categoryChips = [];
  List<String> currentToDoList = [];
  late String currentCategoryChip;
  final textController = TextEditingController();
  final DatabaseService databaseService = DatabaseService.instance;
  @override
  void initState() {
    super.initState();
    currentCategoryChip = databaseService.myTasksTable;
    initialiseShit();
  }

  void initialiseShit() async {
    currentToDoList = await databaseService.initMyTasksOnAppStart();
    categoryChips = await databaseService.initCategoryChipsOnAppStart();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  Future<void> _showModalBottomSheet(BuildContext context) async {
    String? text = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return (Padding(
              padding: EdgeInsets.only(
                //when the keyboard rises, the os reserves the bottom space for keyboard, the viewinsets.bottom helps flutter pad the bottom of widget against the size of keyboard when it rises up
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: textController,
                        decoration: const InputDecoration(hintText: "New Task"),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                              onPressed: () {
                                Navigator.pop(context, textController.text);
                              },
                              child: const Text("Save")))
                    ],
                  ),
                ),
              )));
        });
    textController.clear();
    if (text != null && text != "") {
      setState(() {
        currentToDoList.add(text);
      });
      await databaseService.saveTasks(currentCategoryChip, text);
    }
  }

  Future<void> alertDialog(BuildContext context) async {
    TextEditingController textcontroller = TextEditingController();
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("Create New List"),
                    ),
                  ),
                  TextButton(
                      onPressed: () async {
                        if (categoryChips.contains(textcontroller.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('List Already Exists')),
                          );
                        } else if (textcontroller.text != "") {
                          setState(() {
                            categoryChips.add(textcontroller.text);
                            currentCategoryChip = textcontroller.text;
                            currentToDoList = [];
                          });
                          await databaseService
                              .createCategory(currentCategoryChip);
                        }
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                      },
                      child: const Text("Done"))
                ],
              ),
              TextField(
                controller: textcontroller,
                decoration: const InputDecoration(hintText: "Enter List Title"),
              ),
            ],
          ));
        });
    textcontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
        actions: <Widget>[
          Opacity(
            opacity: currentCategoryChip == databaseService.myTasksTable ||
                    currentCategoryChip == databaseService.starTable
                ? 0.5
                : 1.0,
            child: AbsorbPointer(
              absorbing: (currentCategoryChip == databaseService.myTasksTable ||
                  currentCategoryChip == databaseService.starTable),
              child: IconButton(
                onPressed: () async {
                  await databaseService.deleteCategory(currentCategoryChip);
                  categoryChips.remove(currentCategoryChip);
                  currentCategoryChip = databaseService.myTasksTable;
                  currentToDoList = await databaseService
                      .fetchCurrentToDo(databaseService.myTasksTable);
                  setState(() {
                    categoryChips;
                    currentCategoryChip;
                    currentToDoList;
                  });
                },
                icon: const Icon(Icons.delete),
              ),
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
            child: Flexible(
              child: CustomScrollView(
                scrollDirection: Axis.horizontal,
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: IconButton(
                        onPressed: () async {
                          if (currentCategoryChip !=
                              databaseService.starTable) {
                            currentToDoList = await databaseService
                                .fetchCurrentToDo(databaseService.starTable);
                            setState(() {
                              currentCategoryChip = databaseService.starTable;
                              currentToDoList;
                            });
                          }
                        },
                        icon: const Icon(Icons.star),
                        color: currentCategoryChip == databaseService.starTable
                            ? const Color(0xFF1E90FF)
                            : null,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: InkWell(
                        onTap: () async {
                          if (currentCategoryChip !=
                              databaseService.myTasksTable) {
                            currentToDoList = await databaseService
                                .fetchCurrentToDo(databaseService.myTasksTable);
                            setState(() {
                              currentCategoryChip =
                                  databaseService.myTasksTable;
                              currentToDoList;
                            });
                          }
                        },
                        child: Chip(
                          side: BorderSide.none,
                          label: Text(
                            "My Tasks",
                            style: currentCategoryChip ==
                                    databaseService.myTasksTable
                                ? const TextStyle(color: Color(0xFF1E90FF))
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return InkWell(
                          onTap: () async {
                            if (currentCategoryChip != categoryChips[index]) {
                              currentCategoryChip = categoryChips[index];
                              currentToDoList = await databaseService
                                  .fetchCurrentToDo(currentCategoryChip);
                              setState(() {
                                currentCategoryChip;
                                currentToDoList;
                              });
                            }
                          },
                          child: Chip(
                            label: Text(
                              categoryChips[index],
                              style: currentCategoryChip == categoryChips[index]
                                  ? const TextStyle(color: Color(0xFF1E90FF))
                                  : null,
                            ),
                            side: BorderSide.none,
                          ),
                        );
                      },
                      childCount:
                          categoryChips.length, // Specify the number of items
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: InkWell(
                        onTap: () async {
                          alertDialog(context);
                        },
                        child: const Chip(
                          side: BorderSide.none,
                          label: Icon(Icons.add),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            thickness: 2,
          ),
          Expanded(
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: currentToDoList.length,
                  itemBuilder: (context, index) {
                    final note = currentToDoList[index];
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          await databaseService.deleteTasks(
                              currentToDoList[index], currentCategoryChip);
                          currentToDoList.removeAt(index);
                        } else if (direction == DismissDirection.endToStart &&
                            currentCategoryChip != databaseService.starTable) {
                          await databaseService.starTasks(
                              currentToDoList[index], currentCategoryChip);
                          currentToDoList.removeAt(index);
                        } else if (direction == DismissDirection.endToStart &&
                            currentCategoryChip == databaseService.starTable) {
                          await databaseService
                              .unStarTasks(currentToDoList[index]);
                          currentToDoList.removeAt(index);
                        }
                        setState(() {
                          currentToDoList;
                        });
                      },
                      background: Container(
                        color: Colors.redAccent,
                        child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.delete)),
                      ),
                      secondaryBackground: Container(
                        color: Colors.blueAccent,
                        child: Align(
                            alignment: Alignment.centerRight,
                            child:
                                currentCategoryChip != databaseService.starTable
                                    ? const Icon(Icons.star)
                                    : null),
                      ),
                      child: ListTile(
                        title: Text(note),
                      ),
                    );
                  })),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _showModalBottomSheet(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
