import 'package:acroulette/database/objectbox.g.dart';
import 'package:acroulette/main.dart';
import 'package:acroulette/models/position.dart';
import 'package:flutter/material.dart';

class Positions extends StatefulWidget {
  const Positions({Key? key}) : super(key: key);

  @override
  State<Positions> createState() => _PositionsState();
}

class _PositionsState extends State<Positions> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            const Text("Positions"),
            const Text("New Position"),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Add position here",
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                if (objectbox.getPosition(value) != null) {
                  return 'Position $value already exists!';
                }
                return null;
              },
              onSaved: (newValue) =>
                  objectbox.positionBox.put(Position(newValue!)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                  }
                },
                child: const Text('Submit'),
              ),
            ),
/*             StreamBuilder(
              stream: objectbox.positionBox
                  .query(Position_.name.notEquals(""))
                  .watch(),
              builder: (context, snapshot) => ListView(children: <Widget>[
                Text("test"),
              ]),
            ) */
          ],
        ));
  }
}
