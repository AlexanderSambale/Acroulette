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

createSimpleTree() {
  LinkedHashSet<Node<AcroNode>> children = LinkedHashSet<Node<AcroNode>>(
      equals: (n0, n1) => n0 == n1, hashCode: (n2) => n2.hashCode);

  children
      .add(Node.createLeaf(AcroNode('leaf1', true, 'leaf1', onSwitch, delete)));
  children.add(
      Node.createLeaf(AcroNode('leaf2', false, 'leaf2', onSwitch, delete)));
  children
      .add(Node.createLeaf(AcroNode('leaf3', true, 'leaf3', onSwitch, delete)));

  Node<AcroNode> simpleTree =
      Node(children, false, AcroNode('root', true, 'root', onSwitch, delete));
  return simpleTree;
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
                        name: 'Default',
                        builder: (context) =>
                            PostureTree(tree: createSimpleTree()))
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
