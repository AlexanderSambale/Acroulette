import 'package:flutter/material.dart';

class EditFlow extends StatefulWidget {
  const EditFlow({
    Key? key,
    required this.flowName,
    required this.onEditClick,
    this.validator,
  }) : super(key: key);

  final String flowName;
  final void Function(String? newValue) onEditClick;
  final String? Function(String? newValue)? validator;

  @override
  State<EditFlow> createState() => _EditFlowState();
}

class _EditFlowState extends State<EditFlow> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String submitLabel = 'Edit Flow';

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
                TextFormField(
                  decoration: const InputDecoration(hintText: "Rename flow"),
                  initialValue: widget.flowName,
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
