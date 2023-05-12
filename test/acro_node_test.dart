import 'package:acroulette/models/acro_node.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('convert FlowNod to String and back', () {
    var testNode = AcroNode(false, 'test');
    var testNodeAsJsonString = testNode.toString();
    var testNodeTransformed = AcroNode.createFromString(testNodeAsJsonString);
    expect(testNodeTransformed.isSwitched, testNode.isSwitched);
    expect(testNodeTransformed.label, testNode.label);
  });
}
