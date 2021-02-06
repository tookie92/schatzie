import 'package:firebase_database/firebase_database.dart';

class Person {
  String key;
  String name;

  Person(this.name);

  Person.fromSnapShot(DataSnapshot snapshot)
      : key = snapshot.key,
        name = snapshot.value['name'];

  toJson() {
    return {
      'name': name,
    };
  }
}
