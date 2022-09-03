import 'package:acroulette/components/postureCategoryItem/posture_category_item.dart';
import 'package:acroulette/components/postureListItem/posture_list_item.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

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
                        builder: (context) => PostureListItem()),
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
                        builder: (context) => PostureListItem()),
                  ],
                ),
                WidgetbookComponent(
                  name: 'PostureList',
                  useCases: [
                    WidgetbookUseCase(
                        name: 'Default',
                        builder: (context) => PostureListItem()),
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
