import 'dart:collection';

import 'package:acroulette/components/posture_tree/posture_category_item.dart';
import 'package:acroulette/components/posture_tree/posture_list_item.dart';
import 'package:acroulette/components/posture_tree/posture_tree.dart';
import 'package:acroulette/models/acro_node.dart';
import 'package:acroulette/models/node.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

var onSwitch = (bool isOn) => {};
var delete = () => {};

Node<AcroNode> createSimpleTree(
    {String rootName = 'root',
    String leaf1Name = 'leaf1',
    String leaf2Name = 'leaf2',
    String leaf3Name = 'leaf3'}) {
  LinkedHashSet<Node<AcroNode>> children = LinkedHashSet<Node<AcroNode>>(
      equals: (n0, n1) => n0 == n1, hashCode: (n2) => n2.hashCode);

  children.add(
      Node.createLeaf(AcroNode(leaf1Name, true, leaf1Name, onSwitch, delete)));
  children.add(
      Node.createLeaf(AcroNode(leaf2Name, false, leaf2Name, onSwitch, delete)));
  children.add(
      Node.createLeaf(AcroNode(leaf3Name, true, leaf3Name, onSwitch, delete)));

  Node<AcroNode> simpleTree = Node(
      children, false, AcroNode(rootName, true, rootName, onSwitch, delete));
  return simpleTree;
}

Node<AcroNode> createComplexTree() {
  LinkedHashSet<Node<AcroNode>> children = LinkedHashSet<Node<AcroNode>>(
      equals: (n0, n1) => n0 == n1, hashCode: (n2) => n2.hashCode);

  children.add(createSimpleTree(rootName: 'root1'));
  children.add(createSimpleTree(rootName: 'root2'));
  children.add(createSimpleTree(rootName: 'root3'));

  Node<AcroNode> root =
      Node(children, false, AcroNode('root', true, 'root', onSwitch, delete));

  return root;
}

class HotReload extends StatelessWidget {
  const HotReload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      categories: [
        WidgetbookCategory(
          name: 'widgets',
          widgets: [
            WidgetbookComponent(
              name: 'Texttest',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => Text("test"),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'List',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => ListView(children: <Widget>[
                    Container(
                      height: 50,
                      child: const Center(child: Text('Entry A')),
                    ),
                    Container(
                      height: 50,
                      child: const Center(child: Text('Entry B')),
                    ),
                    Container(
                      height: 50,
                      child: const Center(child: Text('Entry C')),
                    ),
                  ]),
                ),
              ],
            ),
          ],
          folders: [
            WidgetbookFolder(
              name: 'Posture selection',
              widgets: [
                WidgetbookComponent(
                  name: 'PostureListItem',
                  useCases: [
                    WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) => PostureListItem(
                              isSwitched: context.knobs.boolean(
                                label: 'isSwitched',
                                initialValue: false,
                              ),
                              postureLabel: context.knobs.text(
                                label: 'Label',
                                initialValue: 'Posture1',
                              ),
                              onChanged: onSwitch,
                              delete: delete,
                            )),
                  ],
                ),
                WidgetbookComponent(
                  name: 'PostureCategoryItem',
                  useCases: [
                    WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) => PostureCategoryItem(
                              isSwitched: context.knobs.boolean(
                                label: 'isSwitched',
                                initialValue: false,
                              ),
                              isExpanded: context.knobs.boolean(
                                label: 'isExpanded',
                                initialValue: false,
                              ),
                              categoryLabel: context.knobs.text(
                                label: 'Label',
                                initialValue: 'Category',
                              ),
                            )),
                  ],
                ),
                WidgetbookComponent(
                  name: 'PostureList',
                  useCases: [
                    WidgetbookUseCase(
                        name: 'SimpleTree',
                        builder: (context) =>
                            PostureTree(tree: createSimpleTree())),
                    WidgetbookUseCase(
                        name: 'ComplexTree',
                        builder: (context) =>
                            PostureTree(tree: createComplexTree()))
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
      appInfo: AppInfo(
        name: 'Widgetbook Example',
      ),
      themes: [
        WidgetbookTheme(
          name: 'Light',
          data: ThemeData.light(),
        ),
      ],
      devices: [
        Samsung.s10,
        Apple.iPhone11,
      ],
    );
  }
}
