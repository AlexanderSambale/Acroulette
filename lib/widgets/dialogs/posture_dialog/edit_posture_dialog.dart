import 'package:flutter/material.dart';

class EditPosture extends StatefulWidget {
  const EditPosture({
    Key? key,
    required this.path,
    required this.onEditClick,
    this.validator,
  }) : super(key: key);

  final List<String> path;
  final void Function(String? newValue) onEditClick;
  final String? Function(String? newValue)? validator;

  @override
  State<EditPosture> createState() => _EditPostureState();
}

class _EditPostureState extends State<EditPosture> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String submitLabel = 'Edit Position';
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
                      const InputDecoration(hintText: "Rename position"),
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
