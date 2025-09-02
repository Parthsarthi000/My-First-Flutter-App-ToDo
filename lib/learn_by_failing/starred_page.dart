import 'package:first_app/learn_by_failing/app_bar.dart';
import 'package:flutter/material.dart';

//ToDo constructor elements here and .push function
class Starred extends StatefulWidget {
  const Starred({
    super.key,
    required this.theme,
    required this.changetheme,
    required this.todoitems,
    required this.starreditems,
    required this.setStarred,
    required this.setToDo,
  });
  final VoidCallback changetheme;
  final ThemeMode theme;
  final List<String> todoitems;
  final List<String> starreditems;
  final Future<void> Function(List<String>) setStarred;
  final Future<void> Function(List<String>) setToDo;
  @override
  State<Starred> createState() => StarredState();
}

class StarredState extends State<Starred> {
  final inputController = TextEditingController();
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
        widget.starreditems.add(text);
      });
      await widget.setStarred(widget.starreditems);
    }
    inputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
          pagenum: 1,
          theme: widget.theme,
          changetheme: widget.changetheme,
          navigateToStarred: () {
            Navigator.pop(context);
            setState(() {});
          }),
      body: ListView.builder(
        itemCount: widget.starreditems.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: IconButton(
              onPressed: () {
                setState(() {
                  widget.starreditems[index] = "✅";
                });
                Future.delayed(const Duration(milliseconds: 300), () {
                  setState(() {
                    widget.starreditems.removeAt(index);
                    widget.setStarred(widget.starreditems);
                  });
                });
              },
              icon: Icon(
                Icons.circle_outlined,
                color: widget.starreditems[index] == "✅"
                    ? const Color(0xFF1E90FF)
                    : null,
              ),
            ),
            title: Text(widget.starreditems[index]),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  widget.todoitems.add(widget.starreditems[index]);
                  widget.starreditems.removeAt(index);
                  widget.setToDo(widget.todoitems);
                  widget.setStarred(widget.starreditems);
                });
              },
              icon: const Icon(
                Icons.star,
                color: Color(0xFF1E90FF),
              ),
            ),
          );
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          await _showModalBottomSheet(context);
        },
        child: const Icon(
          Icons.add,
          color: Color(0xFF1E90FF),
        ),
      ),
    );
  }
}
