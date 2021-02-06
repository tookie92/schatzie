import 'package:flutter/material.dart';
import 'package:sayamen/models/person.dart';

class EditPage extends StatefulWidget {
  final Person person;

  EditPage(this.person);
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.person.name),
      ),
    );
  }
}
