import 'package:acroulette/models/acro_node.dart';
import 'package:acroulette/models/helper/objectbox/to_many_extension.dart';
import 'package:acroulette/models/node.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

void main() {
  late IsarLinks<Node> children;

  setUp(() async {
    children = IsarLinks<Node>();
  });

  test('containsElementWithLabel', () {
    String testLabel = 'test';
    Node testPosture = Node.createLeaf(AcroNode(true, testLabel));
    Node testCategory = Node.createCategory([], AcroNode(true, testLabel));
    expect(children.containsElementWithLabel(false, testLabel), false);
    expect(children.containsElementWithLabel(true, testLabel), false);
    children.add(testPosture);
    expect(children.containsElementWithLabel(true, testLabel), true);
    expect(children.containsElementWithLabel(false, testLabel), false);
    children.remove(testPosture);
    children.add(testCategory);
    expect(children.containsElementWithLabel(false, testLabel), true);
    expect(children.containsElementWithLabel(true, testLabel), false);
    children.add(testPosture);
    expect(children.containsElementWithLabel(false, testLabel), true);
    expect(children.containsElementWithLabel(true, testLabel), true);
  });
}
