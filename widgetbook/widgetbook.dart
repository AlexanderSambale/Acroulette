import 'package:acroulette/components/dialogs/posture_dialog/create_posture_dialog.dart';
import 'package:acroulette/components/dialogs/posture_dialog/segmented_view.dart';
import 'package:acroulette/components/posture_tree/posture_category_item.dart';
import 'package:acroulette/components/posture_tree/posture_list_item.dart';
import 'package:acroulette/components/posture_tree/posture_tree.dart';
import 'package:acroulette/models/acro_node.dart';
import 'package:acroulette/models/node.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

onSwitch(bool isOn) {}
onDeleteClick() {}
onSaveClick(bool isCategory, String? newValue) {}
onEditClick(String? newValue) {}
onEditClickCategory(bool isCategory, String? newValue) {}
onDeleteClickPostureTree(Node child) {}
onSaveClickPostureTree(Node child, bool isCategory, String? newValue) {}
onEditClickPostureTree(Node child, bool isCategory, String? newValue) {}

Node createSimpleTree(
    {String rootName = 'root',
    String leaf1Name = 'leaf1',
    String leaf2Name = 'leaf2',
    String leaf3Name = 'leaf3'}) {
  Node leaf1 = Node.createLeaf(AcroNode(true, leaf1Name));
  Node leaf2 = Node.createLeaf(AcroNode(false, leaf2Name));
  Node leaf3 = Node.createLeaf(AcroNode(true, leaf3Name));
  Node category =
      Node.createCategory([leaf1, leaf2, leaf3], AcroNode(true, rootName));
  return category;
}

Node createComplexTree() {
  Node root = Node.createCategory([
    createSimpleTree(rootName: 'root1'),
    createSimpleTree(rootName: 'root2'),
    createSimpleTree(rootName: 'root3')
  ], AcroNode(true, 'root'));
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
                  builder: (context) => const Text("test"),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'List',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => ListView(children: const <Widget>[
                    SizedBox(
                      height: 50,
                      child: Center(child: Text('Entry A')),
                    ),
                    SizedBox(
                      height: 50,
                      child: Center(child: Text('Entry B')),
                    ),
                    SizedBox(
                      height: 50,
                      child: Center(child: Text('Entry C')),
                    ),
                  ]),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Dialog',
              useCases: [
                WidgetbookUseCase(
                    name: 'Create Dialog',
                    builder: (context) => CreatePosture(
                          path: const ["root", "parent"],
                          onSaveClick: (posture) => onSaveClick(false, posture),
                        )),
                WidgetbookUseCase(
                    name: 'Test Dialog',
                    builder: (context) => SegmentedView(
                          selected: context.knobs
                              .number(
                                label: 'selected part',
                                initialValue: 0,
                              )
                              .toInt(),
                          onPressed: (p0) {},
                        )),
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
                              onDeleteClick: onDeleteClick,
                              onEditClick: onEditClick,
                              path: const [],
                              enabled: context.knobs.boolean(
                                  label: 'enabled', initialValue: true),
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
                          initialValue: true,
                        ),
                        onChanged: (p0) {},
                        toggleExpand: () {},
                        categoryLabel: context.knobs.text(
                          label: 'Label',
                          initialValue: 'Category',
                        ),
                        enabled: context.knobs
                            .boolean(label: 'enabled', initialValue: true),
                        path: const [],
                        onDeleteClick: onDeleteClick,
                        onEditClick: onEditClickCategory,
                        onSaveClick: onSaveClick,
                      ),
                    ),
                  ],
                ),
                WidgetbookComponent(
                  name: 'PostureList',
                  useCases: [
                    WidgetbookUseCase(
                        name: 'SimpleTree',
                        builder: (context) => PostureTree(
                              tree: createSimpleTree(),
                              onSwitched: (b, n) {},
                              toggleExpand: (n) {},
                              path: const [],
                              onDeleteClick: onDeleteClickPostureTree,
                              onEditClick: onEditClickPostureTree,
                              onSaveClick: onSaveClickPostureTree,
                            )),
                    WidgetbookUseCase(
                        name: 'ComplexTree',
                        builder: (context) => PostureTree(
                              tree: createComplexTree(),
                              onSwitched: (b, n) {},
                              toggleExpand: (n) {},
                              path: const [],
                              onDeleteClick: onDeleteClickPostureTree,
                              onEditClick: onEditClickPostureTree,
                              onSaveClick: onSaveClickPostureTree,
                            ))
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
