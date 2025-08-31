import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Let's see what we make",
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomePage(title: "APP"),
    );
  }
}

// ignore: camel_case_types
class numsPages extends StatefulWidget {
  final int num;
  final String pagetitle;

  const numsPages({super.key, required this.num}) : pagetitle = "Page $num";
  @override
  State<numsPages> createState() => numsPagesState();
}

// ignore: camel_case_types
class numsPagesState extends State<numsPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pagetitle),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({super.key, required this.title});
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int listsize = 0;
  List<numsPages> pagesList = [];
  void addsize() {
    setState(() {
      listsize += 1;
    });
  }

  void decsize() {
    setState(() {
      listsize -= 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.amber[300]),
              child: Card(
                  color: Colors.amber[200],
                  shadowColor: Colors.amber[500],
                  child: const Center(
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text("Parthsarthi Kalra"),
                      subtitle: Text("pkalra@connect.ust.hk"),
                    ),
                  )),
            ),
            ListTile(
              leading: const Icon(Icons.send),
              title: const Text("Sent"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.drive_file_rename_outline_sharp),
              title: const Text("Drafts"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.inbox_outlined),
              title: const Text("Inbox"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.archive),
              title: const Text("Archive"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text("Delete"),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("HomePage"),
        backgroundColor: const Color.fromARGB(255, 197, 157, 36),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              pagesList.add(numsPages(num: pagesList.length + 1));
              addsize();
            },
            icon: const Icon(Icons.add),
            tooltip: "Add Task",
          ),
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemCount: listsize, // Number of items in the list
          itemBuilder: (context, index) {
            return ListTile(
              leading: Checkbox(value: false, onChanged: (bool? value) {}),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => pagesList[index]),
                );
              },
              onLongPress: () {},
              title: Text('Item ${index + 1}'),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height * 0.075,
        color: Colors.amber[300],
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.mail),
                Text("Mail"),
              ],
            ),
            Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Icon(Icons.calendar_month),
              Text("Calender")
            ]),
            Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[Icon(Icons.feed), Text("Feed")]),
            Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[Icon(Icons.apps), Text("Apps")]),
          ],
        ),
      ),
    );
  }
}
