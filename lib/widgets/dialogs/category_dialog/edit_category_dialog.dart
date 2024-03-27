import 'package:flutter/material.dart';

class EditCategory extends StatefulWidget {
  const EditCategory({
    super.key,
    required this.path,
    required this.onEditClick,
    this.validator,
  });

  final List<String> path;
  final void Function(String? newValue) onEditClick;
  final String? Function(String? newValue)? validator;

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String submitLabel = 'Edit Category';
    List<String> reducedPath = widget.path.toList();
    reducedPath.removeLast();

    return Dialog(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: SizedBox(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Text(reducedPath.join(" >> ")),
                TextFormField(
                  decoration:
                      const InputDecoration(hintText: "Rename category"),
                  initialValue: widget.path.last,
                  validator: widget.validator,
                  onSaved: (newValue) {
                    widget.onEditClick(newValue);
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
              ],
            ),
          ),
        )));
  }
}
