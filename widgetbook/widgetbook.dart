import 'package:acroulette/components/dialogs/posture_dialog/create_posture_dialog.dart';
import 'package:acroulette/components/dialogs/posture_dialog/segmented_view.dart';
import 'package:acroulette/components/posture_tree/posture_category_item.dart';
import 'package:acroulette/components/posture_tree/posture_list_item.dart';
import 'package:acroulette/components/posture_tree/posture_tree.dart';
import 'package:acroulette/models/node.dart';
import 'package:acroulette/models/pair.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../test/position_administration_bloc_test.dart';

void onSwitch(bool isOn) {}
void onDeleteClick() {}
void onSaveClick(bool isPosture, String? newValue) {}
void onEditClick(String? newValue) {}
void onDeleteClickPostureTree(Node child) {}
void onSaveClickPostureTree(Node child, bool isPosture, String? newValue) {}
void onEditClickPostureTree(Node child, bool isPosture, String? newValue) {}
List<Pair> listAllNodesRecursively() {
  return [];
}

List<Pair> listAllNodesRecursivelyPostureTree(Node root) {
  return [];
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
                        onEditClick: onEditClick,
                        onSaveClick: onSaveClick,
                        listAllNodesRecursively: listAllNodesRecursively,
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
                              listAllNodesRecursively:
                                  listAllNodesRecursivelyPostureTree,
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
                              listAllNodesRecursively:
                                  listAllNodesRecursivelyPostureTree,
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
