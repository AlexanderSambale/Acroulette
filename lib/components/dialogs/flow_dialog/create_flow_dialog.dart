import 'package:flutter/material.dart';

class CreateFlow extends StatefulWidget {
  const CreateFlow({
    Key? key,
    required this.onSaveClick,
    this.validator,
  }) : super(key: key);

  final void Function(String? newValue) onSaveClick;
  final String? Function(String? newValue)? validator;

  @override
  State<CreateFlow> createState() => _CreateFlowState();
}

class _CreateFlowState extends State<CreateFlow> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String submitLabel = 'Add Flow';

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
                    TextFormField(
                      decoration:
                          const InputDecoration(hintText: "Add flow here"),
                      validator: widget.validator,
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
