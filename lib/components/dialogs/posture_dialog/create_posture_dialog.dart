import 'package:acroulette/components/dialogs/posture_dialog/segmented_view.dart';
import 'package:acroulette/main.dart';
import 'package:flutter/material.dart';

class CreatePosture extends StatefulWidget {
  const CreatePosture({
    Key? key,
    required this.path,
    required this.onSaveClick,
  }) : super(key: key);

  final List<String> path;
  final void Function(bool isCategory, String? newValue) onSaveClick;

  @override
  State<CreatePosture> createState() => _CreatePostureState();
}

class _CreatePostureState extends State<CreatePosture> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    late String submitLabel;
    if (selected == 0) {
      submitLabel = 'Add Position';
    } else {
      submitLabel = 'Add Category';
    }

    return Dialog(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: SizedBox(
          height: 300,
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SegmentedView(
                    selected: selected,
                    onPressed: (pressedIndex) {
                      setState(() {
                        selected = pressedIndex;
                      });
                    }),
                Text(widget.path.join(" >> ")),
                selected == 0
                    ? TextFormField(
                        decoration: const InputDecoration(
                            hintText: "Add position here"),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          if (objectbox.getPosition(value) != null) {
                            return 'Position $value already exists!';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          widget.onSaveClick(selected == 0, newValue);
                          Navigator.pop(context, true);
                        }, //(newValue) =>
                        //    objectbox.positionBox.put(Position(newValue!)),
                      )
                    : TextFormField(
                        decoration: const InputDecoration(
                          hintText: "Add category here",
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
                            widget.onSaveClick(selected == 1, newValue),
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                      }
                    },
                    child: Text(submitLabel),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
