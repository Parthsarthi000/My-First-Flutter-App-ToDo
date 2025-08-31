import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

//Widget build() used to set the UI titles themes and widgets of the specific class
class MyApp extends StatelessWidget {
  const MyApp({super.key}); //constructor called
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //MaterialApp is the home:invocation in runApp()sets the home,title, page layout of the app
      title: 'Flutter Course',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Course'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
} //with StatefulWidget classes, we always need to createState of that class

//This created State object(_MyHomePageState) manages the widget’s dynamic behavior, handles updates, and maintains state.
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button x many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.music_note),
      ),
    );
  }
}
