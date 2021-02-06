import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sayamen/models/person.dart';
import 'package:sayamen/screens/edit_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    personlist = [];
    person = Person('');
    databaseReference = db.reference().child('Mensch');
    databaseReference.onChildAdded.listen(_onEntryAdded);
    databaseReference.onChildChanged.listen(_onEntryChanged);
  }

  void _onEntryAdded(Event event) async {
    setState(() {
      personlist.add(Person.fromSnapShot(event.snapshot));
    });
  }

  void _onEntryChanged(Event event) async {
    var oldEntry =
        personlist.singleWhere((entry) => entry.key == event.snapshot.key);
    setState(() {
      personlist[personlist.indexOf(oldEntry)] =
          Person.fromSnapShot((event.snapshot));
    });
  }

  //String id;
  final db = FirebaseDatabase.instance;
  final _formkey = GlobalKey<FormState>();
  DatabaseReference databaseReference;
  List<Person> personlist;

  Person person;
  //String name;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Crud'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: [
          Form(
            key: _formkey,
            child: buildFormField(),
          ),
          Row(
            children: [
              TextButton(onPressed: createData, child: Text('Create')),
              TextButton(onPressed: readData, child: Text('Read')),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: SizedBox(
                height: size.height * 0.5,
                child: FirebaseAnimatedList(
                  key: ValueKey<bool>(true),
                  query: databaseReference,
                  reverse: true,
                  sort: true
                      ? (DataSnapshot a, DataSnapshot b) =>
                          b.key.compareTo(a.key)
                      // ignore: dead_code
                      : null,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    return SizeTransition(
                      sizeFactor: animation,
                      child: showUser(snapshot),
                    );
                  },
                ),
              ))
            ],
          )
        ],
      ),
    );
  }

  void createData() async {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
      _formkey.currentState.reset();
      await databaseReference.push().set(person.toJson()).then((_) {
        print('geschaft');
      });
    }
  }

  //delete
  void deleteData(Person person) async {
    await databaseReference.child(person.key).remove();
  }

  void readData() {}

  TextFormField buildFormField() {
    return TextFormField(
      decoration: InputDecoration(
          hintText: 'name',
          filled: true,
          fillColor: Colors.grey,
          border: InputBorder.none),
      initialValue: '',
      validator: (value) => value.isEmpty ? 'Please enter was' : null,
      onSaved: (newValue) => person.name = newValue,
    );
  }

  //list des Users
  showUser(DataSnapshot res) {
    Person person = Person.fromSnapShot(res);

    var item = Card(
        child: Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: Row(children: [
        Text(person.name),
        Row(
          children: [
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => EditPage(person)))),
            IconButton(
                icon: Icon(Icons.delete_forever),
                onPressed: () => deleteData(person))
          ],
        ),
      ]),
    ));
    return item;
  }
}
