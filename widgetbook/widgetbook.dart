import 'package:acroulette/widgets/dialogs/category_dialog/create_category_dialog.dart';
import 'package:acroulette/widgets/dialogs/posture_dialog/create_posture_dialog.dart';
import 'package:acroulette/widgets/dialogs/posture_dialog/segmented_view.dart';
import 'package:acroulette/widgets/flows/flow_item.dart';
import 'package:acroulette/widgets/flows/flow_view.dart';
import 'package:acroulette/widgets/flows/flow_position_item.dart';
import 'package:acroulette/widgets/posture_tree/posture_category_item.dart';
import 'package:acroulette/widgets/posture_tree/posture_list_item.dart';
import 'package:acroulette/widgets/posture_tree/posture_tree.dart';
import 'package:acroulette/models/flow_node.dart';
import 'package:acroulette/models/node.dart';
import 'package:acroulette/models/pair.dart';
import 'package:acroulette/widgets/formWidgets/import_export_settings_view.dart';
import 'package:acroulette/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../testdata/trees.dart';

void onSwitch(bool isOn) {}
void onDeleteClick() {}
void onSaveClick(bool isPosture, String? newValue) {}
void onEditClick(String? newValue) {}
void onDeleteClickPostureTree(Node child) {}
void onSaveClickPostureTree(Node child, bool isPosture, String? newValue) {}
void onEditClickPostureTree(Node child, bool isPosture, String? newValue) {}
void import() {}
void export() {}
List<Pair> listAllNodesRecursively() {
  return [];
}

List<Pair> listAllNodesRecursivelyPostureTree(Node root) {
  return [];
}

void showEditPositionDialog(BuildContext context) {
  return;
}

void showDeletePositionDialog(BuildContext context) {
  return;
}

class HotReload extends StatelessWidget {
  const HotReload({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      addons: const [],
      directories: [
        WidgetbookCategory(name: 'widgets', children: [
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
                  name: 'Create Posture Dialog',
                  builder: (context) => CreatePosture(
                        path: const ["root", "parent"],
                        onSaveClick: (posture) => onSaveClick(false, posture),
                      )),
              WidgetbookUseCase(
                  name: 'Create Category Dialog',
                  builder: (context) => CreateCategory(
                        path: const ["root", "parent"],
                        onSaveClick: (category) => onSaveClick(false, category),
                      )),
              WidgetbookUseCase(
                  name: 'Test Dialog',
                  builder: (context) => SegmentedView(
                        selected: context.knobs.int
                            .slider(label: 'Selected part', initialValue: 0),
                        onPressed: (p0) {},
                      )),
            ],
          ),
          WidgetbookComponent(name: 'Loader', useCases: [
            WidgetbookUseCase(
                name: 'Show loader animation',
                builder: (context) => const Loader()),
          ])
        ]),
        WidgetbookFolder(
          name: 'Posture selection',
          children: [
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
                          postureLabel: context.knobs.string(
                            label: 'Label',
                            initialValue: 'Posture1',
                          ),
                          onChanged: onSwitch,
                          showDeletePositionDialog: showDeletePositionDialog,
                          onEditClick: onEditClick,
                          path: const [],
                          enabled: context.knobs
                              .boolean(label: 'enabled', initialValue: true),
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
                    onChanged: (p0) {},
                    categoryLabel: context.knobs.string(
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
                          tree: createSimpleTreeEnabled(),
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
        WidgetbookFolder(name: 'Flow', children: [
          WidgetbookComponent(
            name: 'FlowView',
            useCases: [
              WidgetbookUseCase(
                  name: 'Show',
                  builder: (context) => FlowView(
                        deletePosture: (p0, p1) {},
                        deleteFlow: (p0) {},
                        onEditClick: (p0, p1, p2) {},
                        onEditFlowClick: (p0, p1) {},
                        flow: FlowNode(
                            context.knobs.string(
                                label: 'flow name', initialValue: 'flow1'),
                            ['position1', 'position2']),
                        onSavePostureClick: (p0, p1) {},
                        toggleExpand: (p1) {},
                      )),
            ],
          ),
          WidgetbookComponent(
            name: 'FlowItem',
            useCases: [
              WidgetbookUseCase(
                  name: 'Show',
                  builder: (context) => FlowItem(
                        flowLabel: context.knobs.string(
                          label: 'Label',
                          initialValue: 'Flow1',
                        ),
                        onEditClick: onEditClick,
                        onSavePostureClick: (p0) {},
                        showDeleteFlowDialog: (BuildContext context) {},
                      )),
            ],
          ),
          WidgetbookComponent(
            name: 'FlowPositionItem',
            useCases: [
              WidgetbookUseCase(
                  name: 'Show',
                  builder: (context) => FlowPositionItem(
                      positionLabel: context.knobs.string(
                        label: 'Label',
                        initialValue: 'Position1',
                      ),
                      showDeletePositionDialog: showDeletePositionDialog,
                      showEditPositionDialog: showEditPositionDialog)),
            ],
          )
        ]),
        WidgetbookFolder(name: 'ImportExport', children: [
          WidgetbookComponent(
            name: 'Export',
            useCases: [
              WidgetbookUseCase(
                  name: 'ShowExport',
                  builder: (context) => const ImportExportSettingsView(
                      import: import, export: export))
            ],
          ),
        ])
      ],
    );
  }
}
