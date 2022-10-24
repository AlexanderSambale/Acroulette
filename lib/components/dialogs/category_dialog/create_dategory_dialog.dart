import 'package:acroulette/main.dart';
import 'package:flutter/material.dart';

class CreateCategory extends StatefulWidget {
  const CreateCategory({
    Key? key,
    required this.path,
    required this.onSaveClick,
  }) : super(key: key);

  final List<String> path;
  final void Function(String? newValue) onSaveClick;

  @override
  State<CreateCategory> createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String submitLabel = 'Add Category';

    return Dialog(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: SizedBox(
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(children: [
                    Text(widget.path.join(" >> ")),
                    TextFormField(
                      decoration:
                          const InputDecoration(hintText: "Add category here"),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        if (objectbox.getPosition(value) != null) {
                          return 'Category $value already exists!';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        widget.onSaveClick(newValue);
                        Navigator.pop(context, true);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                              }
                            },
                            child: Text(submitLabel),
                          )),
                          Container(
                            width: 10,
                          ),
                          Expanded(
                              child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: const Text('Cancel'),
                          )),
                        ],
                      ),
                    ),
                  ]),
                ))));
  }
}
