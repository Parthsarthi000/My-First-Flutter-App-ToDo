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
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: myAppBar(
          pagenum: 0,
          theme: widget.theme,
          changetheme: widget.changetheme,
          navigateToStarred: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Starred(
                          theme: widget.theme,
                          changetheme: widget.changetheme,
                        )));
          }),
    ));
  }
}

// ignore: camel_case_types
class myAppBar extends StatefulWidget implements PreferredSizeWidget {
  final ThemeMode theme;
  final VoidCallback changetheme;
  final VoidCallback navigateToStarred;
  final int pagenum;
  const myAppBar(
      {super.key,
      required this.theme,
      required this.changetheme,
      required this.navigateToStarred,
      required this.pagenum});
  @override
  State<myAppBar> createState() => myAppBarState();
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// ignore: camel_case_types
class myAppBarState extends State<myAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          widget.changetheme();
        },
        icon: Icon(widget.theme == ThemeMode.dark
            ? Icons.dark_mode
            : Icons.light_mode),
      ),
      title: GestureDetector(
        child: Text(
          "What ToDo Today",
          style: TextStyle(
              color:
                  widget.pagenum == 0 ? const Color(0xFF1E90FF) : Colors.white),
        ),
        onTap: () {
          if (widget.pagenum == 1) {
            widget.navigateToStarred();
          }
        },
      ),
      actions: <Widget>[
        IconButton(
            color: widget.pagenum == 1 ? const Color(0xFF1E90FF) : Colors.white,
            onPressed: () {
              if (widget.pagenum == 0) {
                widget.navigateToStarred();
              }
            },
            icon: const Icon(Icons.star))
      ],
    );
  }
}

//ToDo constructor elements here and .push function
class Starred extends StatefulWidget {
  const Starred({super.key, required this.theme, required this.changetheme});
  final VoidCallback changetheme;
  final ThemeMode theme;
  @override
  State<Starred> createState() => StarredState();
}

class StarredState extends State<Starred> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
          pagenum: 1,
          theme: widget.theme,
          changetheme: widget.changetheme,
          navigateToStarred: () {
            Navigator.pop(context);
          }),
    );
  }
}
