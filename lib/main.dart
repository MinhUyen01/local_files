import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reading and Writing File from disk',
      home: HomePage(storage: IntStorage()),
    ),
  );
}

class IntStorage {
  //1.
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
  //2.
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }
  //3.
  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }
  //4.
  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }
}

class HomePage extends StatefulWidget {

  const HomePage({ required this.storage});

  final IntStorage storage;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int count = 0;
  int savedValue = 0;
  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((value) {
      setState(() {
        savedValue = value;
      });
    });
  }

  Future<File> _incrementCounter() {
    setState(() {
      count++;
      savedValue++;
    });

    // Write the variable as a string to the file.
    return widget.storage.writeCounter(savedValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading and Writing Files'),
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Value in disk $savedValue time${savedValue == 1 ? '' : 's'}.',style: TextStyle(fontSize: 22),
            ),
            Text(
                'Button tapped $count time${count == 1 ? '' : 's'}.',style: TextStyle(fontSize: 22)
            ),
            TextButton(onPressed: (){
              setState(() {
                count = 0;
              });
            }, child: Text("Refresh"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}