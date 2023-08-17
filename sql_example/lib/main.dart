import 'package:flutter/material.dart';

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
                    onSaved: (newValue) {},
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
                onPressed: () {},
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.green),
                  foregroundColor: MaterialStatePropertyAll(Colors.white),
                ),
                child: const Text('ADD'),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {},
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.red),
                  foregroundColor: MaterialStatePropertyAll(Colors.white),
                ),
                child: const Text('CLEAR'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
