import 'package:flutter/material.dart';

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
              color: widget.pagenum == 0
                  ? const Color(0xFF1E90FF)
                  : (widget.theme == ThemeMode.light
                      ? Colors.black
                      : Colors.white)),
        ),
        onTap: () {
          if (widget.pagenum == 1) {
            widget.navigateToStarred();
          }
        },
      ),
      actions: <Widget>[
        IconButton(
            color: widget.pagenum == 1
                ? const Color(0xFF1E90FF)
                : (widget.theme == ThemeMode.light
                    ? Colors.black
                    : Colors.white),
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
