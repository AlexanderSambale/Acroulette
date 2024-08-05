import 'package:acroulette/helper/objectbox/to_many_extension.dart';
import 'package:acroulette/models/node.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('containsElementWithLabel', () {
    String testLabel = 'test';
    List<Node> children = [];
    expect(children.containsElementWithLabel(false, testLabel), false);
    expect(children.containsElementWithLabel(true, testLabel), false);

    Node testPosture = Node.createLeaf(label: testLabel);
    children.add(testPosture);
    expect(children.containsElementWithLabel(true, testLabel), true);
    expect(children.containsElementWithLabel(false, testLabel), false);
    children.remove(testPosture);

    Node testCategory = Node.optional(label: testLabel);
    children.add(testCategory);
    expect(children.containsElementWithLabel(false, testLabel), true);
    expect(children.containsElementWithLabel(true, testLabel), false);
    children.add(testPosture);
    expect(children.containsElementWithLabel(false, testLabel), true);
    expect(children.containsElementWithLabel(true, testLabel), true);
  });
}
