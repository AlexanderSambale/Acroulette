import 'package:acroulette/models/acro_node.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('convert AcroNode to String and back', () {
    AcroNode testNode = AcroNode(false, 'test');
    String testNodeAsJsonString = testNode.toString();
    AcroNode testNodeTransformed =
        AcroNode.createFromString(testNodeAsJsonString);
    expect(testNodeTransformed.isSwitched, testNode.isSwitched);
    expect(testNodeTransformed.label, testNode.label);
    expect(testNode.isEnabled, testNodeTransformed.isEnabled);
  });
}
