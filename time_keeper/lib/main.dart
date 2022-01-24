import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'models/taskData.dart';


var box;
const String dataBoxName = "DATA_BOX";

List<TaskData> data = <TaskData>[];

void main() async{
  await Hive.initFlutter();
  Hive.registerAdapter(TaskDataAdapter());
   box = await Hive.openBox<TaskData>(dataBoxName);

  data.addAll(box.values);
  runApp(const MaterialApp(home: App()));
}



class App extends StatefulWidget
{

  const App({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MainScreen();
  }



}

class MainScreen extends State<App>
{
  String tempText = "";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.white),
        home: Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('TimeKeeper')),
      body: ListView.builder(itemBuilder: (BuildContext context, int index) {
        return Dismissible(key: UniqueKey(), onDismissed: (DismissDirection direction) {
          debugPrint("deleted " + index.toString());
          box.deleteAt(index);
        }, child: Card(
            elevation: 0,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            child: Center(child: Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                height: 50,child:
            Center(child:
            Column(  mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, children: [Text(data[index].taskName, textAlign: TextAlign.center,), Text(data[index].hours.toString())])))
            )));

      },
        itemCount: data.length,

        padding: EdgeInsets.all(8),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () {

        createNewTask(context);
      }, label: Text("Add")),
    ));
  }

  createNewTask(BuildContext context) {

    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        setState(() {
          TaskData taskData = TaskData(tempText, 5);
          box.add(taskData);
          data.add(taskData);
        });


      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("My title"),
      content: Container(height: 80,child: Column(children: [Text("This is my message."),
        TextField( onChanged: (String text) {
          tempText = text;
        },)
      ])),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  
}





