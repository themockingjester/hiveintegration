import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'DataModel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(DataModelAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String resultValue= "";
  Box? box;
  Future closeBox() async {
    await box?.close();
  }
  Future openBox() async{
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('testBox');
    return;
  }
  void putData() async {
    DataModel data = DataModel(title: "yash",description: "xyz",complete: true);
    //await box?.put("name", "yash").onError((error, stackTrace){
    await box?.add(data).onError((error, stackTrace){
      setState(() {
        resultValue = error.toString();
      });
      return 0;
    }).whenComplete((){
      setState(() {
        resultValue = "Successfully putted value!";
      });
    });

  }
  void deleteData() async {
    //await box?.delete('name').onError((error, stackTrace){
    bool? existence = box?.isEmpty;
    if(existence!=null && existence == true){
      setState(() {
        resultValue = "Null";
      });
      return;
    }
    await box?.deleteAt(0).onError((error, stackTrace){
      setState(() {
        resultValue = error.toString();
      });
    }).whenComplete((){
      setState(() {
        resultValue = "Successfully Deleted!";
      });
    });
  }
  void updateData() async {
    //await box?.put("name", "Coder").onError((error, stackTrace){
    bool? existence = box?.isEmpty;
    if(existence!=null && existence == true){
      setState(() {
        resultValue = "Null";
      });
      return;
    }
    DataModel data = DataModel(title: "mathur",description: "zvc",complete: false);
    await box?.putAt(0, data).onError((error, stackTrace){
      setState(() {
        resultValue = error.toString();
      });
    }).whenComplete((){
      setState(() {
        resultValue  = "SuccessFully Updated";
      });
    });
  }
  void getData() async  {
    //var data = await box?.get('name');
    bool? existence = box?.isEmpty;
    if(existence!=null && existence == true){
      setState(() {
        resultValue = "Null";
      });
      return;
    }
    DataModel? data = await box?.getAt(0);
    setState(() {

      if(data!=null){
        resultValue = "${data.title} ${data.description} ${data.complete}";
      }
      else{
        resultValue = "Null";
      }

    });


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    openBox();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    closeBox();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Text(
              resultValue,
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(onPressed: putData, child: Text('add')),
            ElevatedButton(onPressed: getData, child: Text('get')),
            ElevatedButton(onPressed: updateData, child: Text('update')),
            ElevatedButton(onPressed: deleteData, child: Text('delete')),
          ],
        ),
      ),
    );
  }
}
