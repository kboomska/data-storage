import 'package:flutter/material.dart';
import 'package:sql_example/db/database.dart';

import 'package:sql_example/model/student.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'SQLite CRUD Example',
      home: StudentPage(),
    );
  }
}

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final _studentNameController = TextEditingController();

  Future<List<Student>>? _studentList;
  String _studentName = '';
  bool isUpdate = false;
  int studentIdForUpdate = 0;

  @override
  void initState() {
    super.initState();
    updateStudentList();
  }

  void updateStudentList() {
    setState(() {
      _studentList = DBProvider.db.getStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite CRUD Example'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Form(
            key: _formStateKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 10,
                  ),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null) {
                        return 'Please Enter Student Name';
                      }
                      if (value.trim() == '') {
                        return 'Only Space is Not Valid!';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _studentName = newValue ?? '';
                    },
                    controller: _studentNameController,
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.greenAccent,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      labelText: 'Student Name',
                      icon: Icon(
                        Icons.people,
                        color: Colors.black,
                      ),
                      fillColor: Colors.white,
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (isUpdate) {
                    if (_formStateKey.currentState!.validate()) {
                      _formStateKey.currentState!.save();
                      DBProvider.db
                          .updateStudent(
                        Student(id: studentIdForUpdate, name: _studentName),
                      )
                          .then((value) {
                        setState(() {
                          isUpdate = false;
                        });
                      });
                    }
                  } else {
                    if (_formStateKey.currentState!.validate()) {
                      _formStateKey.currentState!.save();
                      DBProvider.db
                          .insertStudent(Student(id: null, name: _studentName));
                    }
                  }
                  _studentNameController.text = '';
                  updateStudentList();
                },
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.green),
                  foregroundColor: MaterialStatePropertyAll(Colors.white),
                ),
                child: Text(
                  (isUpdate ? 'UPDATE' : 'ADD'),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  _studentNameController.text = '';
                  setState(() {
                    isUpdate = false;
                    studentIdForUpdate = 0;
                  });
                },
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.red),
                  foregroundColor: MaterialStatePropertyAll(Colors.white),
                ),
                child: Text(
                  (isUpdate ? 'CANCEL UPDATE' : 'CLEAR'),
                ),
              ),
            ],
          ),
          const Divider(
            height: 5.0,
          ),
          Expanded(
              child: FutureBuilder(
            future: _studentList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return generateList(snapshot.data!);
              }
              if (snapshot.data == null || snapshot.data!.isEmpty) {
                return const Text('No Data Found');
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
        ],
      ),
    );
  }

  SingleChildScrollView generateList(List<Student> students) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          columns: const [
            DataColumn(
              label: Text('NAME'),
            ),
            DataColumn(
              label: Text('DELETE'),
            ),
          ],
          rows: students
              .map(
                (student) => DataRow(
                  cells: [
                    DataCell(
                      Text(student.name),
                      onTap: () {
                        setState(() {
                          isUpdate = true;
                          studentIdForUpdate = student.id!;
                        });
                        _studentNameController.text = student.name;
                      },
                    ),
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          DBProvider.db.deleteStudent(student.id!);
                          updateStudentList();
                        },
                      ),
                      onTap: () {
                        setState(() {
                          isUpdate = true;
                          studentIdForUpdate = student.id!;
                        });
                        _studentNameController.text = student.name;
                      },
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
