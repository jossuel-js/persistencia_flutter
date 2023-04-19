import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize the database
  await dbHelper.init();
  runApp(const MyApp());
}

final dbHelper = DatabaseHelper();

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;

  static const table = 'my_table';

  static const columnId = '_id';
  static const columnName = 'name';
  static const columnPassowrd = 'password';

  late Database _db;

  Future<int> insert(Map<String, dynamic> row) async {
    return await _db.insert(table, row);
  }

  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnPassowrd TEXT NOT NULL
          )
          ''');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '###',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Registro(title: '###'),
    );
  }
}

class Registro extends StatefulWidget {
  const Registro({super.key, required String title});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  TextEditingController nameController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

  final String _info = "Informe os dados!";

  void _registrar() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: nameController,
      DatabaseHelper.columnPassowrd: senhaController
    };
    final id = await dbHelper.insert(row);
    debugPrint('inserted row id: $id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(10)),
            const CircleAvatar(
              radius: 150,
              backgroundImage: NetworkImage(
                  ''),
              backgroundColor: Color.fromARGB(255, 50, 61, 178),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 50, 50, 20),
              child: TextFormField(
                // ignore: prefer_const_constructors
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    // ignore: prefer_const_constructors
                    border: OutlineInputBorder(
                      // ignore: prefer_const_constructors
                      borderRadius: BorderRadius.all(
                        // ignore: prefer_const_constructors
                        Radius.circular(10.0),
                      ),
                    ),
                    labelText: 'Enter your name'),
                controller: nameController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
              child: TextFormField(
                // ignore: prefer_const_constructors
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    // ignore: prefer_const_constructors
                    border: OutlineInputBorder(
                      // ignore: prefer_const_constructors
                      borderRadius: BorderRadius.all(
                        // ignore: prefer_const_constructors
                        Radius.circular(10.0),
                      ),
                    ),
                    labelText: 'Enter your password'),
                controller: senhaController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(300, 20, 300, 20),
              child: Container(
                height: 50,
                // ignore: prefer_const_constructors
                color: Color.fromARGB(255, 115, 95, 214),
                child: ElevatedButton(
                  onPressed: () {
                    _registrar();
                  },
                  child: const Text("Registrar"),
                ),
              ),
            ),
            Text(_info,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.blueGrey, fontSize: 17.0))
          ],
        ),
      ),
    );
  }
}
