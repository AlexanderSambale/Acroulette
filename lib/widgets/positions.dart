import 'package:acroulette/components/posture_tree/posture_tree.dart';
import 'package:acroulette/database/objectbox.g.dart';
import 'package:acroulette/main.dart';
import 'package:acroulette/models/acro_node.dart';
import 'package:acroulette/models/node.dart';
import 'package:acroulette/models/position.dart';
import 'package:flutter/material.dart';

/// Depending on [isSwitched] we enable or disable recursive [acroNodes] from
/// this [tree].
///
/// Here is a table, what to do in which case.
///
/// state | toEnable | toDisable
/// ----|----|----
/// enabled switch on| /| disabled on, disable others
/// disable switch on| enable on, enable others| /
/// enabled switch off| /| disable off, nothing else
/// disable switch off| enable off, nothing else|/
void enableOrDisableAndAddAcroNodes(
    List<AcroNode> acroNodes, Node tree, bool isSwitched) {
  for (var node in tree.children) {
    AcroNode acroNode = node.value.target!;
    if (acroNode.isSwitched) {
      enableOrDisableAndAddAcroNodes(acroNodes, node, isSwitched);
    }
    acroNode.isEnabled = isSwitched;
    acroNodes.add(acroNode);
  }
}

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
            StreamBuilder(
                stream: objectbox.watchNodeBox(),
                builder: (context, snapshot) => snapshot.hasData
                    ? PostureTree(
                        tree: snapshot.data as Node,
                        onSwitched: (bool switched, Node tree) {
                          AcroNode acroNode = tree.value.target!;
                          acroNode.isSwitched = switched;
                          List<AcroNode> acroNodes = [];
                          enableOrDisableAndAddAcroNodes(
                              acroNodes, tree, switched);
                          acroNodes.add(acroNode);
                          objectbox.putManyAcroNodes(acroNodes);
                          objectbox.putNode(tree);
                        },
                        toggleExpand: (Node tree) {
                          tree.isExpanded = !tree.isExpanded;
                          objectbox.putNode(tree);
                        },
                      )
                    : Container())
          ],
        ));
  }
}
