import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_shared_prefs_backend/Widgets/custom_text.dart';
import 'package:modal_shared_prefs_backend/models/person.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var nameController = TextEditingController();
  var ageController = TextEditingController();
  var genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Modal Class And Shared Prefs',
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: CustomText(
                        text: 'Data Saved',
                      ),
                      content: FutureBuilder<Person>(
                        future: loadData(),
                        builder: (BuildContext context,
                            AsyncSnapshot<Person> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CustomText(text: '....');
                          }
                          var data = snapshot.data;
                          if (data == null) {
                            return CustomText(text: 'No Data Saved');
                          } else {
                            return CustomText(
                                text:
                                    'Name : ${data.name}. Age : ${data.age}. Gender : ${data.gender}');
                          }
                        },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: CustomText(text: 'Clear'),
                        ),
                        TextButton(
                          onPressed: () async {
                            SharedPreferences sp =
                                await SharedPreferences.getInstance();
                            await sp.clear();
                            Navigator.pop(context);
                          },
                          child: CustomText(text: 'Clear Data'),
                        ),
                      ],
                    );
                  });
            },
            icon: Icon(Icons.print),
          ),
        ],
      ),
      body: Column(
        children: [
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'Enter Your Name',
            ),
          ),
          TextFormField(
            controller: ageController,
            decoration: InputDecoration(
              hintText: 'Enter Your Age',
            ),
          ),
          TextFormField(
            controller: genderController,
            decoration: InputDecoration(
              hintText: 'Enter Your Gender',
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var name = nameController.text;
          var age = int.tryParse(ageController.text) ?? 0;
          var gender = genderController.text;
          var person = Person(name: name, age: age, gender: gender);
          saveData(person).then((value) {
            print('Saved ');
          });
        },
        child: Icon(Icons.save),
      ),
    );
  }

  Future<void> saveData(Person person) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var map = person.toJson();
    var json = jsonEncode(map);
    await sp.setString('person', json);
  }

  Future<Person> loadData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var json = sp.getString('person');
    var map = jsonDecode(json!) as Map<String, dynamic>;
    return Person.fromJson(map);
  }
}
